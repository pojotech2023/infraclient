import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/cache/local_storage.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_datasource.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  LoginRepositoryImpl({required this.remoteDataSource, required this.localStorage});

  @override
  Future<Either<Failure, CustomerEntity>> loginCustomer(String mobileNo) async {
    try {
      final customer = await remoteDataSource.loginCustomer(mobileNo);

      String? siteName;
      try {
        final rawSiteName = await localStorage.load(key: 'site_name', boxName: 'auth');
        if (rawSiteName != null) siteName = rawSiteName.toString();
      } catch (_) {}

      // Save with explicit snake_case keys to match what the rest of the app reads
      await localStorage.save(
        key: 'user',
        value: json.encode({
          'id': customer.id,
          'site_id': customer.siteId,
          if (siteName != null && siteName.isNotEmpty) 'site_name': siteName,
          'name': customer.name,
          'mobile_no': customer.mobileNo,
          'email': customer.email,
          'dob': customer.dob,
          'marriage_date': customer.marriageDate,
          'address': customer.address,
          'is_inactive': customer.isInactive,
          'created_at': customer.createdAt,
          'updated_at': customer.updatedAt,
          if (customer.token != null) 'token': customer.token,
        }),
        boxName: 'auth',
      );

      if (customer.token != null) {
        try {
          await localStorage.save(
            key: 'token',
            value: customer.token.toString(),
            boxName: 'auth',
          );
        } catch (_) {}
      }

      print('--- SESSION SAVED ---');
      print('id: ${customer.id}, site_id: ${customer.siteId}, name: ${customer.name}, site_name: $siteName');

      final customerEntity = customer.toEntity();
      return Right(customerEntity);
    } catch (e) {
      return Left(ServerFailure(message: e.toString().replaceAll('Exception: ', ''), statusCode: 500));
    }
  }
}
