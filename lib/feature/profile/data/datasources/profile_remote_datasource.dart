import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env_service.dart';
import '../../../login/data/models/customer_model.dart';

abstract class ProfileRemoteDataSource {
  Future<String> uploadProfilePicture({
    required int customerId,
    required String imagePath,
    required String token,
  });

  Future<CustomerModel> getClientProfile({required String token});

  Future<void> updateProfileDetails({
    required Map<String, dynamic> data,
    required String token,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<CustomerModel> getClientProfile({required String token}) async {
    final uri = Uri.parse('$baseUrl/client-profile');
    print('--- API REQUEST: getClientProfile ---');
    print('URL: $uri');

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('--- API RESPONSE: getClientProfile ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return CustomerModel.safeFromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch client profile');
      }
    } else {
      String msg = 'Failed to fetch profile (${response.statusCode})';
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
  Future<String> uploadProfilePicture({
    required int customerId,
    required String imagePath,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/update-profile-picture');
    
    print('--- API REQUEST: uploadProfilePicture ---');
    print('URL: $uri');
    print('IMAGE_PATH: $imagePath');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields['customer_id'] = customerId.toString();
    
    request.files.add(
      await http.MultipartFile.fromPath('profile_pic', imagePath),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('--- API RESPONSE: uploadProfilePicture ---');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          return data['profile_pic_url'] ?? '';
        } else {
          throw Exception(data['message'] ?? 'Failed to upload profile picture: Backend returned status false');
        }
      } else {
        throw Exception('Failed to upload profile picture: Server returned ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      print('EXCEPTION in uploadProfilePicture: $e');
      throw Exception('Error uploading profile picture: $e');
    }
  }

  @override
  Future<void> updateProfileDetails({
    required Map<String, dynamic> data,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/client-profile-update');
    
    print('--- API REQUEST: updateProfileDetails ---');
    print('URL: $uri');
    print('DATA: $data');

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    print('--- API RESPONSE: updateProfileDetails ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }

    final responseData = json.decode(response.body);
    if (responseData['status'] != true) {
      throw Exception(responseData['message'] ?? 'Failed to update profile');
    }
  }
}
