import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/core/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(title: 'Lumen'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyStateComponent(
              icon: Icons.lightbulb_outline,
              title: 'Welcome to Lumen',
              description: 'Select a module below to begin.',
            ),
            const SizedBox(height: 20),
            ElevatedButtonComponent(
              label: 'Play',
              onPressed: () => context.go('/levels'),
            ),
            const SizedBox(height: 10),
            ElevatedButtonComponent(
              label: 'Shop',
              onPressed: () => context.go('/shop'),
            ),
            const SizedBox(height: 10),
            ElevatedButtonComponent(
              label: 'Profile',
              onPressed: () => context.go('/profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButtonComponent(
              label: 'Settings',
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}
