import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:builder_customer/core/config/flavor_config.dart';
import 'package:builder_customer/feature/payment_history/data/models/site_payment_history_model.dart';

class PaymentHistoryRemoteDataSource {
  final http.Client client;
  String? lastError;

  PaymentHistoryRemoteDataSource({required this.client});

  String get baseUrl => FlavorConfig.appConfig.baseUrl;

  /// Normalizes local URLs like http://127.0.0.1:8000 to match the configured baseUrl host
  String normalizeFileUrl(String url) {
    if (url.isEmpty) return url;
    try {
      final baseUri = Uri.parse(baseUrl);
      final fileUri = Uri.parse(url);
      if (fileUri.host == '127.0.0.1' || fileUri.host == 'localhost') {
        if (baseUri.host != '127.0.0.1' && baseUri.host != 'localhost') {
          return Uri(
            scheme: baseUri.scheme,
            host: baseUri.host,
            port: baseUri.hasPort ? baseUri.port : null,
            path: fileUri.path,
            query: fileUri.query.isNotEmpty ? fileUri.query : null,
          ).toString();
        }
      }
    } catch (_) {}
    return url;
  }

  Future<SitePaymentHistoryModel?> getPaymentHistory(int siteId, {String? token}) async {
    final uri = Uri.parse('$baseUrl/site-payment-history/$siteId');
    print('--- API REQUEST: getPaymentHistory ---');
    print('URL: $uri');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await client.get(uri, headers: headers);
      print('--- API RESPONSE: getPaymentHistory ---');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return SitePaymentHistoryModel.fromJson(decoded);
        }
      } else {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map && decoded['message'] != null) {
            lastError = decoded['message'].toString();
          }
        } catch (_) {
          lastError = 'HTTP ${response.statusCode}';
        }
      }
    } catch (e) {
      lastError = e.toString();
    }
    return null;
  }

  Future<SitePaymentSummaryModel?> getPaymentSummary(int siteId, {String? token}) async {
    final uri = Uri.parse('$baseUrl/site-payment-summary/$siteId');
    print('--- API REQUEST: getPaymentSummary ---');
    print('URL: $uri');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await client.get(uri, headers: headers);
      print('--- API RESPONSE: getPaymentSummary ---');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return SitePaymentSummaryModel.fromJson(decoded);
        }
      } else {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map && decoded['message'] != null) {
            lastError = decoded['message'].toString();
          }
        } catch (_) {
          lastError = 'HTTP ${response.statusCode}';
        }
      }
    } catch (e) {
      lastError = e.toString();
    }
    return null;
  }

  Future<String?> getPaymentReceiptPdfUrl(int paymentId, {String? token}) async {
    final uri = Uri.parse('$baseUrl/site-payment-pdf/$paymentId');
    print('--- API REQUEST: getPaymentReceiptPdfUrl ---');
    print('URL: $uri');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await client.get(uri, headers: headers);
    print('--- API RESPONSE: getPaymentReceiptPdfUrl ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          final rawUrl = decoded['pdf_url'] ??
              decoded['download_url'] ??
              decoded['data']?['pdf_url'] ??
              decoded['data']?['download_url'] ??
              decoded['url'];
          if (rawUrl != null && rawUrl.toString().isNotEmpty) {
            return normalizeFileUrl(rawUrl.toString());
          }
        }
      } catch (_) {}
    }

    final fallbackUrl = baseUrl.endsWith('/')
        ? '${baseUrl}site-payment-pdf/$paymentId'
        : '$baseUrl/site-payment-pdf/$paymentId';
    return normalizeFileUrl(fallbackUrl);
  }

  Future<http.Response> downloadPaymentExcel(int siteId, {String? token}) async {
    final uri = Uri.parse('$baseUrl/site-payment-history/$siteId/export');
    print('--- API REQUEST: downloadPaymentExcel ---');
    print('URL: $uri');

    final headers = <String, String>{
      'Accept': 'text/csv, application/json, */*',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await client.get(uri, headers: headers);
  }

  Future<String?> getPaymentExcelExportUrl(int siteId, {String? token}) async {
    final fallbackUrl = baseUrl.endsWith('/')
        ? '${baseUrl}site-payment-history/$siteId/export'
        : '$baseUrl/site-payment-history/$siteId/export';
    return fallbackUrl;
  }
}
