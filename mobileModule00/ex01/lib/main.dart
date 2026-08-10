import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MaPage()));
}

class MaPage extends StatefulWidget {
  @override
  State<MaPage> createState() => _MaPageState();
}

class _MaPageState extends State<MaPage> {
  String monTexte = 'Test';

  void _basculerTexte() {
    setState(() {
      if (monTexte == 'Test') {
        monTexte = 'Hello World!';
      } else {
        monTexte = 'Test';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(monTexte),
            ElevatedButton(onPressed: _basculerTexte, child: Text('Click me')),
          ],
        ),
      ),
    );
  }
}
