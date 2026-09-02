import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A full empty state placeholder widget with neon aesthetic for Lumen.
class EmptyStateComponent extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The main title text.
  final String title;

  /// Optional description text.
  final String? description;

  /// Optional action button label.
  final String? actionLabel;

  /// Callback when the action button is pressed.
  final VoidCallback? onAction;

  /// Size of the center icon.
  final double iconSize;

  /// Color of the center icon.
  final Color? iconColor;

  const EmptyStateComponent({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? context.lumen.neonGlow;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child:
            Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: iconSize, color: color)
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.05, 1.05),
                          duration: 1.seconds,
                        )
                        .then(),
                    const Gap(24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.lumen.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: color.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    if (description != null) ...[
                      const Gap(12),
                      Text(
                        description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (actionLabel != null && onAction != null) ...[
                      const Gap(32),
                      ElevatedButton(
                        onPressed: onAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.lumen.cardSurface,
                          foregroundColor: context.lumen.textPrimary,
                          side: BorderSide(color: color, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 8,
                          shadowColor: color.withValues(alpha: 0.4),
                        ),
                        child: Text(
                          actionLabel!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                )
                .animate()
                .fade(duration: 500.ms)
                .slideY(
                  begin: 0.1,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.easeOutCubic,
                ),
      ),
    );
  }
}
