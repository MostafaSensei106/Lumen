import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rolling_text/rolling_text.dart';

import '../app_theme.dart';
import 'glass_card_component.dart';

/// Indicates the trend of a stat.
enum StatTrend { up, down, neutral }

/// A card displaying a stat with icon, label, and animated value.
class StatsCardComponent extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color? iconColor;
  final StatTrend? trend;
  final VoidCallback? onTap;

  const StatsCardComponent({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.iconColor,
    this.trend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getTrendColor() {
      switch (trend) {
        case StatTrend.up:
          return context.lumen.energyAccent;
        case StatTrend.down:
          return context.lumen.laserAccent;
        case StatTrend.neutral:
        default:
          return context.lumen.textPrimary;
      }
    }

    IconData? getTrendIcon() {
      switch (trend) {
        case StatTrend.up:
          return Icons.trending_up;
        case StatTrend.down:
          return Icons.trending_down;
        case StatTrend.neutral:
          return Icons.trending_flat;
        case null:
          return null;
      }
    }

    return GlassCardComponent(
      padding: const EdgeInsets.all(16.0),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? context.lumen.neonGlow, size: 24),
              const Gap(8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.lumen.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              if (trend != null)
                Icon(getTrendIcon(), color: getTrendColor(), size: 16),
            ],
          ),
          const Gap(12),
          RollingText(
            text: value,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: valueColor ?? context.lumen.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
