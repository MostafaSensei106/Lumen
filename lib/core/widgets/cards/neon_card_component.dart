import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';

/// A card with an animated neon border glow.
class NeonCardComponent extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final double glowIntensity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool animate;
  final VoidCallback? onTap;

  const NeonCardComponent({
    super.key,
    required this.child,
    this.glowColor,
    this.glowIntensity = 1.0,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.animate = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? context.lumen.neonGlow;

    Widget card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: context.lumen.cardSurface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color.withValues(alpha: 0.6 * glowIntensity),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2 * glowIntensity),
            blurRadius: 10,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.1 * glowIntensity),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    );

    if (animate) {
      card = card
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .boxShadow(
            duration: 1500.ms,
            begin: BoxShadow(
              color: color.withValues(alpha: 0.1 * glowIntensity),
              blurRadius: 10,
              spreadRadius: 2,
            ),
            end: BoxShadow(
              color: color.withValues(alpha: 0.4 * glowIntensity),
              blurRadius: 20,
              spreadRadius: 8,
            ),
          );
    }

    return card;
  }
}
