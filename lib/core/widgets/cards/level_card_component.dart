import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';
import 'neon_card_component.dart';

/// A card representing a game level with states for locked, completed, and star ratings.
class LevelCardComponent extends StatelessWidget {
  final int levelNumber;
  final String title;
  final bool isLocked;
  final bool isCompleted;
  final int stars; // 0 to 3
  final VoidCallback? onTap;
  final String? difficulty;

  const LevelCardComponent({
    super.key,
    required this.levelNumber,
    required this.title,
    this.isLocked = false,
    this.isCompleted = false,
    this.stars = 0,
    this.onTap,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isLocked
        ? Colors.grey.shade800
        : (isCompleted ? context.lumen.energyAccent : context.lumen.neonGlow);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LEVEL $levelNumber',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: borderColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            if (isLocked)
              Icon(Icons.lock, color: Colors.grey.shade600, size: 16)
            else if (difficulty != null)
              Text(
                difficulty!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.lumen.textPrimary.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        const Gap(8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isLocked ? Colors.grey.shade600 : context.lumen.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        Row(
          children: List.generate(3, (index) {
            final isEarned = index < stars;
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                isEarned ? Icons.star : Icons.star_border,
                color: isEarned
                    ? (isLocked
                          ? Colors.grey.shade700
                          : context.lumen.plasmaAccent)
                    : Colors.grey.shade800,
                size: 20,
              ),
            );
          }),
        ),
      ],
    );

    Widget card = NeonCardComponent(
      padding: const EdgeInsets.all(16.0),
      glowColor: borderColor,
      animate: isCompleted,
      glowIntensity: isLocked ? 0.0 : 1.0,
      onTap: isLocked ? null : onTap,
      child: Opacity(opacity: isLocked ? 0.5 : 1.0, child: content),
    );

    if (!isLocked) {
      card = card
          .animate()
          .scale(duration: 400.ms, curve: Curves.easeOutBack)
          .fadeIn();
    }

    return card;
  }
}
