// File: lib/main.dart
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // 
import 'login_page.dart';
import 'profil.dart';
import 'historyPembeli.dart'; // 1. IMPORT HALAMAN HISTORY DI SINI
import 'historyPenitip.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
        '/history': (context) => const HistoryPembeli(),
        '/history_penitip': (context) => const HistoryPenitipPage(),
      },
    );
  }
}