import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// Data class for sidebar items.
class SideBarItem {
  final IconData icon;
  final String label;
  final String? badge;

  const SideBarItem({required this.icon, required this.label, this.badge});
}

/// A slide-in side panel with frosted glass effect and neon highlights.
class SideBarComponent extends StatelessWidget {
  final Widget? headerWidget;
  final List<SideBarItem> items;
  final int? selectedIndex;
  final ValueChanged<int>? onItemTap;
  final Widget? footer;
  final double width;

  const SideBarComponent({
    super.key,
    this.headerWidget,
    required this.items,
    this.selectedIndex,
    this.onItemTap,
    this.footer,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: context.lumen.deepBackground.withValues(alpha: 0.7),
            border: Border(
              right: BorderSide(color: context.lumen.plasmaAccent, width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: context.lumen.plasmaAccent.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(1, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (headerWidget != null) ...[
                  headerWidget!,
                  const Gap(16),
                  Divider(
                    color: context.lumen.plasmaAccent.withValues(alpha: 0.3),
                    height: 1,
                  ),
                  const Gap(16),
                ],
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = index == selectedIndex;

                      return InkWell(
                            onTap: () => onItemTap?.call(index),
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 8.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.lumen.plasmaAccent.withValues(
                                        alpha: 0.2,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? context.lumen.plasmaAccent
                                      : Colors.transparent,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: context.lumen.plasmaAccent
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.icon,
                                    color: isSelected
                                        ? context.lumen.textPrimary
                                        : Colors.grey,
                                  ),
                                  const Gap(16),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: isSelected
                                            ? context.lumen.textPrimary
                                            : Colors.grey,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (item.badge != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.lumen.laserAccent,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: context.lumen.laserAccent
                                                .withValues(alpha: 0.5),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        item.badge!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fade(delay: (50 * index).ms)
                          .slideX(begin: -0.2, end: 0, curve: Curves.easeOut);
                    },
                  ),
                ),
                if (footer != null) ...[
                  const Gap(16),
                  Divider(
                    color: context.lumen.plasmaAccent.withValues(alpha: 0.3),
                    height: 1,
                  ),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
