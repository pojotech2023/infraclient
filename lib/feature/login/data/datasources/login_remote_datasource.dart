import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';

abstract class LoginRemoteDataSource {
  Future<CustomerModel> loginCustomer(String mobileNo);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  LoginRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<CustomerModel> loginCustomer(String mobileNo) async {
    print('--- API REQUEST: loginCustomer ---');
    print('URL: $baseUrl/login-customer');
    print('BODY: ${json.encode({'mobile_no': mobileNo})}');

    final response = await client.post(
      Uri.parse('$baseUrl/login-customer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile_no': mobileNo}),
    );

    print('--- API RESPONSE: loginCustomer ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        final customerJson = data['data']['customer'];
        final token = data['data']['token'] ?? data['token']; // Fallback in case it's outside
        final model = CustomerModel.safeFromJson(customerJson);
        return model.copyWith(token: token?.toString());
      } else {
        throw Exception(data['message'] ?? 'Failed to login');
      }
    } else {
      String errorMessage = 'Failed to login';
      try {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }
}
