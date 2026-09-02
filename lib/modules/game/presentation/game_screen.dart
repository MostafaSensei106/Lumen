import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

import 'lumen_game.dart';

class GameScreen extends StatefulWidget {
  final int levelId;
  const GameScreen({super.key, required this.levelId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _musicOn = true;
  bool _vibrationOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      appBar: AppBar(
        title: Text(
          'CIRCUIT SECTOR ${widget.levelId}',
          style: const TextStyle(color: Colors.cyanAccent, letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.cyanAccent),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          GameWidget(game: LumenGame(levelId: widget.levelId)),
          // Overlay UI for the game
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 10, spreadRadius: 1),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTool(Icons.call_split, 'Node', true),
                  _buildTool(Icons.change_history, 'Prism', false),
                  _buildTool(Icons.lens, 'Filter', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTool(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? Colors.cyanAccent : Colors.white54,
          size: 30,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.cyanAccent : Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('QUICK SETTINGS', style: TextStyle(color: Colors.cyanAccent, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Music', style: TextStyle(color: Colors.white)),
                    activeColor: Colors.cyanAccent,
                    value: _musicOn,
                    onChanged: (val) {
                      setState(() => _musicOn = val);
                      setSheetState(() => _musicOn = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Vibration (Haptics)', style: TextStyle(color: Colors.white)),
                    activeColor: Colors.cyanAccent,
                    value: _vibrationOn,
                    onChanged: (val) {
                      setState(() => _vibrationOn = val);
                      setSheetState(() => _vibrationOn = val);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
