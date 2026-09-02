import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';

/// A custom icon button with optional neon glow and pulsing animation.
class IconButtonComponent extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool enableGlow;
  final Color? glowColor;
  final EdgeInsetsGeometry? padding;

  const IconButtonComponent({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.enableGlow = false,
    this.glowColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? context.lumen.neonGlow;
    final effectColor = glowColor ?? iconColor;

    Widget button = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: enableGlow
            ? [
                BoxShadow(
                  color: effectColor.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onPressed,
          splashColor: effectColor.withValues(alpha: 0.3),
          highlightColor: effectColor.withValues(alpha: 0.1),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: Icon(icon, size: size, color: iconColor),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    if (enableGlow) {
      return button
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.05, 1.05),
            duration: const Duration(seconds: 2),
          );
    }

    return button;
  }
}
