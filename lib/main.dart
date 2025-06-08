import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'login_page.dart';
import 'profil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reuse Mart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OnboardingScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/profil': (context) => const ProfileScreen(),
      },
    );
  }
}