import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../../../core/cache/local_storage.dart';
import '../models/checklist_model.dart';

abstract class ChecklistRemoteDataSource {
  Future<List<ChecklistModel>> getChecklist({required int siteId});
  Future<Map<String, dynamic>> getAdminSupervisorRemarks({required int taskId, required int siteId});
}

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChecklistRemoteDataSourceImpl({required this.client, required this.baseUrl});

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

  @override
  Future<List<ChecklistModel>> getChecklist({required int siteId}) async {
    final uri = Uri.parse('$baseUrl/checklists/$siteId');
    final token = await _getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('--- API REQUEST: getChecklist ---');
    print('URL: $uri');
    print('HEADERS: $headers');

    final response = await client.get(uri, headers: headers);

    print('--- API RESPONSE: getChecklist ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final body = response.body;
      final decoded = json.decode(body);

      if (decoded is List) {
        return decoded
            .map((e) => ChecklistModelFromMapSafe.fromMapSafe(e as Map<String, dynamic>?))
            .toList();
      } else if (decoded is Map<String, dynamic>) {
        final list = (decoded['checklists'] as List?) ?? <dynamic>[];
        return list
            .map((e) => ChecklistModelFromMapSafe.fromMapSafe(e as Map<String, dynamic>?))
            .toList();
      }
      return <ChecklistModel>[];
    } else {
      String errorMessage = 'Unable to fetch checklist (Server error ${response.statusCode})';
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          errorMessage = decoded['message'].toString();
        }
      } catch (_) {
        if (response.statusCode >= 500) {
          errorMessage = 'Server is currently temporarily unavailable. Please try again shortly.';
        }
      }
      throw Exception(errorMessage);
    }
  }

  @override
  Future<Map<String, dynamic>> getAdminSupervisorRemarks({required int taskId, required int siteId}) async {
    final uri = Uri.parse('$baseUrl/checklist-admin-supervisor-remarks?task_id=$taskId&site_id=$siteId');
    final token = await _getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('--- API REQUEST: getAdminSupervisorRemarks ---');
    print('URL: $uri');

    final response = await client.get(uri, headers: headers);

    print('--- API RESPONSE: getAdminSupervisorRemarks ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } else {
      String errorMessage = 'Unable to fetch remarks (${response.statusCode})';
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          errorMessage = decoded['message'].toString();
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }
}
