import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '../../../../core/cache/local_storage.dart';
import '../models/ticket_message_model.dart';

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
  Future<List<TicketMessageModel>> getTicketMessages(int ticketId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ticket/$ticketId/messages');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('--- API REQUEST: getTicketMessages ---');
    print('URL: $url');

    final response = await client.get(url, headers: headers);

    print('--- API RESPONSE: getTicketMessages ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['data'] as List;
      return list.map((e) => TicketMessageModel.fromJson(e)).toList();
    } else {
      String msg = 'Failed to load messages (${response.statusCode})';
      try {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('message')) {
          msg = data['message'];
        }
      } catch (_) {}
      throw Exception(msg);
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
    final token = await _getToken();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/tickets/messages-store'))
      ..fields['ticket_id'] = ticketId
      ..fields['site_id'] = siteId
      ..fields['sender_type'] = senderType
      ..fields['message'] = message;

    request.headers['Accept'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (attachment != null) {
      final ext = attachment.path.split('.').last.toLowerCase();
      final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
      final isVideo = ['mp4', 'mov', 'mkv'].contains(ext);
      final isPdf = ext == 'pdf';
      final isExcel = ['xls', 'xlsx'].contains(ext);

      final fieldKey = 'attachment';
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
      String msg = 'Failed to send message (${response.statusCode})';
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
