import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// Defines the size of the toggle switch.
enum ToggleSize { small, medium, large }

/// A custom styled toggle switch with neon glow.
class ToggleSwitchComponent extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? label;
  final ToggleSize size;

  const ToggleSwitchComponent({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.label,
    this.size = ToggleSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    double padding = 4.0;

    switch (size) {
      case ToggleSize.small:
        width = 40.0;
        height = 24.0;
        break;
      case ToggleSize.medium:
        width = 56.0;
        height = 32.0;
        break;
      case ToggleSize.large:
        width = 72.0;
        height = 40.0;
        break;
    }

    final thumbSize = height - (padding * 2);
    final aColor = activeColor ?? context.lumen.neonGlow;
    final iColor = inactiveColor ?? context.lumen.cardSurface;

    final toggle = GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? aColor.withValues(alpha: 0.2) : iColor,
          border: Border.all(
            color: value
                ? aColor
                : context.lumen.textPrimary.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: aColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: value ? width - thumbSize - (padding * 2) - 4 : 0,
              right: value ? 0 : width - thumbSize - (padding * 2) - 4,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                      ? aColor
                      : context.lumen.textPrimary.withValues(alpha: 0.5),
                  boxShadow: value
                      ? [
                          BoxShadow(
                            color: aColor,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (label == null) return toggle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        toggle,
        const Gap(12),
        Text(
          label!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: value
                ? aColor
                : context.lumen.textPrimary.withValues(alpha: 0.7),
            fontWeight: value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
