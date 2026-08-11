abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileDetails extends ProfileEvent {
  final Map<String, dynamic> data;
  UpdateProfileDetails(this.data);
}

class UploadProfilePicture extends ProfileEvent {
  final int customerId;
  final String imagePath;
  UploadProfilePicture({required this.customerId, required this.imagePath});
}
