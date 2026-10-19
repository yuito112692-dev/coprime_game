import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

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
        '/play': (context) => const PlayPage(),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> _createOrJoinRandomMatch(BuildContext context) async {
    try {
      final response = await supabase.from('random_match').select()
        .eq('status', 'waiting').maybeSingle();
      if (response != null) {
        // 既存の部屋が見つかった場合、参加する
        final roomId = response['id'];
        print('既存の部屋に参加します： $roomId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('既存の部屋に参加しました: $roomId')),
        );
      } else {
        try {
          final response = await supabase.from('random_match').insert({
            'status': 'waiting',
          }).select();

          print('部屋が作られました： $response');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('部屋が作られました')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('エラー: $e')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  }

  Future<void> _createOrJoinPrivateMatch(BuildContext context, String roomCode) async {
    
    try {
      final response = await supabase.from('private_match').select()
        .eq('status', 'waiting').eq('room_code', roomCode).maybeSingle();
      if (response != null) {
        // 既存の部屋が見つかった場合、参加する
        final roomId = response['id'];
        print('既存の部屋に参加します： $roomId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('既存の部屋に参加しました: $roomId')),
        );
      } else {
        try {
          final response = await supabase.from('private_match').insert({
            'status': 'waiting',
            'room_code': roomCode,
          }).select();

          print('部屋が作られました： $response');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('部屋が作られました')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('エラー: $e')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  }

  Future<void> _roomCodeDialog(BuildContext context) async {
    String roomCode = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('合言葉を入力してください'),
          content: TextField(
            onChanged: (value) {
              roomCode = value;
            },
            decoration: const InputDecoration(hintText: "合言葉"),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
              child: const Text('決定'),
              onPressed: () {
                Navigator.of(context).pop();
                _createOrJoinPrivateMatch(context, roomCode);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _roomCodeDialog(context);
                    });
                  },
                  child: const Text('プライベート'),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _createOrJoinRandomMatch(context);
                    });
                  },
                  child: const Text('ランダムマッチ'),
                ),
              ]
            )
          ],
        ),
      )
    );
  }
}

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
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