import 'package:dream_home_user/features/Profile/profile_screen.dart';
import 'package:dream_home_user/features/architecture/architecture_screen.dart';
import 'package:dream_home_user/features/owned/owned_screen.dart';
import 'package:dream_home_user/features/recommendation/recommendddation_screen.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RecommendationScreen(),
    ArchitectureScreen(),
    OwnedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GNav(
            rippleColor: Colors.grey[800]!,
            hoverColor: Colors.grey[700]!,
            haptic: true,
            tabBorderRadius: 25,
            tabActiveBorder: Border.all(color: onprimaryColor, width: 1),
            tabBorder: Border.all(color: Colors.grey[800]!, width: 1),
            tabShadow: [
              BoxShadow(color: Colors.grey.withAlpha(5), blurRadius: 8)
            ],
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 200),
            gap: 8,
            color: Colors.grey[800],
            activeColor: Colors.white,
            iconSize: 24,
            tabBackgroundColor: Colors.black.withAlpha(1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            selectedIndex: _selectedIndex, // Ensure selected tab is highlighted
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index; // Update index when tab is selected
              });
            },
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.architecture_sharp,
                text: 'Architect',
              ),
              GButton(
                icon: LineIcons.archive,
                text: 'Owned',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
