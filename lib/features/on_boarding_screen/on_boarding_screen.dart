import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/features/signin/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final SwiperController _swiperController = SwiperController();

  final List<String> images = [
    'https://images.unsplash.com/photo-1556702571-3e11dd2b1a92?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fA%3D%3D',
    'https://img.freepik.com/free-photo/minimalist-architecture-space_23-2151912509.jpg?t=st=1739373840~exp=1739377440~hmac=5fd2ad4543ce69aab55d994844ba837b8300b5137d64a9eabbf0d81c262af5f2&w=360',
    'https://img.freepik.com/free-photo/view-luxurious-villa-with-modern-architectural-design_23-2151694025.jpg?t=st=1739373934~exp=1739377534~hmac=e62fef3ce827f1b002bb8e1cec1a5a8efd06e0e63e7d8bae756317e6b3629bf4&w=360',
  ];
  final List<String> titles = [
    'Discover your perfect property in minutes!',
    'Find modern architecture with ease!',
    'Luxury homes at your fingertips!',
  ];
  final List<String> subtitles = [
    'With smart filters, real-time prices, and detailed photos.',
    'Browse a variety of stylish homes effortlessly.',
    'Get access to premium listings instantly.',
  ];
  final List<Alignment> textAlignments = [
    Alignment.bottomCenter,
    Alignment.centerLeft,
    Alignment.topCenter,
  ];
  final List<TextAlign> textAlignmentModes = [
    TextAlign.center,
    TextAlign.left,
    TextAlign.center,
  ];

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      User? currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        controller: _swiperController,
        itemCount: images.length,
        loop: false,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.white,
            color: Colors.grey,
          ),
        ),
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              Align(
                alignment: textAlignments[index],
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: index == 1 ? 0 : 80.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: index == 1
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        titles[index],
                        textAlign: textAlignmentModes[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitles[index],
                        textAlign: textAlignmentModes[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              if (index != images.length - 1)
                Positioned(
                  top: 40,
                  right: 5,
                  child: TextButton(
                    onPressed: () {
                      _swiperController.move(images.length - 1);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              if (index == images.length - 1)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninScreen(),
                              ));
                        },
                        label: 'Next',
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
