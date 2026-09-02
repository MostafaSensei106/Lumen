import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_theme.dart';

/// A frosted glass card with a subtle neon border.
class GlassCardComponent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderRadius;
  final double blurAmount;
  final double opacity;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const GlassCardComponent({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderRadius = 16.0,
    this.blurAmount = 10.0,
    this.opacity = 0.2,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? context.lumen.neonGlow;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: context.lumen.deepBackground.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: border.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: content,
        ),
      ),
    );
  }
}
