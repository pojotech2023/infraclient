import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../../../core/cache/local_storage.dart';
import '../models/ticket_model.dart';
import '../../../../core/config/flavor_config.dart';

class TicketApiService {
  final http.Client client;
  final String baseUrl = FlavorConfig.appConfig.baseUrl;

  TicketApiService({required this.client});

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

  Future<List<TicketModel>> fetchTicketsBySite(int siteId) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/get-tickets-by-site/$siteId');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('--- API REQUEST: fetchTicketsBySite ---');
    print('URL: $uri');

    final response = await client.get(
      uri,
      headers: headers,
    );

    print('--- API RESPONSE: fetchTicketsBySite ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> ticketsJson = data['data'] ?? [];
      return ticketsJson.map((json) => TicketModel.fromJson(json)).toList();
    } else {
      String msg = 'Failed to fetch tickets (${response.statusCode})';
      try {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('message')) {
          msg = data['message'];
        }
      } catch (_) {}
      throw Exception(msg);
    }
  }

  Future<void> addTicket({
    required int siteId,
    required int customerId,
    required String ticket,
    String? attachmentPath,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/ticket-submit');
    print('--- API REQUEST: addTicket ---');
    print('URL: $baseUrl/ticket-submit');
    print('FIELDS: site_id=$siteId, customer_id=$customerId, ticket=$ticket');
    print('ATTACHMENT: $attachmentPath');
  
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.fields['site_id'] = siteId.toString();
    request.fields['customer_id'] = customerId.toString();
    request.fields['ticket'] = ticket;

    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('attachment', attachmentPath));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print('--- API RESPONSE: addTicket ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String msg = 'Failed to create ticket (${response.statusCode})';
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
