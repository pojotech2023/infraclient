import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginWithMobile extends LoginEvent {
  final String mobileNo;

  LoginWithMobile(this.mobileNo);

  @override
  List<Object?> get props => [mobileNo];
}
