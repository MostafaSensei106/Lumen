import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/core/widgets/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lumen = context.lumen;

    return Scaffold(
      backgroundColor: lumen.deepBackground,
      body: Stack(
        children: [
          // Decorative background elements
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lumen.neonGlow.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: lumen.neonGlow.withValues(alpha: 0.2),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'L U M E N',
                  style: TextStyle(
                    color: lumen.neonGlow,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    shadows: [Shadow(color: lumen.neonGlow.withValues(alpha: 0.5), blurRadius: 20)],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'BROKEN CIRCUIT',
                  style: TextStyle(
                    color: lumen.textSecondary,
                    fontSize: 16,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 60),
                _buildMenuButton(context, 'PLAY', '/levels', Icons.play_arrow, lumen),
                const SizedBox(height: 20),
                _buildMenuButton(context, 'SHOP', '/shop', Icons.store, lumen),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  'SETTINGS',
                  '/settings',
                  Icons.settings,
                  lumen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    String route,
    IconData icon,
    LumenColorScheme lumen,
  ) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: lumen.cardSurface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: lumen.borderMuted),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: lumen.neonGlow, size: 24),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: lumen.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
