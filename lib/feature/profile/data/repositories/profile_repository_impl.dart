import 'dart:convert';
import '../../../../core/cache/local_storage.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<String> updateProfilePicture({
    required int customerId,
    required String imagePath,
  }) async {
    final imageUrl = await remoteDataSource.uploadProfilePicture(
      customerId: customerId,
      imagePath: imagePath,
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

      // Update the profile_pic field
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
  Future<void> updateProfileDetails({
    required int customerId,
    required String name,
    required String email,
    required String dob,
    required String address,
  }) async {
    await remoteDataSource.updateProfileDetails(
      customerId: customerId,
      name: name,
      email: email,
      dob: dob,
      address: address,
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

      // Update the fields
      user['name'] = name;
      user['email'] = email;
      user['dob'] = dob;
      user['address'] = address;

      await localStorage.save(
        key: 'user',
        value: json.encode(user),
        boxName: 'auth',
      );
      print('--- SESSION UPDATED WITH NEW PROFILE DETAILS ---');
    }
  }
}
