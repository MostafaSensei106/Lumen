import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';
import 'glass_card_component.dart';

/// Rarity levels for achievements.
enum AchievementRarity { common, rare, epic, legendary }

/// A card showing an achievement with icon, title, description, and progress.
class AchievementCardComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0
  final bool isUnlocked;
  final AchievementRarity? rarity;
  final VoidCallback? onTap;

  const AchievementCardComponent({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.progress,
    this.isUnlocked = false,
    this.rarity = AchievementRarity.common,
    this.onTap,
  });

  Color _getRarityColor(BuildContext context) {
    switch (rarity) {
      case AchievementRarity.common:
        return context.lumen.textPrimary;
      case AchievementRarity.rare:
        return context.lumen.neonGlow;
      case AchievementRarity.epic:
        return context.lumen.plasmaAccent;
      case AchievementRarity.legendary:
        return context.lumen.laserAccent;
      default:
        return context.lumen.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRarityColor(context);
    final clampedProgress = progress.clamp(0.0, 1.0);

    Widget content = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: isUnlocked ? 0.8 : 0.3),
              width: 2,
            ),
          ),
          child: Icon(icon, color: isUnlocked ? color : Colors.grey, size: 32),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isUnlocked ? context.lumen.textPrimary : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isUnlocked
                      ? context.lumen.textPrimary.withValues(alpha: 0.7)
                      : Colors.grey.shade600,
                ),
              ),
              const Gap(8),
              if (!isUnlocked)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: clampedProgress,
                      backgroundColor: Colors.grey.shade800,
                      color: color,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const Gap(4),
                    Text(
                      '${(clampedProgress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: color),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );

    Widget card = GlassCardComponent(
      padding: const EdgeInsets.all(16),
      borderColor: isUnlocked ? color : Colors.grey.shade800,
      onTap: onTap,
      opacity: isUnlocked ? 0.2 : 0.1,
      child: content,
    );

    if (isUnlocked && rarity == AchievementRarity.legendary) {
      card = card
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: 2000.ms,
            color: context.lumen.laserAccent.withValues(alpha: 0.3),
            angle: 1,
          );
    }

    return card;
  }
}
