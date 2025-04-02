import 'package:dream_home_user/common_widgets.dart/home_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import 'home_plan_details.dart';
import 'homeplans_bloc/homeplans_bloc.dart';

class Homeplans extends StatefulWidget {
  final int? categoryId;
  final int? bathrooms, bedrooms;
  const Homeplans({super.key, this.categoryId, this.bathrooms, this.bedrooms});

  @override
  State<Homeplans> createState() => _HomeplansState();
}

class _HomeplansState extends State<Homeplans> {
  final HomeplansBloc _homeplansBloc = HomeplansBloc();

  Map<String, dynamic> params = {
    'query': null,
    'category_id': null,
    'bathrooms': null,
    'bedrooms': null,
  };

  List<Map<String, dynamic>> _homeplans = [];

  @override
  void initState() {
    params['category_id'] = widget.categoryId;
    params['bathrooms'] = widget.bathrooms;
    params['bedrooms'] = widget.bedrooms;
    getHomeplans();
    super.initState();
  }

  void getHomeplans() {
    _homeplansBloc.add(GetHomeplanByFilterEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeplansBloc,
      child: BlocConsumer<HomeplansBloc, HomeplansState>(
        listener: (context, state) {
          if (state is HomeplansFailureState) {
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
          } else if (state is HomeplansGetSuccessState) {
            _homeplans = state.homeplans;
            Logger().w(_homeplans);
            setState(() {});
          } else if (state is HomeplansSuccessState) {
            getHomeplans();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                if (state is HomeplansLoadingState)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (state is HomeplansGetSuccessState && _homeplans.isEmpty)
                  Center(
                    child: Text("No Homeplan found!"),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    itemBuilder: (context, index) => HomePlanCard(
                      cardData: _homeplans[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePlanDetail(
                              owend: _homeplans[index]['owned'],
                              homeplanId: _homeplans[index]['id'],
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
