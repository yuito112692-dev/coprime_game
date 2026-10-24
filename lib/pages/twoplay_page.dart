import 'package:flutter/material.dart';
import '../globals.dart';

class TwoPlayPage extends StatefulWidget {
  const TwoPlayPage({super.key});

  @override
  State<TwoPlayPage> createState() => _TwoPlayPageState();
}

class _TwoPlayPageState extends State<TwoPlayPage> {

  TextEditingController _inputNumber = TextEditingController();

  
  List<int?> boxValue = [
    null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
  ];

  List<int> numbers = [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
  ];
  int _turn = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレイ画面')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTable(boxValue: boxValue, selectedBox: selectedBox, onSelected: (boxName) {
              setState(() {
                selectedBox = boxName;
              });
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: TextField(
                controller: _inputNumber,
                decoration: const InputDecoration(hintText: '数字を入力'),
              ),
            ),
            const SizedBox(height: 20),
            Text(numbers.toString()),
            const SizedBox(width: 20,),
            OutlinedButton(
              child: const Text('決定'),
              onPressed: () => setState(() {
                if (selectedBox == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('マスを選んでください'),
                      backgroundColor: Colors.red, // 背景色を赤に
                    ),
                  );
                } else if (int.tryParse(_inputNumber.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('半角数字を入力してください'),
                      backgroundColor: Colors.red,
                    )
                  );
                } else if (!numbers.contains(int.parse(_inputNumber.text))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('その数字は既に入力されています'),
                      backgroundColor: Colors.red,
                    )
                  );
                } else if (!coprime(nearBox(selectedBox!, boxValue), int.parse(_inputNumber.text))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('互いに素ではありません'),
                      backgroundColor: Colors.red,
                    )
                  );
                } else {
                  boxValue[selectedBox!] = int.parse(_inputNumber.text);
                  numbers.remove(int.parse(_inputNumber.text));
                  _inputNumber.clear();
                  numbersCheck(boxValue, numbers);
                  _turn += 1;
                  if (numbers.isEmpty) {
                    if (_turn % 2 == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('後攻の勝ちです'),
                          backgroundColor: Colors.red,
                        )
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('先攻の勝ちです'),
                          backgroundColor: Colors.red,
                        )
                      );
                    }
                  }
                }
              }),
            )
          ],
        )
      )
    );
  }
}