import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.getClientProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileDetails>((event, emit) async {
      final currentState = state;
      emit(ProfileLoading());
      try {
        await repository.updateProfileDetails(event.data);
        final profile = await repository.getClientProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
        if (currentState is ProfileLoaded) {
          emit(ProfileLoaded(currentState.profile)); // revert on error
        }
      }
    });

    on<UploadProfilePicture>((event, emit) async {
      final currentState = state;
      emit(ProfileLoading());
      try {
        await repository.updateProfilePicture(
          customerId: event.customerId,
          imagePath: event.imagePath,
        );
        final profile = await repository.getClientProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
        if (currentState is ProfileLoaded) {
          emit(ProfileLoaded(currentState.profile));
        }
      }
    });
  }
}
