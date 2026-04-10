import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../app_theme/app_theme.dart';
import '../flavor_theme_service.dart';
import '../../config/flavor_config.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _boxName = 'theme_settings';
  static const String _kThemeMode = 'theme_mode';
  static const String _kColorScheme = 'color_scheme';

  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ColorSchemeChanged>(_onColorSchemeChanged);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final Box box = await Hive.openBox(_boxName);
      final String defaultThemeMode = FlavorConfig.appConfig.appTheme.toLowerCase();
      final String themeModeString = (box.get(_kThemeMode) as String?) ?? defaultThemeMode;
      
      // Get color scheme from flavor configuration
      final String flavorColorScheme = FlavorThemeService.getThemeNameFromFlavor();
      final String colorSchemeName = (box.get(_kColorScheme) as String?) ?? flavorColorScheme;
      
      final ThemeMode themeMode = _parseThemeMode(themeModeString);
      final AppTheme appTheme = AppTheme.fromName(colorSchemeName);
      
      emit(state.copyWith(
        themeMode: themeMode,
        colorSchemeName: colorSchemeName,
        appTheme: appTheme,
        isLoading: false,
      ));
    } catch (e) {
      // Fallback to flavor-based theme if there's an error
      final String flavorColorScheme = FlavorThemeService.getThemeNameFromFlavor();
      final AppTheme appTheme = FlavorThemeService.getThemeFromFlavor();
      
      emit(state.copyWith(
        themeMode: ThemeMode.system,
        colorSchemeName: flavorColorScheme,
        appTheme: appTheme,
        isLoading: false,
      ));
    }
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    
    try {
      final Box box = await Hive.openBox(_boxName);
      await box.put(_kThemeMode, _themeModeToString(event.themeMode));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _onColorSchemeChanged(
    ColorSchemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    final AppTheme newAppTheme = AppTheme.fromName(event.colorSchemeName);
    
    emit(state.copyWith(
      colorSchemeName: event.colorSchemeName,
      appTheme: newAppTheme,
    ));
    
    try {
      final Box box = await Hive.openBox(_boxName);
      await box.put(_kColorScheme, event.colorSchemeName);
    } catch (e) {
      // Handle error silently
    }
  }

  ThemeMode _parseThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
