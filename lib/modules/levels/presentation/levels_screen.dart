import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        title: const Text(
          'SELECT SECTOR',
          style: TextStyle(letterSpacing: 3, color: Colors.cyanAccent),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            bool isUnlocked = index < 10; // First 10 unlocked for testing
            return InkWell(
              onTap: isUnlocked ? () => context.push('/game/${index + 1}') : null,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Colors.cyanAccent.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isUnlocked
                        ? Colors.cyanAccent.withValues(alpha: 0.5)
                        : Colors.white24,
                  ),
                ),
                child: Center(
                  child: isUnlocked
                      ? Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Icon(Icons.lock, color: Colors.white24),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
