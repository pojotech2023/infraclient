import '../../../login/domain/entities/customer_entity.dart';

abstract class ProfileRepository {
  Future<CustomerEntity> getClientProfile();

  Future<String> updateProfilePicture({
    required int customerId,
    required String imagePath,
  });

  Future<void> updateProfileDetails(Map<String, dynamic> data);
}
