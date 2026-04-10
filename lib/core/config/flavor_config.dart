import 'package:flutter/foundation.dart';
import 'app_config.dart';

enum Flavor {
  dev,
  prod,
  demo,
  uat,
}

class FlavorConfig {
  static Flavor? _flavor;
  static AppConfig? _appConfig;

  static Flavor get flavor {
    _flavor ??= _getFlavorFromEnvironment();
    return _flavor!;
  }

  static AppConfig get appConfig {
    if (_appConfig == null) {
      throw Exception('AppConfig not initialized. Call FlavorConfig.init() first.');
    }
    return _appConfig!;
  }

  static Flavor _getFlavorFromEnvironment() {
    const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    
    switch (flavorString.toLowerCase()) {
      case 'dev':
        return Flavor.dev;
      case 'prod':
        return Flavor.prod;
      case 'demo':
        return Flavor.demo;
      case 'uat':
        return Flavor.uat;
      default:
        if (kDebugMode) {
          print('Unknown flavor: $flavorString. Defaulting to dev.');
        }
        return Flavor.dev;
    }
  }

  static String get flavorName {
    switch (flavor) {
      case Flavor.dev:
        return 'Dev';
      case Flavor.prod:
        return 'Production';
      case Flavor.demo:
        return 'Demo';
      case Flavor.uat:
        return 'UAT';
    }
  }

  static String get flavorAssetPath {
    switch (flavor) {
      case Flavor.dev:
        return 'dev';
      case Flavor.prod:
        return 'prod';
      case Flavor.demo:
        return 'demo';
      case Flavor.uat:
        return 'uat';
    }
  }

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;
  static bool get isDemo => flavor == Flavor.demo;
  static bool get isUat => flavor == Flavor.uat;

  static void init(AppConfig config) {
    _appConfig = config;
  }
}
