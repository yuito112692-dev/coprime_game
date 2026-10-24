import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_page.dart';
import 'pages/onlineplay_page.dart';
import 'pages/twoplay_page.dart';
import 'pages/wait_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  // Open a Hive box (you can name it as you like)
  await Hive.openBox('nameBox');

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://qgclfeuwwjaqpuueuiuj.supabase.co',
    publishableKey: 'sb_publishable_gKgq97UGOV2pbRrviFTnNQ_ptDGhOXW',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '互いに素ゲーム',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/onlineplay': (context) => const OnlinePlayPage(),
        '/twoplay': (context) => const TwoPlayPage(),
        '/wait': (context) => const WaitPage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[350],
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Color.fromARGB(255, 139, 203, 255),
              width: 2.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}