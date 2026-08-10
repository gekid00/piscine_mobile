import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Calculatrice()));
}

class Calculatrice extends StatelessWidget {
  static const List<List<String>> touches = [
    ['7', '8', '9', '/'],
    ['4', '5', '6', '*'],
    ['1', '2', '3', '-'],
    ['0', '.', '=', '+'],
    ['AC', 'C'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          TextField(
            readOnly: true,
            textAlign: TextAlign.right,
            controller: TextEditingController(text: '0'),
          ),
          TextField(
            readOnly: true,
            textAlign: TextAlign.right,
            controller: TextEditingController(text: '0'),
          ),
          for (final ligne in touches)
            Expanded(
              child: Row(
                children: [
                  for (final touche in ligne)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint(touche);
                        },
                        child: Text(touche),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
