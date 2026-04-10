import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_entity.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'site_id') @Default(0) int siteId,
    @Default('') String name,
    @Default('') String mobileNo,
    @Default('') String email,
    @Default('') String dob,
    @Default('') String marriageDate,
    @Default('') String address,
    @Default(0) int isInactive,
    @Default('') String createdAt,
    @Default('') String updatedAt,
     String? createdBy,
    String? updatedBy,
  }) = _CustomerModel;

  const CustomerModel._();

  // Add this line to support Freezed code generation
  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  // Custom JSON parser if you want stricter conversion
  factory CustomerModel.safeFromJson(Map<String, dynamic> json) {
    int asInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? 0;
      }
      return 0;
    }

    String asString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return CustomerModel(
      id: asInt(json['id']),
      siteId: asInt(json['site_id']),
      name: asString(json['name']),
      mobileNo: asString(json['mobile_no']),
      email: asString(json['email']),
      dob: asString(json['dob']),
      marriageDate: asString(json['marriage_date']),
      address: asString(json['address']),
      isInactive: asInt(json['is_inactive']),
      createdAt: asString(json['created_at']),
      updatedAt: asString(json['updated_at']),
    );
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      siteId: siteId,
      name: name,
      mobileNo: mobileNo,
      email: email,
      dob: dob,
      marriageDate: marriageDate,
      address: address,
      isInactive: isInactive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}
