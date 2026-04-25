import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env_service.dart';

abstract class ProfileRemoteDataSource {
  Future<String> uploadProfilePicture({
    required int customerId,
    required String imagePath,
  });

  Future<void> updateProfileDetails({
    required int customerId,
    required String name,
    required String email,
    required String dob,
    required String address,
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
  Future<String> uploadProfilePicture({
    required int customerId,
    required String imagePath,
  }) async {
    final uri = Uri.parse('$baseUrl/update-profile-picture');
    
    print('--- API REQUEST: uploadProfilePicture ---');
    print('URL: $uri');
    print('CUSTOMER_ID: $customerId');
    print('IMAGE_PATH: $imagePath');

    final request = http.MultipartRequest('POST', uri);
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
    required int customerId,
    required String name,
    required String email,
    required String dob,
    required String address,
  }) async {
    final uri = Uri.parse('$baseUrl/update-profile');
    
    print('--- API REQUEST: updateProfileDetails ---');
    print('URL: $uri');
    print('DATA: customer_id=$customerId, name=$name, email=$email, dob=$dob, address=$address');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customer_id': customerId,
        'name': name,
        'email': email,
        'dob': dob,
        'address': address,
      }),
    );

    print('--- API RESPONSE: updateProfileDetails ---');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }

    final data = json.decode(response.body);
    if (data['status'] != true) {
      throw Exception(data['message'] ?? 'Failed to update profile');
    }
  }
}
