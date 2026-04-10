import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/login_customer.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginCustomer loginCustomer;

  LoginBloc({required this.loginCustomer}) : super(LoginInitial()) {
    on<LoginWithMobile>((event, emit) async {
      emit(LoginLoading());
      final result = await loginCustomer(event.mobileNo);
      result.fold(
            (failure) => emit(LoginFailure(failure.message)),
            (customer) => emit(LoginSuccess(customer)),
      );
    });
  }
}
