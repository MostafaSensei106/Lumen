import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A horizontal progress bar component with neon aesthetic for Lumen.
class ProgressBarComponent extends StatelessWidget {
  /// The progress value between 0.0 and 1.0.
  final double progress;

  /// The height of the progress bar.
  final double height;

  /// The background color of the track.
  final Color? backgroundColor;

  /// The solid fill color (used if gradient is null).
  final Color? fillColor;

  /// The gradient used for the fill.
  final Gradient? gradient;

  /// Whether to show the percentage text overlay.
  final bool showPercentage;

  /// Optional label to display above the progress bar.
  final String? label;

  /// Whether to animate the progress fill.
  final bool animate;

  /// The border radius of the track and fill.
  final double borderRadius;

  const ProgressBarComponent({
    super.key,
    required this.progress,
    this.height = 12.0,
    this.backgroundColor,
    this.fillColor,
    this.gradient,
    this.showPercentage = false,
    this.label,
    this.animate = true,
    this.borderRadius = 8.0,
  }) : assert(progress >= 0.0 && progress <= 1.0);

  @override
  Widget build(BuildContext context) {
    final defaultGradient = LinearGradient(
      colors: [context.lumen.neonGlow, context.lumen.energyAccent],
    );

    Widget bar = LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final fillWidth = maxWidth * progress;

        Widget fill = Container(
          width: fillWidth,
          height: height,
          decoration: BoxDecoration(
            color: fillColor,
            gradient: fillColor == null ? (gradient ?? defaultGradient) : null,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: (fillColor ?? context.lumen.neonGlow).withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        );

        if (animate) {
          fill = fill.animate(target: progress).shimmer(duration: 1.seconds);
        }

        return Container(
          width: maxWidth,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? context.lumen.cardSurface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: context.lumen.cardSurface.withValues(alpha: 0.5),
            ),
          ),
          child: Stack(
            children: [
              animate
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: fillWidth,
                      curve: Curves.easeOutCubic,
                      child: fill,
                    )
                  : fill,
              if (showPercentage)
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: context.lumen.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: TextStyle(
              color: context.lumen.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          bar,
        ],
      );
    }

    return bar;
  }
}
