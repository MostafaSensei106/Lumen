import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A styled dialog component with neon aesthetics.
class DialogComponent extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final Color? borderColor;

  const DialogComponent({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = borderColor ?? context.lumen.neonGlow;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child:
          Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.lumen.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: defaultColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: defaultColor.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 48, color: iconColor ?? defaultColor)
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 2.seconds),
                      const Gap(16),
                    ],
                    if (title != null) ...[
                      Text(
                        title!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: context.lumen.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(16),
                    ],
                    content,
                    if (actions != null && actions!.isNotEmpty) ...[
                      const Gap(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions!,
                      ),
                    ],
                  ],
                ),
              )
              .animate()
              .scale(duration: 300.ms, curve: Curves.easeOutBack)
              .fade(duration: 300.ms),
    );
  }
}

/// Helper function to show a Lumen-styled dialog.
Future<T?> showLumenDialog<T>({
  required BuildContext context,
  required DialogComponent dialog,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: context.lumen.deepBackground.withValues(alpha: 0.8),
    builder: (context) => dialog,
  );
}
