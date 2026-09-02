import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A full elevated button with a gradient background and scale-down tap animation.
class ElevatedButtonComponent extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool enabled;
  final double borderRadius;

  const ElevatedButtonComponent({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient,
    this.width,
    this.height,
    this.isLoading = false,
    this.enabled = true,
    this.borderRadius = 12.0,
  });

  @override
  State<ElevatedButtonComponent> createState() =>
      _ElevatedButtonComponentState();
}

class _ElevatedButtonComponentState extends State<ElevatedButtonComponent> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActuallyEnabled = widget.enabled && !widget.isLoading;
    final defaultGradient = LinearGradient(
      colors: [context.lumen.neonGlow, context.lumen.plasmaAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return GestureDetector(
      onTapDown: isActuallyEnabled
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: isActuallyEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isActuallyEnabled
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Opacity(
          opacity: isActuallyEnabled ? 1.0 : 0.5,
          child: Container(
            width: widget.width,
            height: widget.height ?? 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: widget.gradient ?? defaultGradient,
              boxShadow: isActuallyEnabled
                  ? [
                      BoxShadow(
                        color:
                            (widget.gradient?.colors.first ??
                                    context.lumen.neonGlow)
                                .withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else ...[
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: Colors.white, size: 24),
                        const Gap(8),
                      ],
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
