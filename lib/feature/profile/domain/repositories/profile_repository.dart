abstract class ProfileRepository {
  Future<String> updateProfilePicture({
    required int customerId,
    required String imagePath,
  });

  Future<void> updateProfileDetails({
    required int customerId,
    required String name,
    required String email,
    required String dob,
    required String address,
  });
}
