// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) {
  return _CustomerModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  int get siteId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get mobileNo => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get dob => throw _privateConstructorUsedError;
  String get marriageDate => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get isInactive => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_pic')
  String? get profilePic => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this CustomerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerModelCopyWith<CustomerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerModelCopyWith<$Res> {
  factory $CustomerModelCopyWith(
    CustomerModel value,
    $Res Function(CustomerModel) then,
  ) = _$CustomerModelCopyWithImpl<$Res, CustomerModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') int id,
    @JsonKey(name: 'site_id') int siteId,
    String name,
    String mobileNo,
    String email,
    String dob,
    String marriageDate,
    String address,
    int isInactive,
    String createdAt,
    String updatedAt,
    @JsonKey(name: 'profile_pic') String? profilePic,
    String? createdBy,
    String? updatedBy,
  });
}

/// @nodoc
class _$CustomerModelCopyWithImpl<$Res, $Val extends CustomerModel>
    implements $CustomerModelCopyWith<$Res> {
  _$CustomerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? siteId = null,
    Object? name = null,
    Object? mobileNo = null,
    Object? email = null,
    Object? dob = null,
    Object? marriageDate = null,
    Object? address = null,
    Object? isInactive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profilePic = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            siteId:
                null == siteId
                    ? _value.siteId
                    : siteId // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            mobileNo:
                null == mobileNo
                    ? _value.mobileNo
                    : mobileNo // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            dob:
                null == dob
                    ? _value.dob
                    : dob // ignore: cast_nullable_to_non_nullable
                        as String,
            marriageDate:
                null == marriageDate
                    ? _value.marriageDate
                    : marriageDate // ignore: cast_nullable_to_non_nullable
                        as String,
            address:
                null == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String,
            isInactive:
                null == isInactive
                    ? _value.isInactive
                    : isInactive // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as String,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as String,
            profilePic:
                freezed == profilePic
                    ? _value.profilePic
                    : profilePic // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            updatedBy:
                freezed == updatedBy
                    ? _value.updatedBy
                    : updatedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerModelImplCopyWith<$Res>
    implements $CustomerModelCopyWith<$Res> {
  factory _$$CustomerModelImplCopyWith(
    _$CustomerModelImpl value,
    $Res Function(_$CustomerModelImpl) then,
  ) = __$$CustomerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') int id,
    @JsonKey(name: 'site_id') int siteId,
    String name,
    String mobileNo,
    String email,
    String dob,
    String marriageDate,
    String address,
    int isInactive,
    String createdAt,
    String updatedAt,
    @JsonKey(name: 'profile_pic') String? profilePic,
    String? createdBy,
    String? updatedBy,
  });
}

/// @nodoc
class __$$CustomerModelImplCopyWithImpl<$Res>
    extends _$CustomerModelCopyWithImpl<$Res, _$CustomerModelImpl>
    implements _$$CustomerModelImplCopyWith<$Res> {
  __$$CustomerModelImplCopyWithImpl(
    _$CustomerModelImpl _value,
    $Res Function(_$CustomerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? siteId = null,
    Object? name = null,
    Object? mobileNo = null,
    Object? email = null,
    Object? dob = null,
    Object? marriageDate = null,
    Object? address = null,
    Object? isInactive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profilePic = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _$CustomerModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        siteId:
            null == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        mobileNo:
            null == mobileNo
                ? _value.mobileNo
                : mobileNo // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        dob:
            null == dob
                ? _value.dob
                : dob // ignore: cast_nullable_to_non_nullable
                    as String,
        marriageDate:
            null == marriageDate
                ? _value.marriageDate
                : marriageDate // ignore: cast_nullable_to_non_nullable
                    as String,
        address:
            null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String,
        isInactive:
            null == isInactive
                ? _value.isInactive
                : isInactive // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as String,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as String,
        profilePic:
            freezed == profilePic
                ? _value.profilePic
                : profilePic // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        updatedBy:
            freezed == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerModelImpl extends _CustomerModel {
  const _$CustomerModelImpl({
    @JsonKey(name: 'id') this.id = 0,
    @JsonKey(name: 'site_id') this.siteId = 0,
    this.name = '',
    this.mobileNo = '',
    this.email = '',
    this.dob = '',
    this.marriageDate = '',
    this.address = '',
    this.isInactive = 0,
    this.createdAt = '',
    this.updatedAt = '',
    @JsonKey(name: 'profile_pic') this.profilePic,
    this.createdBy,
    this.updatedBy,
  }) : super._();

  factory _$CustomerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'site_id')
  final int siteId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String mobileNo;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String dob;
  @override
  @JsonKey()
  final String marriageDate;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final int isInactive;
  @override
  @JsonKey()
  final String createdAt;
  @override
  @JsonKey()
  final String updatedAt;
  @override
  @JsonKey(name: 'profile_pic')
  final String? profilePic;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'CustomerModel(id: $id, siteId: $siteId, name: $name, mobileNo: $mobileNo, email: $email, dob: $dob, marriageDate: $marriageDate, address: $address, isInactive: $isInactive, createdAt: $createdAt, updatedAt: $updatedAt, profilePic: $profilePic, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mobileNo, mobileNo) ||
                other.mobileNo == mobileNo) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.marriageDate, marriageDate) ||
                other.marriageDate == marriageDate) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isInactive, isInactive) ||
                other.isInactive == isInactive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    siteId,
    name,
    mobileNo,
    email,
    dob,
    marriageDate,
    address,
    isInactive,
    createdAt,
    updatedAt,
    profilePic,
    createdBy,
    updatedBy,
  );

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerModelImplCopyWith<_$CustomerModelImpl> get copyWith =>
      __$$CustomerModelImplCopyWithImpl<_$CustomerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerModelImplToJson(this);
  }
}

abstract class _CustomerModel extends CustomerModel {
  const factory _CustomerModel({
    @JsonKey(name: 'id') final int id,
    @JsonKey(name: 'site_id') final int siteId,
    final String name,
    final String mobileNo,
    final String email,
    final String dob,
    final String marriageDate,
    final String address,
    final int isInactive,
    final String createdAt,
    final String updatedAt,
    @JsonKey(name: 'profile_pic') final String? profilePic,
    final String? createdBy,
    final String? updatedBy,
  }) = _$CustomerModelImpl;
  const _CustomerModel._() : super._();

  factory _CustomerModel.fromJson(Map<String, dynamic> json) =
      _$CustomerModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'site_id')
  int get siteId;
  @override
  String get name;
  @override
  String get mobileNo;
  @override
  String get email;
  @override
  String get dob;
  @override
  String get marriageDate;
  @override
  String get address;
  @override
  int get isInactive;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  @JsonKey(name: 'profile_pic')
  String? get profilePic;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerModelImplCopyWith<_$CustomerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
