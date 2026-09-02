import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A customized text button with a neon border glow and shimmer effect.
class TextButtonComponent extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? borderColor;
  final double? fontSize;
  final bool isLoading;
  final bool enabled;

  const TextButtonComponent({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    this.borderColor,
    this.fontSize,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.lumen.energyAccent;
    final effectiveBorderColor = borderColor ?? effectiveColor;
    final isActuallyEnabled = enabled && !isLoading;

    return Opacity(
      opacity: isActuallyEnabled ? 1.0 : 0.5,
      child:
          Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: effectiveBorderColor.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveBorderColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: isActuallyEnabled ? onPressed : null,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: effectiveColor.withValues(alpha: 0.3),
                    hoverColor: effectiveColor.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                                  effectiveColor,
                                ),
                              ),
                            )
                          else ...[
                            if (icon != null) ...[
                              Icon(
                                icon,
                                color: effectiveColor,
                                size: fontSize != null ? fontSize! + 4 : 20,
                              ),
                              const Gap(8),
                            ],
                            Text(
                              label,
                              style: TextStyle(
                                color: effectiveColor,
                                fontSize: fontSize ?? 16.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: effectiveColor.withValues(
                                      alpha: 0.8,
                                    ),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate(target: isActuallyEnabled ? 1 : 0)
              .shimmer(
                duration: const Duration(seconds: 2),
                color: Colors.white24,
              ),
    );
  }
}
