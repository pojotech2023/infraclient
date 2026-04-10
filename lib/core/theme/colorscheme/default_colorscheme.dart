import 'package:flutter/material.dart';
import 'colorscheme.dart';

class DefaultColorScheme extends AppColorScheme {
  DefaultColorScheme.light()
      : super(
    primary: const Color(0xFF6B7280), // Gray 500
    onPrimary: const Color(0xFFFFFFFF), // White
    primaryContainer: const Color(0xFFF9FAFB), // Gray 50
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

  DefaultColorScheme.dark()
      : super(
    primary: const Color(0xFF9CA3AF), // Gray 400
    onPrimary: const Color(0xFF1F2937), // Gray 800
    primaryContainer: const Color(0xFF374151), // Gray 700
    secondary: const Color(0xFF9CA3AF), // Gray 400
    onSecondary: const Color(0xFF1F2937), // Gray 800
    background: const Color(0xFF0F172A), // Slate 900
    onBackground: const Color(0xFFF1F5F9), // Slate 100
    surface: const Color(0xFF1E293B), // Slate 800
    onSurface: const Color(0xFFF1F5F9), // Slate 100
    error: const Color(0xFFF87171), // Red 400
    onError: const Color(0xFF7F1D1D), // Red 900
    scaffoldBackgroundColor: const Color(0xFF1E293B), // Slate 800
  );
}
