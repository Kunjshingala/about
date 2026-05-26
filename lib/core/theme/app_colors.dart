import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderLight,
    required this.fieldBackground,
    required this.tagBackground,
    required this.shadow,
    required this.shadowStrong,
    required this.selectionHighlight,
    required this.navBackground,
  });
  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color borderLight;
  final Color fieldBackground;
  final Color tagBackground;
  final Color shadow;
  final Color shadowStrong;
  final Color selectionHighlight;
  final Color navBackground;

  @override
  ThemeExtension<AppColors> copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? secondary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? borderLight,
    Color? fieldBackground,
    Color? tagBackground,
    Color? shadow,
    Color? shadowStrong,
    Color? selectionHighlight,
    Color? navBackground,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      fieldBackground: fieldBackground ?? this.fieldBackground,
      tagBackground: tagBackground ?? this.tagBackground,
      shadow: shadow ?? this.shadow,
      shadowStrong: shadowStrong ?? this.shadowStrong,
      selectionHighlight: selectionHighlight ?? this.selectionHighlight,
      navBackground: navBackground ?? this.navBackground,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      fieldBackground: Color.lerp(fieldBackground, other.fieldBackground, t)!,
      tagBackground: Color.lerp(tagBackground, other.tagBackground, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      shadowStrong: Color.lerp(shadowStrong, other.shadowStrong, t)!,
      selectionHighlight:
          Color.lerp(selectionHighlight, other.selectionHighlight, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
    );
  }

  static final light = AppColors(
    background: const Color(0xFFFCFCFC),
    surface: const Color(0xFFFFFFFF),
    primary: const Color(0xFF000000),
    secondary: const Color(0xFF333333),
    textPrimary: const Color(0xFF000000),
    textSecondary: const Color(0xFF555555),
    textTertiary: const Color(0xFF777777),
    border: const Color(0xFFF0F0F0),
    borderLight: const Color(0xFFF5F5F5),
    fieldBackground: const Color(0xFFF9F9F9),
    tagBackground: const Color(0xFFFAFAFA),
    shadow: const Color(0xFF000000).withValues(alpha: 0.05),
    shadowStrong: const Color(0xFF000000).withValues(alpha: 0.1),
    selectionHighlight: const Color(0xFFB4D7FF),
    navBackground: const Color(0xFFFFFFFF).withValues(alpha: 0.6),
  );

  static final dark = AppColors(
    background: const Color(0xFF121212),
    surface: const Color(0xFF1E1E1E),
    primary: const Color(0xFFFFFFFF),
    secondary: const Color(0xFFE0E0E0),
    textPrimary: const Color(0xFFFFFFFF),
    textSecondary: const Color(0xFFAAAAAA),
    textTertiary: const Color(0xFF888888),
    border: const Color(0xFF333333),
    borderLight: const Color(0xFF2C2C2C),
    fieldBackground: const Color(0xFF2C2C2C),
    tagBackground: const Color(0xFF333333),
    shadow: const Color(0xFF000000).withValues(alpha: 0.3),
    shadowStrong: const Color(0xFF000000).withValues(alpha: 0.5),
    selectionHighlight: const Color(0xFF005C99),
    navBackground: const Color(0xFF1E1E1E).withValues(alpha: 0.8),
  );
}

extension AppColorExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
