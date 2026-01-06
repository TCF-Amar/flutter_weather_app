import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';

/// Theme color extensions for easy access throughout the app
extension ThemeColors on BuildContext {
  // ─────────── Color Scheme ───────────

  /// Primary brand color
  Color get primary => Theme.of(this).colorScheme.primary;

  /// Primary container color
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;

  /// Secondary accent color
  Color get secondary => Theme.of(this).colorScheme.secondary;

  /// Secondary container color
  Color get secondaryContainer => Theme.of(this).colorScheme.secondaryContainer;

  /// Card/surface background color (adapts to theme)
  Color get surface => Theme.of(this).colorScheme.surface;

  /// Screen background color (adapts to theme)
  Color get background => Theme.of(this).colorScheme.background;

  /// Error color
  Color get error => Theme.of(this).colorScheme.error;

  /// Text color on primary
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  /// Text color on secondary
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  /// Text color on surfaces/cards (adapts to theme)
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  /// Text color on background (adapts to theme)
  Color get onBackground => Theme.of(this).colorScheme.onBackground;

  /// Text color on error
  Color get onError => Theme.of(this).colorScheme.onError;

  /// Border/outline color
  Color get outline => Theme.of(this).colorScheme.outline;

  // ─────────── Text Styles ───────────

  /// Large display text style
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;

  /// Medium display text style
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  /// Small display text style
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  /// Large headline text style
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;

  /// Medium headline text style
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  /// Small headline text style
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  /// Large title text style
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  /// Medium title text style
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  /// Small title text style
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  /// Large body text style
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  /// Medium body text style (most common)
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  /// Small body text style
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  /// Large label text style
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  /// Medium label text style
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;

  /// Small label text style
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  // ─────────── Icon Theme ───────────

  /// Icon color from theme
  Color? get iconColor => Theme.of(this).iconTheme.color;

  /// Icon size from theme
  double? get iconSize => Theme.of(this).iconTheme.size;

  // ─────────── Convenience Getters ───────────

  /// Text color (same as onBackground)
  Color get textColor => onBackground;

  /// Secondary text color (slightly transparent)
  Color get textSecondary => onBackground.withValues(alpha: 0.7);

  /// Card color (same as surface)
  Color get cardColor => surface;

  /// Shadow color for light theme
  Color get shadowColor => onSurface.withValues(alpha: 0.08);

  /// Divider color
  Color get dividerColor => outline;

  // ─────────── Gradient Colors (Theme-aware) ───────────

  /// Primary gradient color 1 (adapts to theme)
  Color get gradient1 => isDark ? AppColors.grigent1Dark : AppColors.grigent1;

  /// Primary gradient color 2 (adapts to theme)
  Color get gradient2 => isDark ? AppColors.grigent2Dark : AppColors.grigent2;

  /// Get gradient colors as a list for easy use in LinearGradient
  List<Color> get gradientColors => [gradient1, gradient2];

  // ─────────── Theme Mode ───────────

  /// Check if current theme is dark
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLight => Theme.of(this).brightness == Brightness.light;
}
