import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';

/// Size options for [BadgeComponent].
enum BadgeSize { small, medium, large }

/// A notification/count badge with neon glow.
///
/// If [child] is provided, the badge is positioned on the top-right corner
/// of the child widget. Otherwise it renders standalone.
///
/// ```dart
/// BadgeComponent(
///   count: 5,
///   child: Icon(Icons.notifications),
/// )
/// ```
class BadgeComponent extends StatelessWidget {
  /// Numeric count to display inside the badge.
  final int? count;

  /// Text label — used instead of [count] when provided.
  final String? label;

  /// Background color of the badge. Defaults to [LumenColorScheme.laserAccent].
  final Color? color;

  /// Text color inside the badge. Defaults to white.
  final Color? textColor;

  /// Size preset for the badge.
  final BadgeSize size;

  /// If true, shows a small dot instead of count/label.
  final bool showDot;

  /// Optional child widget to attach the badge to.
  final Widget? child;

  const BadgeComponent({
    super.key,
    this.count,
    this.label,
    this.color,
    this.textColor,
    this.size = BadgeSize.medium,
    this.showDot = false,
    this.child,
  });

  double get _badgeSize {
    switch (size) {
      case BadgeSize.small:
        return showDot ? 8 : 16;
      case BadgeSize.medium:
        return showDot ? 10 : 20;
      case BadgeSize.large:
        return showDot ? 12 : 24;
    }
  }

  double get _fontSize {
    switch (size) {
      case BadgeSize.small:
        return 9;
      case BadgeSize.medium:
        return 11;
      case BadgeSize.large:
        return 13;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lumen = context.lumen;
    final badgeColor = color ?? lumen.laserAccent;
    final badgeTextColor = textColor ?? Colors.white;

    final displayText = label ?? (count != null ? '$count' : null);

    final badge =
        Container(
              constraints: BoxConstraints(
                minWidth: _badgeSize,
                minHeight: _badgeSize,
              ),
              padding: showDot
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(_badgeSize),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withAlpha(130),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: showDot
                  ? SizedBox(width: _badgeSize, height: _badgeSize)
                  : Center(
                      child: Text(
                        displayText ?? '',
                        style: TextStyle(
                          color: badgeTextColor,
                          fontSize: _fontSize,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            )
            .animate()
            .scale(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 1.0),
              duration: 300.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 200.ms);

    if (child == null) return badge;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: -(_badgeSize / 3),
          right: -(_badgeSize / 3),
          child: badge,
        ),
      ],
    );
  }
}
