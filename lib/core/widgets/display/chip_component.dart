import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// Sizes available for the ChipComponent.
enum ChipSize { small, medium, large }

/// A styled chip/tag widget with neon aesthetic for Lumen.
class ChipComponent extends StatelessWidget {
  /// The text label of the chip.
  final String label;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// The primary color of the chip.
  final Color? color;

  /// The text color.
  final Color? textColor;

  /// Callback when the chip is tapped.
  final VoidCallback? onTap;

  /// Callback when the delete icon is tapped.
  final VoidCallback? onDelete;

  /// Whether the chip is in a selected state.
  final bool isSelected;

  /// The size variant of the chip.
  final ChipSize size;

  const ChipComponent({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.textColor,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
    this.size = ChipSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? context.lumen.plasmaAccent;
    final onPrimary = textColor ?? context.lumen.textPrimary;

    double paddingH;
    double paddingV;
    double fontSize;
    double iconSize;

    switch (size) {
      case ChipSize.small:
        paddingH = 8.0;
        paddingV = 4.0;
        fontSize = 12.0;
        iconSize = 14.0;
        break;
      case ChipSize.medium:
        paddingH = 12.0;
        paddingV = 6.0;
        fontSize = 14.0;
        iconSize = 16.0;
        break;
      case ChipSize.large:
        paddingH = 16.0;
        paddingV = 8.0;
        fontSize = 16.0;
        iconSize = 20.0;
        break;
    }

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize,
            color: isSelected ? context.lumen.deepBackground : primaryColor,
          ),
          Gap(paddingH / 2),
        ],
        Text(
          label,
          style: TextStyle(
            color: isSelected ? context.lumen.deepBackground : onPrimary,
            fontSize: fontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (onDelete != null) ...[
          Gap(paddingH / 2),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: iconSize,
              color: isSelected ? context.lumen.deepBackground : primaryColor,
            ),
          ),
        ],
      ],
    );

    Widget chip = Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: primaryColor, width: 1.5),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: chipContent,
    );

    if (onTap != null) {
      chip = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: chip,
      );
    }

    return Material(color: Colors.transparent, child: chip);
  }
}
