
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/drawing_model.dart';
import '../../../../core/config/flavor_config.dart';

class DrawingApiService {
  final http.Client client;
  final String baseUrl = FlavorConfig.appConfig.baseUrl;

  DrawingApiService({required this.client});

  Future<List<DrawingModel>> fetchDrawingBySite(int siteId) async {
    print('--- API REQUEST: fetchDrawingBySite ---');
    print('URL: $baseUrl/drawings/by-site/$siteId');

    final response = await client.get(
      Uri.parse('$baseUrl/drawings/by-site/$siteId'),
      headers: {'Content-Type': 'application/json'},
    );

    print('--- API RESPONSE: fetchDrawingBySite ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> outputJson = data['data'];
      return outputJson.map((json) => DrawingModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tickets');
    }
  }


}
