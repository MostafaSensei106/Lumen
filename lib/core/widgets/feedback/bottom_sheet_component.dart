import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';

/// A styled bottom sheet component with frosted glass effect and neon accents.
class BottomSheetComponent extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showDragHandle;
  final double? maxHeight;
  final Color? backgroundColor;

  const BottomSheetComponent({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.maxHeight,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child:
            Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight:
                        maxHeight ?? MediaQuery.of(context).size.height * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: (backgroundColor ?? context.lumen.deepBackground)
                        .withValues(alpha: 0.7),
                    border: Border(
                      top: BorderSide(
                        color: context.lumen.neonGlow.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showDragHandle)
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: context.lumen.neonGlow,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: context.lumen.neonGlow.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      if (title != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            title!,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: context.lumen.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Divider(
                          color: context.lumen.textPrimary.withValues(
                            alpha: 0.1,
                          ),
                          height: 1,
                        ),
                      ],
                      Flexible(child: child),
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
                .fade(duration: 300.ms),
      ),
    );
  }
}

/// Helper function to show a Lumen-styled bottom sheet.
Future<T?> showLumenBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  bool showDragHandle = true,
  double? maxHeight,
  Color? backgroundColor,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: isDismissible,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BottomSheetComponent(
        title: title,
        showDragHandle: showDragHandle,
        maxHeight: maxHeight,
        backgroundColor: backgroundColor,
        child: child,
      ),
    ),
  );
}
