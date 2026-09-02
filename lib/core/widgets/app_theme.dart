import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Lumen Color Scheme Extension
// ──────────────────────────────────────────────────────────────────────────────

/// Custom [ThemeExtension] that carries game-specific semantic colors
/// beyond what Material [ColorScheme] provides.
///
/// Access via `Theme.of(context).extension<LumenColorScheme>()` or the
/// convenience extension `context.lumen`.
@immutable
class LumenColorScheme extends ThemeExtension<LumenColorScheme> {
  /// Neon glow accent — used for highlights, active indicators, beam effects.
  final Color neonGlow;

  /// Laser accent — used for destructive/error-adjacent actions, warnings.
  final Color laserAccent;

  /// Plasma accent — used for premium, special, or rare UI elements.
  final Color plasmaAccent;

  /// Energy accent — used for success, completion, energy budget indicators.
  final Color energyAccent;

  /// Deep background behind scaffolds / game canvas.
  final Color deepBackground;

  /// Elevated card / panel surface.
  final Color cardSurface;

  /// Soft white for primary text on dark surfaces.
  final Color textPrimary;

  /// Dimmed text for secondary / caption labels.
  final Color textSecondary;

  /// Muted border color for inactive / unfocused outlines.
  final Color borderMuted;

  /// Glow shadow color used for box-shadow effects.
  final Color glowShadow;

  const LumenColorScheme({
    required this.neonGlow,
    required this.laserAccent,
    required this.plasmaAccent,
    required this.energyAccent,
    required this.deepBackground,
    required this.cardSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderMuted,
    required this.glowShadow,
  });

  /// Default dark Lumen color scheme.
  factory LumenColorScheme.dark() {
    return const LumenColorScheme(
      neonGlow: Color(0xFF00D4FF),
      laserAccent: Color(0xFFFF073A),
      plasmaAccent: Color(0xFFBF00FF),
      energyAccent: Color(0xFF39FF14),
      deepBackground: Color(0xFF06060C),
      cardSurface: Color(0xFF12121A),
      textPrimary: Color(0xFFE0E0FF),
      textSecondary: Color(0xFF8888AA),
      borderMuted: Color(0xFF2A2A3A),
      glowShadow: Color(0xFF00D4FF),
    );
  }

  @override
  LumenColorScheme copyWith({
    Color? neonGlow,
    Color? laserAccent,
    Color? plasmaAccent,
    Color? energyAccent,
    Color? deepBackground,
    Color? cardSurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? borderMuted,
    Color? glowShadow,
  }) {
    return LumenColorScheme(
      neonGlow: neonGlow ?? this.neonGlow,
      laserAccent: laserAccent ?? this.laserAccent,
      plasmaAccent: plasmaAccent ?? this.plasmaAccent,
      energyAccent: energyAccent ?? this.energyAccent,
      deepBackground: deepBackground ?? this.deepBackground,
      cardSurface: cardSurface ?? this.cardSurface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      borderMuted: borderMuted ?? this.borderMuted,
      glowShadow: glowShadow ?? this.glowShadow,
    );
  }

  @override
  LumenColorScheme lerp(covariant LumenColorScheme? other, double t) {
    if (other is! LumenColorScheme) return this;
    return LumenColorScheme(
      neonGlow: Color.lerp(neonGlow, other.neonGlow, t)!,
      laserAccent: Color.lerp(laserAccent, other.laserAccent, t)!,
      plasmaAccent: Color.lerp(plasmaAccent, other.plasmaAccent, t)!,
      energyAccent: Color.lerp(energyAccent, other.energyAccent, t)!,
      deepBackground: Color.lerp(deepBackground, other.deepBackground, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      borderMuted: Color.lerp(borderMuted, other.borderMuted, t)!,
      glowShadow: Color.lerp(glowShadow, other.glowShadow, t)!,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Theme Builder
// ──────────────────────────────────────────────────────────────────────────────

/// Builds the full [ThemeData] for the Lumen app.
///
/// Uses [ColorScheme.fromSeed] as the Material foundation and layers
/// a [LumenColorScheme] extension on top for game-specific semantics.
///
/// ```dart
/// MaterialApp(
///   theme: AppTheme.dark(),
///   ...
/// )
/// ```
class AppTheme {
  AppTheme._();

  /// The seed color that drives the entire Material [ColorScheme].
  static const Color _seedColor = Color(0xFF00D4FF);

  /// Builds the dark theme. Pass a custom [lumenScheme] to override
  /// the default game-specific colors (useful for themes / skins).
  static ThemeData dark({LumenColorScheme? lumenScheme}) {
    final lumen = lumenScheme ?? LumenColorScheme.dark();

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: lumen.deepBackground,
      onSurface: lumen.textPrimary,
      error: lumen.laserAccent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lumen.deepBackground,
      extensions: <ThemeExtension<dynamic>>[lumen],

      // ── Card ────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: lumen.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: lumen.borderMuted, width: 0.5),
        ),
        elevation: 0,
      ),

      // ── AppBar ──────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: lumen.deepBackground.withAlpha(200),
        foregroundColor: lumen.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // ── Text ────────────────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: lumen.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        titleLarge: TextStyle(
          color: lumen.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        bodyLarge: TextStyle(color: lumen.textPrimary, letterSpacing: 0.5),
        bodyMedium: TextStyle(color: lumen.textSecondary),
        labelSmall: TextStyle(
          color: lumen.textSecondary,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ── Input ───────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lumen.cardSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lumen.borderMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lumen.laserAccent),
        ),
        hintStyle: TextStyle(color: lumen.textSecondary),
        labelStyle: TextStyle(color: lumen.textSecondary),
      ),

      // ── Divider ─────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: lumen.borderMuted, thickness: 0.5),

      // ── Dialog ──────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: lumen.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: lumen.borderMuted),
        ),
      ),

      // ── BottomSheet ─────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lumen.cardSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ── Chip ────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: lumen.cardSurface,
        side: BorderSide(color: lumen.borderMuted),
        labelStyle: TextStyle(color: lumen.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // ── Tooltip ─────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: lumen.cardSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: lumen.borderMuted),
        ),
        textStyle: TextStyle(color: lumen.textPrimary, fontSize: 12),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// BuildContext Extensions
// ──────────────────────────────────────────────────────────────────────────────

/// Quick access to theme data from any [BuildContext].
///
/// ```dart
/// final primary = context.colorScheme.primary;
/// final glow    = context.lumen.neonGlow;
/// final title   = context.textTheme.titleLarge;
/// ```
extension ThemeContextExtension on BuildContext {
  /// Material [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Material [ColorScheme] from the current theme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Material [TextTheme] from the current theme.
  TextTheme get textTheme => theme.textTheme;

  /// Lumen game-specific color extension.
  ///
  /// Falls back to [LumenColorScheme.dark] if the extension is not found
  /// (e.g. during tests or when using a plain ThemeData).
  LumenColorScheme get lumen =>
      theme.extension<LumenColorScheme>() ?? LumenColorScheme.dark();
}
