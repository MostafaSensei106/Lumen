import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';

/// A custom dark transparent AppBar with a neon accent line at the bottom.
class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? bottomBorderColor;
  final bool centerTitle;
  final double elevation;

  const AppBarComponent({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.bottomBorderColor,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget? titleContent = titleWidget;
    if (titleContent == null && title != null) {
      titleContent = Text(
        title!,
        style: TextStyle(
          color: context.lumen.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ).animate().fade(duration: 300.ms);
    }

    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton) {
      leadingWidget = IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: context.lumen.neonGlow),
        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.lumen.deepBackground.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: bottomBorderColor ?? context.lumen.neonGlow,
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: (bottomBorderColor ?? context.lumen.neonGlow).withValues(
              alpha: 0.5,
            ),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: preferredSize.height,
            child: Row(
              children: [
                if (leadingWidget != null)
                  leadingWidget
                else
                  const SizedBox(width: 48),
                Expanded(
                  child: Align(
                    alignment: centerTitle
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: titleContent ?? const SizedBox.shrink(),
                  ),
                ),
                if (actions != null) ...actions! else const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
