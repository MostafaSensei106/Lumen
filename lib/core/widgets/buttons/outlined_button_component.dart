import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// An outlined button with an animated neon border glow effect.
class OutlinedButtonComponent extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double borderWidth;
  final bool isLoading;
  final bool enabled;

  const OutlinedButtonComponent({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
    this.borderWidth = 2.0,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? context.lumen.plasmaAccent;
    final effectiveTextColor = textColor ?? context.lumen.textPrimary;
    final isActuallyEnabled = enabled && !isLoading;

    Widget buttonContent = Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: effectiveBorderColor.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: effectiveBorderColor.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isActuallyEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          splashColor: effectiveBorderColor.withValues(alpha: 0.3),
          highlightColor: effectiveBorderColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        effectiveTextColor,
                      ),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: effectiveTextColor, size: 20),
                    const Gap(8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: effectiveTextColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (!isActuallyEnabled) {
      buttonContent = Opacity(opacity: 0.5, child: buttonContent);
    } else {
      // Add a subtle pulsing glow to the outline when enabled
      buttonContent = buttonContent
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .tint(
            color: effectiveBorderColor.withValues(alpha: 0.2),
            duration: const Duration(milliseconds: 1500),
          );
    }

    return buttonContent;
  }
}
