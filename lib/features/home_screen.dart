import 'package:dream_home_user/features/Profile/profile_screen.dart';
import 'package:dream_home_user/features/architecture/architecture_screen.dart';
import 'package:dream_home_user/features/home_plan/recommendddation_screen.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'image_generation/image_genration.dart';
import '../util/hide_if_keyboard_open.dart';
import 'owned/owned_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        actions: [
          if (_selectedIndex == 0)
            InkWell(
              splashColor: Colors.white.withAlpha(100),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HousePlanChatScreen()));
              },
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Lottie.asset(
                  'assets/animation/ai.json',
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                ),
              ),
            ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _pages[_selectedIndex],
          if (!isKeyboardOpen(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: Material(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(64),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: GNav(
                        rippleColor: Colors.grey[800]!,
                        hoverColor: Colors.grey[700]!,
                        haptic: true,
                        tabBorderRadius: 25,
                        tabActiveBorder: Border.all(color: onprimaryColor, width: 1),
                        tabBorder: Border.all(color: Colors.grey, width: 1),
                        tabShadow: [BoxShadow(color: Colors.grey.withAlpha(5), blurRadius: 8)],
                        curve: Curves.easeOutExpo,
                        duration: const Duration(milliseconds: 200),
                        gap: 8,
                        color: Colors.grey,
                        activeColor: Colors.white,
                        iconSize: 24,
                        tabBackgroundColor: Colors.black.withAlpha(0),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        tabs: const [
                          GButton(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            icon: LineIcons.home,
                            text: 'Home',
                          ),
                          GButton(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            icon: Icons.architecture_sharp,
                            text: 'Architect',
                          ),
                          GButton(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            icon: LineIcons.archive,
                            text: 'Owned',
                          ),
                          GButton(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            icon: LineIcons.user,
                            text: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
