import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/features/home_screen.dart';
import 'package:dream_home_user/features/image_generation/generated_homeplan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/feature_card.dart';
import '../../util/format_function.dart';
import 'personal_homeplans_bloc/personal_homeplans_bloc.dart';

class GeneratedHomeplansScreen extends StatefulWidget {
  final bool isInGeneration;
  const GeneratedHomeplansScreen({super.key, this.isInGeneration = false});

  @override
  State<GeneratedHomeplansScreen> createState() => _GeneratedHomeplansScreenState();
}

class _GeneratedHomeplansScreenState extends State<GeneratedHomeplansScreen> {
  final PersonalHomeplansBloc _personalHomeplansBloc = PersonalHomeplansBloc();

  List<Map<String, dynamic>> _homeplans = [];

  @override
  void initState() {
    getHomeplans();
    super.initState();
  }

  void getHomeplans() {
    _personalHomeplansBloc.add(GetAllPersonalHomeplansEvent(params: {}));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _personalHomeplansBloc,
      child: BlocConsumer<PersonalHomeplansBloc, PersonalHomeplansState>(
        listener: (context, state) {
          if (state is PersonalHomeplansFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getHomeplans();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is PersonalHomeplansGetSuccessState) {
            _homeplans = List<Map<String, dynamic>>.from(state.personalhomeplans);
            Logger().w(_homeplans);
            setState(() {});
          } else if (state is PersonalHomeplansSuccessState) {
            getHomeplans();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Generated Homeplans"),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              leading: widget.isInGeneration
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    )
                  : null,
            ),
            body: Column(
              children: [
                if (state is PersonalHomeplansLoadingState)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (state is PersonalHomeplansGetSuccessState && _homeplans.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text("No Homeplan found!"),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    itemBuilder: (context, index) => GeneratedHomeplanCard(
                      useNetworkImage: true,
                      cardData: _homeplans[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeneratedHomeplanDetailsNetwork(
                              homeplan: _homeplans[index],
                            ),
                          ),
                        ).then((value) {
                          getHomeplans();
                        });
                      },
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemCount: _homeplans.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GeneratedHomeplanDetailsNetwork extends StatefulWidget {
  final Map homeplan;
  const GeneratedHomeplanDetailsNetwork({
    super.key,
    required this.homeplan,
  });

  @override
  State<GeneratedHomeplanDetailsNetwork> createState() => _GeneratedHomeplanDetailsNetworkState();
}

class _GeneratedHomeplanDetailsNetworkState extends State<GeneratedHomeplanDetailsNetwork> {
  Map _homeplan = {};
  List _floors = [];

  @override
  void initState() {
    _homeplan = widget.homeplan;
    _floors = _homeplan['personal_floor_plan'];
    super.initState();
  }

  int getTotalBedrooms(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms = property['bedroom_count'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }

  int getTotalBathroom(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms = property['bathroom_count'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }

  final PersonalHomeplansBloc _personalHomeplansBloc = PersonalHomeplansBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _personalHomeplansBloc,
      child: BlocConsumer<PersonalHomeplansBloc, PersonalHomeplansState>(
        listener: (context, state) {
          if (state is PersonalHomeplansFailureState) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Error',
                description: state.message,
              ),
            );
          } else if (state is PersonalHomeplansSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (widget.homeplan['image'] != null)
                        Image.network(
                          _homeplan['image'],
                          fit: BoxFit.cover,
                          height: 400,
                          width: double.infinity,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 15,
                                child: Icon(Icons.chevron_left),
                              ),
                            ),
                            CustomButton(
                              inverse: true,
                              iconData: Icons.delete,
                              backGroundColor: Colors.red,
                              label: 'Delete',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: _personalHomeplansBloc,
                                    child: CustomAlertDialog(
                                      title: 'Delete Homeplan',
                                      description: 'Are you sure you want to delete this homeplan?',
                                      primaryButton: 'Delete',
                                      onPrimaryPressed: () {
                                        BlocProvider.of<PersonalHomeplansBloc>(context)
                                            .add(DeletePersonalHomeplanEvent(personalhomeplanId: _homeplan['id']));
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatValue(_homeplan['title']),
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            FeatureCard(
                              text: "${getTotalBedrooms(_floors)} Bed",
                              icon: Icons.bed,
                            ),
                            FeatureCard(
                              icon: Icons.bathtub,
                              text: "${getTotalBathroom(_floors)} Bath",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Plot Details',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FeatureCard(
                              icon: Icons.straighten, // represents length
                              text: "${formatValue(_homeplan['plot_length'])} Length",
                            ),
                            FeatureCard(
                              icon: Icons.straighten, // can use same for width
                              text: "${formatValue(_homeplan['plot_width'])} Width",
                            ),
                            FeatureCard(
                              icon: Icons.square_foot,
                              text: "${formatValue(_homeplan['plot_area'])} Area",
                            ),
                            FeatureCard(
                              icon: Icons.directions, // road facing
                              text: "${formatValue(_homeplan['road_facing'])} Facing",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatValue(_homeplan['description']),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GeneratedFloorCard(
                            floorDetails: _floors[index],
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 30,
                          ),
                          itemCount: _floors.length,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GeneratedFloorCard extends StatelessWidget {
  final Map<String, dynamic> floorDetails;
  const GeneratedFloorCard({
    super.key,
    required this.floorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatValue(floorDetails['name']).toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            FeatureCard(
              text: "${formatValue(floorDetails['bedroom_count'])} Bed",
              icon: Icons.bed,
            ),
            FeatureCard(
              icon: Icons.bathtub,
              text: "${formatValue(floorDetails['bathroom_count'])} Bath",
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          formatValue(floorDetails['description']),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'Image',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Image.network(
          floorDetails['image'],
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        )
      ],
    );
  }
}
