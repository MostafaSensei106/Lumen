import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/core/widgets/app_theme.dart';

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
    final lumen = context.lumen;

    return Scaffold(
      backgroundColor: lumen.deepBackground,
      appBar: AppBar(
        title: Text(
          'CIRCUIT SECTOR ${widget.levelId}',
          style: TextStyle(color: lumen.neonGlow, letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: lumen.neonGlow),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: lumen.neonGlow),
            onPressed: () => _showSettingsSheet(context, lumen),
          ),
        ],
      ),
      body: Stack(
        children: [
          GameWidget(game: LumenGame(levelId: widget.levelId, lumen: lumen)),
          // Overlay UI for the game
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: lumen.cardSurface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: lumen.borderMuted, width: 2),
                boxShadow: [
                  BoxShadow(color: lumen.glowShadow.withOpacity(0.2), blurRadius: 10, spreadRadius: 1),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTool(Icons.call_split, 'Node', true, lumen),
                  _buildTool(Icons.change_history, 'Prism', false, lumen),
                  _buildTool(Icons.lens, 'Filter', false, lumen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTool(IconData icon, String label, bool active, LumenColorScheme lumen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? lumen.neonGlow : lumen.textSecondary,
          size: 30,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: active ? lumen.neonGlow : lumen.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showSettingsSheet(BuildContext context, LumenColorScheme lumen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lumen.cardSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                border: Border.all(color: lumen.borderMuted),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('QUICK SETTINGS', style: TextStyle(color: lumen.neonGlow, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: Text('Music', style: TextStyle(color: lumen.textPrimary)),
                    activeColor: lumen.energyAccent,
                    value: _musicOn,
                    onChanged: (val) {
                      setState(() => _musicOn = val);
                      setSheetState(() => _musicOn = val);
                    },
                  ),
                  SwitchListTile(
                    title: Text('Vibration (Haptics)', style: TextStyle(color: lumen.textPrimary)),
                    activeColor: lumen.energyAccent,
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
