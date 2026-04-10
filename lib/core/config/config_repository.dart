// lib/core/config/config_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'app_config.dart';
import 'flavor_config.dart';

class ConfigRepository {
  Future<AppConfig> loadFlavor(Flavor flavor) async {
    final flavorName = flavor.name;
    final jsonString = await rootBundle.loadString('assets/config/$flavorName.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AppConfig.fromJson(jsonMap);
  }

  Future<AppConfig> loadCurrentFlavor() async {
    return loadFlavor(FlavorConfig.flavor);
  }
}
