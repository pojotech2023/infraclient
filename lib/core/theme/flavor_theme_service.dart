import 'package:flutter/material.dart';
import 'app_theme/app_theme.dart';
import 'colorscheme/colorscheme.dart';
import '../config/flavor_config.dart';

class FlavorThemeService {
  static AppTheme getThemeFromFlavor() {
    final colorScheme = FlavorConfig.appConfig.colorScheme.toLowerCase();
    
    switch (colorScheme) {
      case 'blue':
        return AppTheme.blueLight;
      case 'orange':
        return AppTheme.orangeLight;
      default:
        // Default to blue if color scheme is not recognized
        return AppTheme.blueLight;
    }
  }

  static String getThemeNameFromFlavor() {
    final colorScheme = FlavorConfig.appConfig.colorScheme.toLowerCase();
    
    switch (colorScheme) {
      case 'blue':
        return BuiltInThemes.blueTheme;
      case 'orange':
        return BuiltInThemes.orangeTheme;
      default:
        return BuiltInThemes.blueTheme;
    }
  }

  static AppColorScheme getColorSchemeFromFlavor(Brightness brightness) {
    final appTheme = getThemeFromFlavor();
    return brightness == Brightness.light 
        ? appTheme.lightTheme 
        : appTheme.darkTheme;
  }
}
