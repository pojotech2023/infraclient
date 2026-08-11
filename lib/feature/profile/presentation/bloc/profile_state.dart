import '../../../login/domain/entities/customer_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final CustomerEntity profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
