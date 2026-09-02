import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// A custom tab bar with a neon glowing indicator that slides between tabs.
class TabBarComponent extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const TabBarComponent({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeIndicatorColor = indicatorColor ?? context.lumen.energyAccent;
    final activeLabelColor = labelColor ?? context.lumen.textPrimary;
    final inactiveLabelColor = unselectedLabelColor ?? Colors.grey;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTabChanged(index),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? activeLabelColor : inactiveLabelColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Gap(4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 2,
                    width: isSelected ? 40 : 0,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? activeIndicatorColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: activeIndicatorColor.withValues(alpha: 0.8),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
