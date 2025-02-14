import 'package:dream_home_user/features/signin/signin_screen.dart';
import 'package:dream_home_user/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ocHZidnd2b2N6bG53a3lhd2ZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI5NDg1NzcsImV4cCI6MjA0ODUyNDU3N30.0lTn_YdvE2tBvF58wB6KOpGEIQOZdd3lpU_OsfFVpKY',
      url: 'https://mhpvbvwvoczlnwkyawfj.supabase.co');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SigninScreen(),
    );
  }
}
