import 'package:flutter/material.dart';

import '../app_theme/app_theme.dart';
import 'base_appearance.dart';

class ApplicationAppearance extends BaseAppearance {
  @override
  ThemeData getThemeData(Brightness brightness, AppTheme appTheme) {
    final themeColors = brightness == Brightness.light
        ? appTheme.lightTheme
        : appTheme.darkTheme;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: themeColors.primary,
      onPrimary: themeColors.onPrimary,
      secondary: themeColors.secondary,
      onSecondary: themeColors.onSecondary,
      error: themeColors.error,
      onError: themeColors.onError,
      surface: themeColors.surface,
      onSurface: themeColors.onSurface,

    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: themeColors.scaffoldBackgroundColor,
    );
  }
}
