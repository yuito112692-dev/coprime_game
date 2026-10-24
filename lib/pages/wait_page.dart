import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../globals.dart';
import 'onlineplay_page.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({super.key});

  @override
  State<WaitPage> createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {

  late final RealtimeChannel _roomChannel;
  int roomId = roomType == 'random' ? randomMatchId : privateMatchId;

  @override
  void initState() {
    super.initState();
    // 画面が開いたときに監視をスタート
    _listenRoomStatus();
  }

  void _listenRoomStatus() {
    _roomChannel = supabase.channel('public:$table:$roomId')
      .onPostgresChanges(event: PostgresChangeEvent.update,
        schema: 'public',
        table: table,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: roomId.toString(),
        ),
        callback: (payload) {
          final newData = payload.newRecord;
          final status = newData['status'];
          if (status == 'playing') {
            if (mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnlinePlayPage()));
            }
          }
        }
      ).subscribe();
  }

  @override
  void dispose() {
    // 画面が閉じたときに監視を終了（メモリの無駄遣いを防ぐため）
    supabase.removeChannel(_roomChannel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦相手を探しています…'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('対戦相手を探しています…\nしばらくお待ちください。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (roomType == 'random') {
                    supabase.from('random_match').delete().eq('id', randomMatchId);
                  } else if (roomType == 'private') {
                    supabase.from('private_match').delete().eq('id', privateMatchId);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
          ],
        )
      )
    );
  }
}