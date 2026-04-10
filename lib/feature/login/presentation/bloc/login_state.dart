import 'package:equatable/equatable.dart';
import '../../domain/entities/customer_entity.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final CustomerEntity customer;

  LoginSuccess(this.customer);

  @override
  List<Object?> get props => [customer];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
