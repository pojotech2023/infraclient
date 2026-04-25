import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_entity.freezed.dart';

@freezed
class CustomerEntity with _$CustomerEntity {
  const factory CustomerEntity({
    required int id,
    required int siteId,
    required String name,
    required String mobileNo,
    required String email,
    required String dob,
    required String marriageDate,
    required String address,
    required int isInactive,
    required String createdAt,
    required String updatedAt,
    String? profilePic,
    String? createdBy,
    String? updatedBy,
  }) = _CustomerEntity;
}
