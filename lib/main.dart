import 'package:dream_home_user/features/confrm_screen/confirm_screen1.dart';
import 'package:dream_home_user/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
      url: 'https://cpxhjfjyxmyndupizjhb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNweGhqZmp5eG15bmR1cGl6amhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM1ODM2NDMsImV4cCI6MjA1OTE1OTY0M30.sQMoeiLhTHe1CucwMA8Edk3y2x9YGZV9HJkQkZPsWfU');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const ConfirmScreen1(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            viewInsets: EdgeInsets.zero, // Fix keyboard overlap
          ),
          child: child!,
        );
      },
    );
  }
}
