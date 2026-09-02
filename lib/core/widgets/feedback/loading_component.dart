import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dot_matrix_loader/dot_matrix_loader.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// Available loading styles.
enum LoadingStyle { circular, dotMatrix, pulse, beam }

/// A loading indicator with multiple neon style options.
class LoadingComponent extends StatelessWidget {
  final double size;
  final Color? color;
  final LoadingStyle style;
  final String? message;

  const LoadingComponent({
    super.key,
    this.size = 48.0,
    this.color,
    this.style = LoadingStyle.circular,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.lumen.neonGlow;

    Widget loader;
    switch (style) {
      case LoadingStyle.circular:
        loader = SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: activeColor,
            strokeWidth: size / 12,
          ),
        );
        break;
      case LoadingStyle.dotMatrix:
        loader = SizedBox(height: size, child: DotMatrixLoader());
        break;
      case LoadingStyle.pulse:
        loader =
            Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor.withValues(alpha: 0.5),
                    boxShadow: [
                      BoxShadow(color: activeColor, blurRadius: size / 2),
                    ],
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 1.seconds,
                );
        break;
      case LoadingStyle.beam:
        loader = Container(
          width: size * 2,
          height: size / 4,
          decoration: BoxDecoration(
            color: context.lumen.cardSurface,
            borderRadius: BorderRadius.circular(size / 8),
            border: Border.all(color: activeColor.withValues(alpha: 0.3)),
          ),
          child: Stack(
            children: [
              Container(
                    width: size / 2,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(size / 8),
                      boxShadow: [
                        BoxShadow(
                          color: activeColor,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .moveX(
                    begin: 0,
                    end: size * 1.5,
                    duration: 1.seconds,
                    curve: Curves.easeInOutSine,
                  ),
            ],
          ),
        );
        break;
    }

    if (message == null) return loader;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loader,
        const Gap(16),
        Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: activeColor, fontWeight: FontWeight.w600),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.5, end: 1.0, duration: 1.seconds),
      ],
    );
  }
}
