import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/customer_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, CustomerEntity>> loginCustomer(String mobileNo);
}


