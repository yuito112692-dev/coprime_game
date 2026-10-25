import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// どこからでも使えるインスタンスと変数
final supabase = Supabase.instance.client;

String roomType = '';
int randomMatchId = 0;
int privateMatchId = 0;

String table = '${roomType}_match';




int? selectedBox;

Widget buildTableContainer({
  required int? child, required VoidCallback onTap, required bool isSelected
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 100, height: 100,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[100] : Colors.white,
        border: Border.all(
          color: isSelected ? Color.fromARGB(100, 139, 203, 255) : Color.fromARGB(255, 139, 203, 255),
          width: 2.0,
        ),
      ),
      child: Center(child: Text(child?.toString() ?? '')),
    )
  );
}

Widget buildTable({
  required int? selectedBox, required Function(int) onSelected, required List<int?> boxValue,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTableContainer(
            child: boxValue[0], isSelected: selectedBox == 0,
            onTap: () => onSelected(0)
          ),
          buildTableContainer(
            child: boxValue[1], isSelected: selectedBox == 1,
            onTap: () => onSelected(1)
          ),
          buildTableContainer(
            child: boxValue[2], isSelected: selectedBox == 2,
            onTap: () => onSelected(2)
          ),
          buildTableContainer(
            child: boxValue[3], isSelected: selectedBox == 3,
            onTap: () => onSelected(3)
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTableContainer(
            child: boxValue[4], isSelected: selectedBox == 4,
            onTap: () => onSelected(4)
          ),
          buildTableContainer(
            child: boxValue[5], isSelected: selectedBox == 5,
            onTap: () => onSelected(5)
          ),
          buildTableContainer(
            child: boxValue[6], isSelected: selectedBox == 6,
            onTap: () => onSelected(6)
          ),
          buildTableContainer(
            child: boxValue[7], isSelected: selectedBox == 7,
            onTap: () => onSelected(7)
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTableContainer(
            child: boxValue[8], isSelected: selectedBox == 8,
            onTap: () => onSelected(8)
          ),
          buildTableContainer(
            child: boxValue[9], isSelected: selectedBox == 9,
            onTap: () => onSelected(9)
          ),
          buildTableContainer(
            child: boxValue[10], isSelected: selectedBox == 10,
            onTap: () => onSelected(10)
          ),
          buildTableContainer(
            child: boxValue[11], isSelected: selectedBox == 11,
            onTap: () => onSelected(11)
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTableContainer(
            child: boxValue[12], isSelected: selectedBox == 12,
            onTap: () => onSelected(12)
          ),
          buildTableContainer(
            child: boxValue[13], isSelected: selectedBox == 13,
            onTap: () => onSelected(13)
          ),
          buildTableContainer(
            child: boxValue[14], isSelected: selectedBox == 14,
            onTap: () => onSelected(14)
          ),
          buildTableContainer(
            child: boxValue[15], isSelected: selectedBox == 15,
            onTap: () => onSelected(15)
          ),
        ],
      ),
    ],
  );
}

List<int> nearBox(int n, List<int?> boxValue) {
  List<int> index = [];
  List<int> directions = [-1, 1, -4, 4];

  for (int dir in directions) {
    int target = n + dir;
    if (target >= 0 && target <= 15) {
      if (n % 4 == 0 && dir == -1) continue;
      if (n % 4 == 3 && dir == 1) continue;

      if (boxValue[target] != null) {
        index.add(boxValue[target]!);
      }
    }
  }

  return index;
}

int gcd(int a, int? b) {
  if (b == null) {
    return 1;
  }
  while (b != 0) {
    int temp = b!;
    b = a % b;
    a = temp;
  }
  return a;
}

bool coprime (List<int> nearBox, int n) {
  if (nearBox.isEmpty) {
    return true;
  }

  for (int value in nearBox) {
    if (gcd(value, n) != 1) {
      return false;
    }
  }
  return true;
}

void numbersCheck (List<int?> boxValue, List<int> numbers) {
  List<int> emptyBox = [];
  for (int i = 0; i < boxValue.length; i++) {
    if (boxValue[i] == null) {
      emptyBox.add(i);
    }
  }

  List<int> remove = [];

  for (int number in numbers) {
    bool chance = emptyBox.any((value) {
      if (coprime(nearBox(value, boxValue), number)) {
        return true;
      } else {
        return false;
      }
    });
    if (!chance) remove.add(number);
  }
  for (int n in remove) {
    numbers.remove(n);
  }
}