import 'package:flutter/material.dart';

import '../app_theme/app_theme.dart';

abstract class BaseAppearance {
  ThemeData getThemeData(Brightness brightness, AppTheme appTheme);
}
