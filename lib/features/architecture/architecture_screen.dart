import 'package:dream_home_user/common_widgets.dart/custom_search.dart';
import 'package:dream_home_user/features/architecture/architect_details_screen.dart';
import 'package:dream_home_user/features/architecture/architect_view_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'architect_bloc/architects_bloc.dart';

class ArchitectureScreen extends StatefulWidget {
  const ArchitectureScreen({super.key});

  @override
  State<ArchitectureScreen> createState() => _ArchitectureScreenState();
}

class _ArchitectureScreenState extends State<ArchitectureScreen> {
  final ArchitectsBloc _architectsBloc = ArchitectsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _architects = [];

  @override
  void initState() {
    checkLogin(context);
    getArchitects();
    super.initState();
  }

  void getArchitects() {
    _architectsBloc.add(GetAllArchitectsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
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
          } else if (state is ArchitectsGetSuccessState) {
            _architects = state.architects;
            Logger().w(_architects);
            setState(() {});
          } else if (state is ArchitectsSuccessState) {
            getArchitects();
          }
        },
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                children: [
                  CustomSearch(
                    onSearch: (query) {
                      params['query'] = query;
                      getArchitects();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (state is ArchitectsLoadingState)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (state is ArchitectsGetSuccessState && _architects.isEmpty)
                    Center(
                      child: Text("No Architect found!"),
                    ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 100),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _architects.length,
                      itemBuilder: (context, index) => ArchitectViewCard(
                        architectDetails: _architects[index],
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArchitectDetailsScreen(
                                architectDetails: _architects[index],
                              ),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                      ),
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
