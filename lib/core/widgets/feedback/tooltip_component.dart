import 'package:flutter/material.dart';

import '../app_theme.dart';

/// A styled tooltip wrapper with dark background and neon border for Lumen.
class TooltipComponent extends StatelessWidget {
  /// The tooltip text message.
  final String message;

  /// The child widget that triggers the tooltip.
  final Widget child;

  /// The preferred direction of the tooltip.
  final AxisDirection? preferredDirection;

  /// Background color of the tooltip.
  final Color? backgroundColor;

  /// Text color of the tooltip.
  final Color? textColor;

  /// Border color of the tooltip.
  final Color? borderColor;

  const TooltipComponent({
    super.key,
    required this.message,
    required this.child,
    this.preferredDirection,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? context.lumen.deepBackground;
    final border = borderColor ?? context.lumen.neonGlow;
    final textCol = textColor ?? context.lumen.textPrimary;

    return Tooltip(
      message: message,
      preferBelow: preferredDirection == AxisDirection.down,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: border.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      textStyle: TextStyle(
        color: textCol,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      showDuration: const Duration(seconds: 3),
      waitDuration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}
