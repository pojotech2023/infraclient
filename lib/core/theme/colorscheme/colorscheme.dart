import 'dart:ui';

import '../app_theme/app_theme.dart';

class ColorSchemeHolder {
  final AppColorScheme lightTheme;
  final AppColorScheme darkTheme;

  const ColorSchemeHolder({
    required this.lightTheme,
    required this.darkTheme,
  });
}

final Map<String, ColorSchemeHolder> themeMap = {
  BuiltInThemes.defaultTheme: ColorSchemeHolder(
    lightTheme: AppTheme.fallback.lightTheme,
    darkTheme: AppTheme.fallback.darkTheme,
  ),
};

/// This is the base colorscheme class.
/// Expand the colorscheme as required depending on the ui requirement.
class AppColorScheme {
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;
  final Color scaffoldBackgroundColor;

  const AppColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.scaffoldBackgroundColor,
  });
}
