import 'package:dream_home_user/features/home_plan/home_plan_details.dart';
import 'package:dream_home_user/common_widgets.dart/home_plan_card.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:dream_home_user/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import 'architect_bloc/architects_bloc.dart';

class ArchitectDetailsScreen extends StatefulWidget {
  final Map architectDetails;
  const ArchitectDetailsScreen({super.key, required this.architectDetails});

  @override
  State<ArchitectDetailsScreen> createState() => _ArchitectDetailsScreenState();
}

class _ArchitectDetailsScreenState extends State<ArchitectDetailsScreen> {
  final ArchitectsBloc _architectsBloc = ArchitectsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _homeplans = [];

  @override
  void initState() {
    getArchitects();
    super.initState();
  }

  void getArchitects() {
    _architectsBloc.add(GetAllArchitectHomeplansEvent(params: params, architectId: widget.architectDetails['user_id']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 15,
            child: Icon(
              Icons.chevron_left,
              color: secondaryColor,
            ),
          ),
        ),
      ),
      body: BlocProvider.value(
        value: _architectsBloc,
        child: BlocConsumer<ArchitectsBloc, ArchitectsState>(
          listener: (context, state) {
            if (state is ArchitectsFailureState) {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Failure',
                  description: state.message,
                  primaryButton: 'Try Again',
                  onPrimaryPressed: () {
                    getArchitects();
                    Navigator.pop(context);
                  },
                ),
              );
            } else if (state is ArchitectHomeplansGetSuccessState) {
              _homeplans = state.homeplans;
              Logger().w(_homeplans);
              setState(() {});
            } else if (state is ArchitectsSuccessState) {
              getArchitects();
            }
          },
          builder: (context, state) {
            return ListView(
              children: [
                if (widget.architectDetails['photo'] != null)
                  Image.network(
                    widget.architectDetails['photo'],
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatValue(widget.architectDetails['name']),
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatValue(widget.architectDetails['email']),
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      // Text(
                      //   formatValue(widget.architectDetails['phone']),
                      //   style: TextStyle(fontSize: 18, color: Colors.grey),
                      // ),
                      const SizedBox(height: 10),
                      const Text(
                        'Projects',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => HomePlanCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePlanDetail(
                                  owend: _homeplans[index]['owned'],
                                  homeplanId: _homeplans[index]['id'],
                                ),
                              ),
                            );
                          },
                          cardData: _homeplans[index],
                        ),
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: _homeplans.length,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
