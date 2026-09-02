import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';

/// A styled text input with neon focus glow.
class TextFieldComponent extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;

  const TextFieldComponent({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? context.lumen.laserAccent
        : (_isFocused
              ? context.lumen.neonGlow
              : context.lumen.textPrimary.withValues(alpha: 0.3));

    final glowColor = hasError
        ? context.lumen.laserAccent.withValues(alpha: _isFocused ? 0.3 : 0.0)
        : context.lumen.neonGlow.withValues(alpha: _isFocused ? 0.3 : 0.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: hasError
                  ? context.lumen.laserAccent
                  : context.lumen.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: context.lumen.cardSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: _isFocused ? 2 : 1),
            boxShadow: [
              if (_isFocused)
                BoxShadow(color: glowColor, blurRadius: 12, spreadRadius: 2),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: TextStyle(color: context.lumen.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: context.lumen.textPrimary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: borderColor)
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? InkWell(
                      onTap: widget.onSuffixTap,
                      child: Icon(widget.suffixIcon, color: borderColor),
                    )
                  : null,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: context.lumen.laserAccent),
          ).animate().slideX(duration: 200.ms).fade(),
        ],
      ],
    );
  }
}
