import 'dart:convert';
import '../../../../core/cache/local_storage.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../login/domain/entities/customer_entity.dart';
import '../../../login/data/models/customer_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<CustomerEntity> getClientProfile() async {
    final token = await _getToken();
    final customerModel = await remoteDataSource.getClientProfile(token: token);
    
    // Save fresh data to local storage
    await _saveUserToLocal(customerModel);
    
    // Read back the merged data to ensure local overrides (like local_profile_pic) are applied
    final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
    if (rawUser != null) {
      Map<String, dynamic> user = {};
      if (rawUser is String) {
        user = json.decode(rawUser);
      } else if (rawUser is Map) {
        user = Map<String, dynamic>.from(rawUser);
      }
      final mergedModel = CustomerModel.safeFromJson(user);
      return mergedModel.toEntity();
    }
    
    return customerModel.toEntity();
  }

  @override
  Future<String> updateProfilePicture({
    required int customerId,
    required String imagePath,
  }) async {
    final token = await _getToken();
    final imageUrl = await remoteDataSource.uploadProfilePicture(
      customerId: customerId,
      imagePath: imagePath,
      token: token,
    );

    // Update local storage
    final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
    if (rawUser != null) {
      Map<String, dynamic> user = {};
      if (rawUser is String) {
        user = json.decode(rawUser);
      } else if (rawUser is Map) {
        user = Map<String, dynamic>.from(rawUser);
      }

      user['profile_pic'] = imageUrl;

      await localStorage.save(
        key: 'user',
        value: json.encode(user),
        boxName: 'auth',
      );
      print('--- SESSION UPDATED WITH NEW PROFILE PIC ---');
    }

    return imageUrl;
  }

  @override
  Future<void> updateProfileDetails(Map<String, dynamic> data) async {
    final token = await _getToken();
    await remoteDataSource.updateProfileDetails(data: data, token: token);

    // Update local storage
    final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
    if (rawUser != null) {
      Map<String, dynamic> user = {};
      if (rawUser is String) {
        user = json.decode(rawUser);
      } else if (rawUser is Map) {
        user = Map<String, dynamic>.from(rawUser);
      }

      // Update the fields that were passed in
      for (var key in data.keys) {
        user[key] = data[key];
      }

      await localStorage.save(
        key: 'user',
        value: json.encode(user),
        boxName: 'auth',
      );
      print('--- SESSION UPDATED WITH NEW PROFILE DETAILS ---');
    }
  }

  Future<String> _getToken() async {
    final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
    if (rawUser != null) {
      Map<String, dynamic> user = {};
      if (rawUser is String) {
        user = json.decode(rawUser);
      } else if (rawUser is Map) {
        user = Map<String, dynamic>.from(rawUser);
      }
      return user['token'] ?? user['mobile_no'] ?? user['id']?.toString() ?? '';
    }
    throw Exception("No user found in local storage");
  }

  Future<void> _saveUserToLocal(dynamic customerModel) async {
    // Note: To merge with existing token if any, we first get current user
    final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
    Map<String, dynamic> currentUser = {};
    if (rawUser != null) {
      if (rawUser is String) {
        currentUser = json.decode(rawUser);
      } else if (rawUser is Map) {
        currentUser = Map<String, dynamic>.from(rawUser);
      }
    }
    
    String? token = customerModel.token;
    // Merge: preserve token if fresh doesn't have it or is null
    if (token == null && currentUser.containsKey('token')) {
      token = currentUser['token'];
    }

    await localStorage.save(
      key: 'user',
      value: json.encode({
        'id': customerModel.id,
        'site_id': customerModel.siteId,
        'name': customerModel.name,
        'mobile_no': customerModel.mobileNo,
        'email': customerModel.email,
        'dob': customerModel.dob,
        'marriage_date': customerModel.marriageDate,
        'address': customerModel.address,
        'is_inactive': customerModel.isInactive,
        'created_at': customerModel.createdAt,
        'updated_at': customerModel.updatedAt,
        'profile_pic': customerModel.profilePic,
        if (token != null) 'token': token,
        if (currentUser.containsKey('local_profile_pic')) 'local_profile_pic': currentUser['local_profile_pic'],
      }),
      boxName: 'auth',
    );
  }
}
