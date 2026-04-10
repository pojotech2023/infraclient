import '../colorscheme/blue_colorscheme.dart';
import '../colorscheme/colorscheme.dart';

import '../colorscheme/default_colorscheme.dart';
import '../colorscheme/orange_colorscheme.dart';


class BuiltInThemes {
  static const String defaultTheme = 'Default';
  static const String blueTheme = 'Blue';
  static const String orangeTheme = 'Orange';

}

class AppTheme {
  final bool builtIn;
  final String themeName;
  final AppColorScheme lightTheme;
  final AppColorScheme darkTheme;

  const AppTheme({
    required this.builtIn,
    required this.themeName,
    required this.lightTheme,
    required this.darkTheme,
  });

  static AppTheme get fallback => AppTheme(
    builtIn: true,
    themeName: BuiltInThemes.defaultTheme,
    lightTheme: DefaultColorScheme.light(),
    darkTheme: DefaultColorScheme.dark(),
  );

  static AppTheme get blueLight => AppTheme(
    builtIn: true,
    themeName: BuiltInThemes.blueTheme,
    lightTheme: BlueColorScheme.light(),
    darkTheme: BlueColorScheme.dark(),
  );



  static AppTheme get orangeLight => AppTheme(
    builtIn: true,
    themeName: BuiltInThemes.orangeTheme,
    lightTheme: OrangeColorScheme.light(),
    darkTheme: OrangeColorScheme.dark(),
  );



  static final Map<String, AppTheme> themeMap = {
    BuiltInThemes.defaultTheme: fallback,
    BuiltInThemes.blueTheme: blueLight,
    BuiltInThemes.orangeTheme: orangeLight,
  };

  static Iterable<AppTheme> get builtIns => themeMap.values;

  static AppTheme fromName(String themeName) {
    return themeMap[themeName] ?? fallback;
  }
}
