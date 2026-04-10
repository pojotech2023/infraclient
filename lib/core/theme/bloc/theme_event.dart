import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ColorSchemeChanged extends ThemeEvent {
  final String colorSchemeName;

  const ColorSchemeChanged(this.colorSchemeName);

  @override
  List<Object?> get props => [colorSchemeName];
}

class ThemeInitialized extends ThemeEvent {
  const ThemeInitialized();
}
