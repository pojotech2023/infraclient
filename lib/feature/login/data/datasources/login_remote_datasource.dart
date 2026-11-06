import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../../../core/cache/local_storage.dart';
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
    final trimmedMobile = mobileNo.trim();
    print('--- API REQUEST: loginCustomer ---');
    print('URL: $baseUrl/login-customer');
    print('BODY: mobile_no=$trimmedMobile');

    // The backend requires application/x-www-form-urlencoded (or multipart/form-data).
    // Passing a Map<String, String> as body causes http.post to send urlencoded.
    final response = await client.post(
      Uri.parse('$baseUrl/login-customer'),
      headers: {
        'Accept': 'application/json',
      },
      body: {'mobile_no': trimmedMobile},
    );

    print('--- API RESPONSE: loginCustomer ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        final customerJson = data['data']['customer'];
        final token = data['data']['token'] ?? data['token']; // Fallback in case it's outside
        final siteJson = data['data']?['site'];

        // Save site_name to local storage so all screens can access it
        if (siteJson != null && siteJson['site_name'] != null) {
          try {
            final localStorage = GetIt.I<LocalStorage>();
            await localStorage.save(
              key: 'site_name',
              value: siteJson['site_name'].toString(),
              boxName: 'auth',
            );
          } catch (_) {}
        }

        if (token != null) {
          try {
            final localStorage = GetIt.I<LocalStorage>();
            await localStorage.save(
              key: 'token',
              value: token.toString(),
              boxName: 'auth',
            );
          } catch (_) {}
        }

        final model = CustomerModel.safeFromJson(customerJson);
        return model.copyWith(token: token?.toString());
      } else {
        throw Exception(data['message'] ?? 'Failed to login');
      }
    } else {
      String errorMessage = 'Failed to login (${response.statusCode})';
      try {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'].toString();
        }
      } catch (_) {
        if (response.statusCode >= 500) {
          errorMessage = 'Server is currently temporarily unavailable. Please try again shortly.';
        }
      }
      throw Exception(errorMessage);
    }
  }
}
