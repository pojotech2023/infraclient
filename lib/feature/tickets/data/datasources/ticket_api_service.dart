import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ticket_model.dart';
import '../../../../core/config/flavor_config.dart';

class TicketApiService {
  final http.Client client;
  final String baseUrl = FlavorConfig.appConfig.baseUrl;

  TicketApiService({required this.client});

  Future<List<TicketModel>> fetchTicketsBySite(int siteId) async {
    print('--- API REQUEST: fetchTicketsBySite ---');
    print('URL: $baseUrl/get-tickets-by-site/$siteId');

    final response = await client.get(
      Uri.parse('$baseUrl/get-tickets-by-site/$siteId'),
      headers: {'Content-Type': 'application/json'},
    );

    print('--- API RESPONSE: fetchTicketsBySite ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> ticketsJson = data['data'];
      return ticketsJson.map((json) => TicketModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tickets: ${response.body}');
    }
  }

  Future<void> addTicket({
    required int siteId,
    required int customerId,
    required String ticket,
    String? attachmentPath,
  }) async {
    final uri = Uri.parse('$baseUrl/ticket-submit');
    print('--- API REQUEST: addTicket ---');
    print('URL: $baseUrl/ticket-submit');
    print('FIELDS: site_id=$siteId, customer_id=$customerId, ticket=$ticket');
    print('ATTACHMENT: $attachmentPath');
  
    final request = http.MultipartRequest('POST', uri);
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
      throw Exception('Failed to create ticket: ${response.body}');
    }
  }
}
