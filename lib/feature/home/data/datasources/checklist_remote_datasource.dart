import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checklist_model.dart';

abstract class ChecklistRemoteDataSource {
  Future<List<ChecklistModel>> getChecklist({required int siteId});
  Future<Map<String, dynamic>> getAdminSupervisorRemarks({required int taskId, required int siteId});
}

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChecklistRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<ChecklistModel>> getChecklist({required int siteId}) async {
    final uri = Uri.parse('$baseUrl/checklists/$siteId');
    print('--- API REQUEST: getChecklist ---');
    print('URL: $uri');

    final response = await client.get(uri);

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
      throw Exception('Failed to fetch checklist: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> getAdminSupervisorRemarks({required int taskId, required int siteId}) async {
    final uri = Uri.parse('$baseUrl/checklist-admin-supervisor-remarks?task_id=$taskId&site_id=$siteId');
    print('--- API REQUEST: getAdminSupervisorRemarks ---');
    print('URL: $uri');

    final response = await client.get(uri);

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
      throw Exception('Failed to fetch admin supervisor remarks: ${response.body}');
    }
  }
}

