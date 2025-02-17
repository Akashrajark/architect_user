import 'package:dream_home_user/features/home_plan/home_plan.dart';
import 'package:dream_home_user/features/recommendation/home_plan_card.dart';
import 'package:flutter/material.dart';

class OwnedScreen extends StatelessWidget {
  const OwnedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) => HomePlanCard(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePlan(
                                    isPaid: false,
                                  )));
                    },
                    showListTile: true,
                  ),
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
              itemCount: 3),
        )
      ],
    );
  }
}
