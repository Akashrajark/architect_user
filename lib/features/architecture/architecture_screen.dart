import 'package:dream_home_user/common_widgets.dart/custom_search.dart';
import 'package:dream_home_user/features/architecture/architect_details_screen.dart';
import 'package:dream_home_user/features/architecture/architect_view_card.dart';
import 'package:flutter/material.dart';

class ArchitectureScreen extends StatelessWidget {
  const ArchitectureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        children: [
          CustomSearch(
            onSearch: (query) {},
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: 100,
              itemBuilder: (context, index) => ArchitectViewCard(
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArchitectDetailsScreen(),
                      ));
                },
              ),
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
