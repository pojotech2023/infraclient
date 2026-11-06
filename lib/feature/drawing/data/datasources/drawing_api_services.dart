import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../../../core/cache/local_storage.dart';
import '../models/drawing_model.dart';
import '../../../../core/config/flavor_config.dart';

class DrawingApiService {
  final http.Client client;
  final String baseUrl = FlavorConfig.appConfig.baseUrl;

  DrawingApiService({required this.client});

  Future<String?> _getToken() async {
    try {
      final localStorage = GetIt.I<LocalStorage>();
      final token = await localStorage.load(key: 'token', boxName: 'auth');
      if (token != null && token.toString().trim().isNotEmpty) {
        return token.toString().trim();
      }
      final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
      if (rawUser != null) {
        Map<String, dynamic> user = {};
        if (rawUser is String) {
          user = json.decode(rawUser);
        } else if (rawUser is Map) {
          user = Map<String, dynamic>.from(rawUser);
        }
        final userToken = user['token']?.toString();
        if (userToken != null && userToken.trim().isNotEmpty) {
          return userToken.trim();
        }
      }
    } catch (_) {}
    return null;
  }

  Future<List<DrawingModel>> fetchDrawingBySite(int siteId) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/drawings/by-site/$siteId');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('--- API REQUEST: fetchDrawingBySite ---');
    print('URL: $uri');

    final response = await client.get(
      uri,
      headers: headers,
    );

    print('--- API RESPONSE: fetchDrawingBySite ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> outputJson = data['data'] ?? [];
      return outputJson.map((json) => DrawingModel.fromJson(json)).toList();
    } else {
      String msg = 'Failed to fetch drawings (${response.statusCode})';
      try {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('message')) {
          msg = data['message'];
        }
      } catch (_) {}
      throw Exception(msg);
    }
  }
}
