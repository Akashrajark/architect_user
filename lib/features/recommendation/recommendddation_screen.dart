import 'dart:async';
import 'package:dream_home_user/common_widgets.dart/custom_search.dart';
import 'package:dream_home_user/features/home_plan/home_plan.dart';
import 'package:dream_home_user/features/recommendation/category_card.dart';
import 'package:dream_home_user/features/recommendation/category_view_all_screen.dart';
import 'package:dream_home_user/features/recommendation/home_plan_card.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  // List of image paths (replace with your actual image paths)
  final List<String> imageList = const [
    'assets/images/home1.jpg',
    'assets/images/home4.jpg',
    'assets/images/home2.jpg',
    'assets/images/home3.jpg',
  ];

  // PageController to manage PageView
  final PageController _pageController = PageController();

  // Timer for auto-changing images
  Timer? _timer;

  // Current page index
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start auto-changing images
    _startTimer();
  }

  @override
  void dispose() {
    // Dispose the timer and page controller
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Function to start the timer for auto-changing images
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < imageList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      children: [
        Stack(
          children: [
            // Background Image as PageView
            SizedBox(
              height: 350, // Adjust the height as needed
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageList.length, // Number of images
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            imageList[index]), // Use the image from the list
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
            // Search and Filter Icon at the bottom
            Positioned(
              bottom: 20, // Adjust the position as needed
              left: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearch(
                        onSearch: (p0) {},
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.tune_outlined,
                          color: Colors.white), // Adjust icon color if needed
                    ),
                  ],
                ),
              ),
            ),
            // Dot Indicator at the bottom center
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageList.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                  fontSize: 18,
                  color: onSecondaryColor,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryViewAllScreen(),
                    ));
              },
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 2,
                shadowColor: primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text('View all'),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => const CategoryCard(),
              separatorBuilder: (context, index) => const SizedBox(
                    width: 5,
                  ),
              itemCount: 5),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Recommended',
          style: TextStyle(
              fontSize: 18,
              color: onSecondaryColor,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => HomePlanCard(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePlan(
                            isPaid: true,
                          ),
                        ));
                  },
                ),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
            itemCount: 5)
      ],
    );
  }
}
