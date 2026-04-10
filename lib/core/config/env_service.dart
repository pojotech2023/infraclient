import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'app_config.dart';

class EnvService {
  static bool _isInitialized = false;

  static Future<void> loadEnvFile(String flavor) async {
    if (_isInitialized) return;
    
    try {
      await dotenv.load(fileName: "assets/env/$flavor.env");
      _isInitialized = true;
    } catch (e) {
      // Fallback to loading from assets if dotenv fails
      await _loadFromAssets(flavor);
    }
  }

  static Future<void> _loadFromAssets(String flavor) async {
    try {
      final envContent = await rootBundle.loadString("assets/env/$flavor.env");
      final lines = envContent.split('\n');
      
      for (final line in lines) {
        if (line.trim().isEmpty || line.startsWith('#')) continue;
        
        final parts = line.split('=');
        if (parts.length == 2) {
          dotenv.env[parts[0].trim()] = parts[1].trim();
        }
      }
      _isInitialized = true;
    } catch (e) {
      print('Error loading env file: $e');
    }
  }

  static AppConfig getAppConfigFromEnv() {
    return AppConfig(
      name: dotenv.env['APP_NAME'] ?? 'App',
      companyCode: dotenv.env['COMPANY_CODE'] ?? '001',
      baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.example.com',
      imageUrl:  dotenv.env['IMAGE_URL'] ?? 'https://api.example.com',
      colorScheme: dotenv.env['COLOR_SCHEME'] ?? 'blue',
       appNameImg: dotenv.env['APP_NAME_IMG'] ??'assets/images/png_images/app_name.png',
      logo: dotenv.env['APP_LOGO'] ??'assets/images/png_images/app_logo.png',
      language: dotenv.env['LANGUAGE'] ?? 'en',
      appTheme: dotenv.env['APP_THEME'] ?? 'system',
    );
  }

  static String getString(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return int.tryParse(dotenv.env[key] ?? '') ?? defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return (dotenv.env[key] ?? '').toLowerCase() == 'true';
  }
}
