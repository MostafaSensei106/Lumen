import 'package:flutter/material.dart';

void main() {
  runApp(const LumenApp());
}

class LumenApp extends StatelessWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumen: Broken Circuit',
      theme: ThemeData.dark(),
      home: const Scaffold(body: Center(child: Text('Lumen: Broken Circuit'))),
    );
  }
}
