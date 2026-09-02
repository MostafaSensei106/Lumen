import 'dart:math';

import 'package:flutter/material.dart';

import '../app_theme.dart';

/// A circular progress component with neon aesthetic for Lumen.
class CircularProgressComponent extends StatelessWidget {
  /// The progress value between 0.0 and 1.0.
  final double progress;

  /// The size (diameter) of the circular progress indicator.
  final double size;

  /// The thickness of the progress stroke.
  final double strokeWidth;

  /// The color of the progress arc.
  final Color? color;

  /// The background track color.
  final Color? backgroundColor;

  /// The center widget to display inside the circle.
  final Widget? centerWidget;

  /// Text to display in the center (used if centerWidget is null).
  final String? centerText;

  /// Whether to animate the progress.
  final bool animate;

  /// Whether to apply a neon glow effect to the progress arc.
  final bool glowEffect;

  const CircularProgressComponent({
    super.key,
    required this.progress,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.color,
    this.backgroundColor,
    this.centerWidget,
    this.centerText,
    this.animate = true,
    this.glowEffect = true,
  }) : assert(progress >= 0.0 && progress <= 1.0);

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.lumen.neonGlow;
    final trackColor = backgroundColor ?? context.lumen.cardSurface;

    Widget buildProgress(double value) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CircularProgressPainter(
            progress: value,
            strokeWidth: strokeWidth,
            color: activeColor,
            backgroundColor: trackColor,
            glowEffect: glowEffect,
          ),
          child: Center(
            child:
                centerWidget ??
                (centerText != null
                    ? Text(
                        centerText!,
                        style: TextStyle(
                          color: activeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: size * 0.2,
                          shadows: glowEffect
                              ? [
                                  Shadow(
                                    color: activeColor.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                      )
                    : null),
          ),
        ),
      );
    }

    if (animate) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => buildProgress(value),
      );
    }

    return buildProgress(progress);
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;
  final bool glowEffect;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
    required this.glowEffect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * pi * progress;

    if (glowEffect && progress > 0) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 2.5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.glowEffect != glowEffect;
  }
}
