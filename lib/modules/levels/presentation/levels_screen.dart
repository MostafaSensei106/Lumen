import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../game/presentation/lumen_game.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 1: Z3 Generated')),
      body: GameWidget(game: LumenGame()),
    );
  }
}
