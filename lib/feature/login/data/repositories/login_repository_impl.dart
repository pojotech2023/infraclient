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

      // Save with explicit snake_case keys to match what the rest of the app reads
      await localStorage.save(
  key: 'user',
  value: json.encode({
    'id': customer.id,
    'site_id': customer.siteId,
    'name': customer.name,
    'mobile_no': customer.mobileNo,
    'email': customer.email,
    'dob': customer.dob,
    'marriage_date': customer.marriageDate,
    'address': customer.address,
    'is_inactive': customer.isInactive,
    'created_at': customer.createdAt,
    'updated_at': customer.updatedAt,
  }),
  boxName: 'auth',
);

      print('--- SESSION SAVED ---');
      print('id: ${customer.id}, site_id: ${customer.siteId}, name: ${customer.name}');

      final customerEntity = customer.toEntity();
      return Right(customerEntity);
    } catch (e) {
      return Left(ServerFailure(message: e.toString().replaceAll('Exception: ', ''), statusCode: 500));
    }
  }
}
