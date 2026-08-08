import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Test'),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Button pressed');
                },
                child: Text('Click me'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
