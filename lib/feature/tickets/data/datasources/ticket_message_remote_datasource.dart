import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '../models/ticket_message_model.dart';
import 'dart:convert';


abstract class TicketMessageRemoteDataSource {
  Future<List<TicketMessageModel>> getTicketMessages(int ticketId);
  Future<void> sendTicketMessage({
    required String siteId,
    required String ticketId,
    required String senderType,
    required String message,
    File? attachment,
  });
}

class TicketMessageRemoteDataSourceImpl implements TicketMessageRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  TicketMessageRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<TicketMessageModel>> getTicketMessages(int ticketId) async {
    final url = Uri.parse('$baseUrl/ticket/$ticketId/messages');
    print('--- API REQUEST: getTicketMessages ---');
    print('URL: $url');

    final response = await client.get(url);

    print('--- API RESPONSE: getTicketMessages ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['data'] as List;
      return list.map((e) => TicketMessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages: ${response.body}');
    }
  }

  @override
  Future<void> sendTicketMessage({
    required String siteId,
    required String ticketId,
    required String senderType,
    required String message,
    File? attachment,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/tickets/messages-store'))
      ..fields['ticket_id'] = ticketId
      ..fields['site_id'] = siteId
      ..fields['sender_type'] = senderType
      ..fields['message'] = message;

  

    if (attachment != null) {
      final ext = attachment.path.split('.').last.toLowerCase();
      final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
      final isVideo = ['mp4', 'mov', 'mkv'].contains(ext);
      final isPdf = ext == 'pdf';
      final isExcel = ['xls', 'xlsx'].contains(ext);

      final fieldKey = 'attachment'; // ✅ depends on backend
      MediaType? type;
      if (isImage) {
        type = MediaType('image', ext);
      } else if (isVideo) {
        type = MediaType('video', ext);
      } else if (isPdf) {
        type = MediaType('application', 'pdf');
      } else if (isExcel) {
        type = ext == 'xls' 
            ? MediaType('application', 'vnd.ms-excel') 
            : MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      }

      if (type != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fieldKey, 
          attachment.path, 
          contentType: type,
          filename: attachment.path.split('/').last,
        ));
      } else {
        print("⚠️ Unsupported file type: $ext");
        return;
      }
    }

    print('--- API REQUEST: sendTicketMessage ---');
    print('URL: ${Uri.parse('$baseUrl/tickets/messages-store')}');
    print('FIELDS: ticket_id=$ticketId, site_id=$siteId, sender_type=$senderType, message=$message');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('--- API RESPONSE: sendTicketMessage ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to send message: ${response.body}');
    }
  }
}
