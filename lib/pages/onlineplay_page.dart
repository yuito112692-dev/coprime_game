import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlinePlayPage extends StatefulWidget {
  const OnlinePlayPage({super.key});

  @override
  State<OnlinePlayPage> createState() => _OnlinePlayPageState();
}

class _OnlinePlayPageState extends State<OnlinePlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレイ画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('プレイ画面'),
          ],
        ),
      )
    );
  }
}