import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// Available types of snackbars.
enum SnackBarType { info, success, warning, error }

/// Helper function to show a Lumen-styled snackbar.
void showLumenSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.info,
  Duration? duration,
  SnackBarAction? action,
}) {
  Color accentColor;
  IconData iconData;

  switch (type) {
    case SnackBarType.info:
      accentColor = context.lumen.neonGlow;
      iconData = Icons.info_outline;
      break;
    case SnackBarType.success:
      accentColor = context.lumen.energyAccent;
      iconData = Icons.check_circle_outline;
      break;
    case SnackBarType.warning:
      accentColor = Colors.orangeAccent;
      iconData = Icons.warning_amber_outlined;
      break;
    case SnackBarType.error:
      accentColor = context.lumen.laserAccent;
      iconData = Icons.error_outline;
      break;
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    padding: EdgeInsets.zero,
    duration: duration ?? const Duration(seconds: 4),
    content:
        Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.lumen.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(iconData, color: accentColor, size: 28)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(duration: 2.seconds),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: context.lumen.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (action != null) ...[
                    const Gap(8),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        action.onPressed();
                      },
                      child: Text(
                        action.label,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
            .animate()
            .slideY(
              begin: 1.0,
              end: 0.0,
              duration: 300.ms,
              curve: Curves.easeOutQuad,
            )
            .fade(),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
