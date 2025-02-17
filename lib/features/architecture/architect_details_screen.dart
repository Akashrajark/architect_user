import 'package:dream_home_user/features/home_plan/home_plan.dart';
import 'package:dream_home_user/features/recommendation/home_plan_card.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ArchitectDetailsScreen extends StatelessWidget {
  const ArchitectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
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
            SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://c.pxhere.com/photos/93/c7/businessman_man_portrait_male_costume_business_office_office_style-815849.jpg!d'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sarah Anderson',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Senior Architect, LEED AP',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text(
              'Description',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Award-winning architect with 12+ years of experience in sustainable design and urban development. Specialized in contemporary residential and commercial projects with a focus on environmental innovation.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text(
              'Education',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master of Architecture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Harvard Graduate School of Design',
                style: TextStyle(fontSize: 16)),
            const Text('2008-2010',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text(
              'Bachelor of Environmental Design',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('UC Berkeley', style: TextStyle(fontSize: 16)),
            const Text('2004-2008',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 32),
            const Text(
              'Experience',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Senior Architect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Foster + Partners', style: TextStyle(fontSize: 16)),
            const Text('2015-Present',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Lead architect for sustainable commercial projects, managing teams of 15+ professionals and overseeing projects valued at \$50M+.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text(
              'Projects',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => HomePlanCard(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePlan(
                              isPaid: true,
                            )),
                  );
                },
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 3,
            ),
          ],
        ),
      ),
    );
  }
}
