import 'package:dream_home_user/features/home_plan/home_plan.dart';
import 'package:dream_home_user/features/recommendation/home_plan_card.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                'https://img.freepik.com/free-photo/minimalist-architecture-space_23-2151912514.jpg?t=st=1739418556~exp=1739422156~hmac=b328070c2bf6ccdbee121fc1c124b901ad27c12acd2040e103f874d9d65500f6&w=360',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 100,
              left: 10,
              child: Text(
                'Book Your Dream!',
                style: TextStyle(fontSize: 25, color: onprimaryColor),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 10,
              child: Text(
                'check out all the plans you have',
                style: TextStyle(fontSize: 15, color: onprimaryColor),
              ),
            ),
            Positioned(
              bottom: 13,
              left: 10,
              right: 10,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  suffixIcon: Icon(Icons.filter_alt),
                  fillColor: Colors.grey[200],
                  prefixIcon: LineIcon.search(),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended',
                      style: TextStyle(fontSize: 18, color: onSecondaryColor),
                    ),
                  ),
                  Material(
                    shadowColor: onSecondaryColor,
                    borderRadius: BorderRadius.circular(20),
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'View All',
                        style: TextStyle(color: Colors.grey[800], fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
              ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => HomePlanCard(
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePlan(),
                              ));
                        },
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                  itemCount: 5)
            ],
          ),
        ),
      ],
    );
  }
}
