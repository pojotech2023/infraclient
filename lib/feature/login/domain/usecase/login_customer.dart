import 'package:dartz/dartz.dart';
import '../entities/customer_entity.dart';
import '../repositories/login_repository.dart';
import '../../../../core/error/failures.dart';

class LoginCustomer {
  final LoginRepository repository;

  LoginCustomer(this.repository);

  Future<Either<Failure, CustomerEntity>> call(String mobileNo) async {
    return await repository.loginCustomer(mobileNo);
  }
}
