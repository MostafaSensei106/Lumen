import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A styled divider component with neon accent for Lumen.
class DividerComponent extends StatelessWidget {
  /// The color of the divider.
  final Color? color;

  /// The thickness of the divider.
  final double thickness;

  /// The start indent of the divider.
  final double indent;

  /// The end indent of the divider.
  final double endIndent;

  /// Optional text label displayed in the center.
  final String? label;

  /// The orientation of the divider.
  final Axis orientation;

  const DividerComponent({
    super.key,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.label,
    this.orientation = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final divColor = color ?? context.lumen.neonGlow;

    Widget buildLine() {
      return Container(
        height: orientation == Axis.horizontal ? thickness : double.infinity,
        width: orientation == Axis.vertical ? thickness : double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              divColor.withValues(alpha: 0.0),
              divColor,
              divColor.withValues(alpha: 0.0),
            ],
            begin: orientation == Axis.horizontal
                ? Alignment.centerLeft
                : Alignment.topCenter,
            end: orientation == Axis.horizontal
                ? Alignment.centerRight
                : Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: divColor.withValues(alpha: 0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      );
    }

    Widget content;
    if (label != null && orientation == Axis.horizontal) {
      content = Row(
        children: [
          SizedBox(width: indent),
          Expanded(child: buildLine()),
          const Gap(12),
          Text(
            label!,
            style: TextStyle(
              color: divColor,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(color: divColor.withValues(alpha: 0.5), blurRadius: 4),
              ],
            ),
          ),
          const Gap(12),
          Expanded(child: buildLine()),
          SizedBox(width: endIndent),
        ],
      );
    } else {
      content = Padding(
        padding: orientation == Axis.horizontal
            ? EdgeInsets.only(left: indent, right: endIndent)
            : EdgeInsets.only(top: indent, bottom: endIndent),
        child: buildLine(),
      );
    }

    return content;
  }
}
