// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerModelImpl _$$CustomerModelImplFromJson(Map<String, dynamic> json) =>
    _$CustomerModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      siteId: (json['site_id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      mobileNo: json['mobileNo'] as String? ?? '',
      email: json['email'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      marriageDate: json['marriageDate'] as String? ?? '',
      address: json['address'] as String? ?? '',
      isInactive: (json['isInactive'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      profilePic: json['profile_pic'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$CustomerModelImplToJson(_$CustomerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'site_id': instance.siteId,
      'name': instance.name,
      'mobileNo': instance.mobileNo,
      'email': instance.email,
      'dob': instance.dob,
      'marriageDate': instance.marriageDate,
      'address': instance.address,
      'isInactive': instance.isInactive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'profile_pic': instance.profilePic,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'token': instance.token,
    };
