import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../app_theme.dart';

/// Data class for bottom navigation bar items.
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// A custom bottom navigation bar with neon-styled icons and frosted glass effect.
class BottomNavBarComponent extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const BottomNavBarComponent({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: context.lumen.deepBackground.withValues(alpha: 0.6),
            border: Border(
              top: BorderSide(color: context.lumen.neonGlow, width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: context.lumen.neonGlow.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;

                  return GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                                isSelected
                                    ? (item.activeIcon ?? item.icon)
                                    : item.icon,
                                color: isSelected
                                    ? context.lumen.neonGlow
                                    : Colors.grey,
                                size: isSelected ? 28 : 24,
                              )
                              .animate(target: isSelected ? 1 : 0)
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                                duration: 200.ms,
                              ),
                          const Gap(4),
                          Text(
                                item.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? context.lumen.neonGlow
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              )
                              .animate(target: isSelected ? 1 : 0)
                              .fade(duration: 200.ms),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
