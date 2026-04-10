import 'package:flutter/material.dart';
import 'colorscheme.dart';

class OrangeColorScheme extends AppColorScheme {
  OrangeColorScheme.light()
      : super(
    primary: const Color(0xFFEA580C), // Orange 600
    onPrimary: const Color(0xFFFFFFFF), // White
    primaryContainer: const Color(0xFFFFF7ED), // Orange 50
    secondary: const Color(0xFF6B7280), // Gray 500
    onSecondary: const Color(0xFFFFFFFF), // White
    background: const Color(0xFFFFFFFF), // White
    onBackground: const Color(0xFF1F2937), // Gray 800
    surface: const Color(0xFFFFFFFF), // White
    onSurface: const Color(0xFF1F2937), // Gray 800
    error: const Color(0xFFDC2626), // Red 600
    onError: const Color(0xFFFFFFFF), // White
    scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Gray 50
  );

  OrangeColorScheme.dark()
      : super(
    primary: const Color(0xFFFB923C), // Orange 400
    onPrimary: const Color(0xFF9A3412), // Orange 800
    primaryContainer: const Color(0xFF9A3412), // Orange 800
    secondary: const Color(0xFF9CA3AF), // Gray 400
    onSecondary: const Color(0xFF1F2937), // Gray 800
    background: const Color.fromARGB(255, 13, 13, 13), // Slate 900
    onBackground: const Color(0xFFF1F5F9), // Slate 100
    surface: const Color.fromARGB(255, 74, 67, 65), // Slate 800
    onSurface: const Color(0xFFF1F5F9), // Slate 100
    error: const Color(0xFFF87171), // Red 400
    onError: const Color(0xFF7F1D1D), // Red 900
    scaffoldBackgroundColor: const Color.fromARGB(255, 15, 15, 15), // Slate 800
  );
}