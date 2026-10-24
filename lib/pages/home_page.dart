import 'package:flutter/material.dart';

import '../globals.dart';

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
        roomType = 'random';
        randomMatchId = response['id'];
        try {
          await supabase.from('random_match').update({
            'status': 'playing',
          }).eq('id', randomMatchId);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('エラー: $e')),
          );
        }
        Navigator.pushNamed(context, '/play');
      } else {
        try {
          final response = await supabase.from('random_match').insert({
            'status': 'waiting',
          }).select();
          roomType = 'random';
          randomMatchId = response[0]['id'];
          Navigator.pushNamed(context, '/wait');
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
        privateMatchId = response['id'];
        roomType = 'private';
        try {
          await supabase.from('private_match').update({
            'status': 'playing',
          }).eq('id', privateMatchId);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('エラー: $e')),
          );
        }
        Navigator.pushNamed(context, '/play');
      } else {
        try {
          final response = await supabase.from('private_match').insert({
            'status': 'waiting',
            'room_code': roomCode,
          }).select();
          roomType = 'private';
          privateMatchId = response[0]['id'];
          Navigator.pushNamed(context, '/wait');
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

    final parentContext = context;

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
                _createOrJoinPrivateMatch(parentContext, roomCode);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //Hiveの処理
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
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/twoplay');
                  },
                  child: const Text('2人で遊ぶ')
                )
              ]
            ),
            const SizedBox(height: 20,),
            const Text('「2人で遊ぶ」のみ遊べます。それ以外は制作中です')
          ],
        ),
      )
    );
  }
}