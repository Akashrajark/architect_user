import 'dart:typed_data';

import 'package:dream_home_user/common_widgets.dart/custom_alert_dialog.dart';
import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/features/image_generation/generated_homeplans.dart';
import 'package:dream_home_user/features/image_generation/personal_homeplans_bloc/personal_homeplans_bloc.dart';
import 'package:dream_home_user/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:dream_home_user/common_widgets.dart/feature_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_genration.dart';

class GeneratedHomeplanDetails extends StatefulWidget {
  final bool useNetworkImage;
  final Map homeplan;
  const GeneratedHomeplanDetails({
    super.key,
    required this.homeplan,
    this.useNetworkImage = false,
  });

  @override
  State<GeneratedHomeplanDetails> createState() => _GeneratedHomeplanDetailsState();
}

class _GeneratedHomeplanDetailsState extends State<GeneratedHomeplanDetails> {
  Map _homeplan = {};
  List _floors = [];

  @override
  void initState() {
    _homeplan = widget.homeplan;
    _floors = _homeplan['floors'] ?? [];
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalHomeplansBloc(),
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
          } else if (state is PersonalHomeplansLoadingState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Loading',
                description: 'This may take a minute or so. Please wait...',
              ),
            );
          } else if (state is PersonalHomeplansSuccessState) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => GeneratedHomeplansScreen(
                  isInGeneration: true,
                ),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (widget.useNetworkImage)
                        Image.network(
                          _homeplan['image'],
                          fit: BoxFit.cover,
                          height: 400,
                          width: double.infinity,
                        )
                      else if (_homeplan['image_file'] != null)
                        Image.memory(
                          _homeplan['image_file'],
                          fit: BoxFit.cover,
                          height: 400,
                          width: double.infinity,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40),
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
                            SizedBox(),
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
                            onImageGenerated: (imagedata) {
                              output['floors'][index]['image_file'] = imagedata;
                            },
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
            bottomSheet: Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.all(16.0),
              child: CustomButton(
                label: 'Save Homeplan',
                onPressed: () {
                  BlocProvider.of<PersonalHomeplansBloc>(context).add(
                    AddPersonalHomeplanEvent(
                      personalhomeplanDetails: output,
                    ),
                  );
                },
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
  final Function(Uint8List) onImageGenerated;
  const GeneratedFloorCard({
    super.key,
    required this.floorDetails,
    required this.onImageGenerated,
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
        if (floorDetails['image_file'] != null)
          Image.memory(
            floorDetails['image_file'],
            fit: BoxFit.cover,
            width: double.infinity,
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImageGenration(
              prompt: floorDetails['image_prompt'],
              onImageGenerated: onImageGenerated,
            ),
          ),
      ],
    );
  }
}
