import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../app_theme/app_theme.dart';
import '../flavor_theme_service.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final String colorSchemeName;
  final AppTheme appTheme;
  final bool isLoading;

  const ThemeState({
    required this.themeMode,
    required this.colorSchemeName,
    required this.appTheme,
    this.isLoading = false,
  });

  ThemeState.initial()
      : themeMode = ThemeMode.system,
        colorSchemeName = FlavorThemeService.getThemeNameFromFlavor(),
        appTheme = FlavorThemeService.getThemeFromFlavor(),
        isLoading = false;

  ThemeState copyWith({
    ThemeMode? themeMode,
    String? colorSchemeName,
    AppTheme? appTheme,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      colorSchemeName: colorSchemeName ?? this.colorSchemeName,
      appTheme: appTheme ?? this.appTheme,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [themeMode, colorSchemeName, appTheme, isLoading];
}
