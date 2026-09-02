import 'package:flutter/material.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';

import '../app_theme.dart';

/// A user avatar component with neon border ring for Lumen.
class AvatarComponent extends StatelessWidget {
  /// Optional network image URL.
  final String? imageUrl;

  /// The name of the user, used for initials fallback.
  final String? name;

  /// The size (diameter) of the avatar.
  final double size;

  /// The color of the neon border.
  final Color? borderColor;

  /// The width of the border.
  final double borderWidth;

  /// Whether to show the online indicator dot.
  final bool showOnlineIndicator;

  /// Whether the user is online.
  final bool isOnline;

  /// Tap callback for the avatar.
  final VoidCallback? onTap;

  /// A placeholder widget if image loading fails or is absent.
  final Widget? placeholder;

  const AvatarComponent({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 50.0,
    this.borderColor,
    this.borderWidth = 2.0,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.onTap,
    this.placeholder,
  });

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '?';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? context.lumen.neonGlow;

    Widget avatarContent;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            placeholder ??
            Container(
              color: context.lumen.cardSurface,
              child: Center(
                child: CircularProgressIndicator(
                  color: context.lumen.neonGlow,
                  strokeWidth: 2,
                ),
              ),
            ),
        errorWidget: (context, url, error) => _buildFallback(context),
      );
    } else {
      avatarContent = _buildFallback(context);
    }

    Widget avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: effectiveBorderColor.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(child: avatarContent),
    );

    if (showOnlineIndicator) {
      final indicatorSize = size * 0.25;
      final indicatorColor = isOnline
          ? context.lumen.energyAccent
          : context.lumen.cardSurface;
      avatarWidget = Stack(
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.lumen.deepBackground,
                  width: 2,
                ),
                boxShadow: isOnline
                    ? [
                        BoxShadow(
                          color: indicatorColor.withValues(alpha: 0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      avatarWidget = GestureDetector(onTap: onTap, child: avatarWidget);
    }

    return avatarWidget;
  }

  Widget _buildFallback(BuildContext context) {
    return placeholder ??
        Container(
          color: context.lumen.cardSurface,
          alignment: Alignment.center,
          child: Text(
            _getInitials(name),
            style: TextStyle(
              color: context.lumen.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.4,
            ),
          ),
        );
  }
}
