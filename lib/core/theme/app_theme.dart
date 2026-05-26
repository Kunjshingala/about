import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.light.background,
      primaryColor: AppColors.light.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.light.primary,
        onPrimary: AppColors.light.surface,
        secondary: AppColors.light.secondary,
        surface: AppColors.light.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.light.selectionHighlight,
      ),
      useMaterial3: true,
      extensions: [
        AppColors.light,
      ],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.dark.background,
      primaryColor: AppColors.dark.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.dark.primary,
        onPrimary: AppColors.dark.surface,
        secondary: AppColors.dark.secondary,
        surface: AppColors.dark.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.dark.selectionHighlight,
      ),
      useMaterial3: true,
      extensions: [
        AppColors.dark,
      ],
    );
  }
}
