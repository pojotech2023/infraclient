// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) {
  return _MediaModel.fromJson(json);
}

/// @nodoc
mixin _$MediaModel {
  String? get type => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this MediaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaModelCopyWith<MediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaModelCopyWith<$Res> {
  factory $MediaModelCopyWith(
    MediaModel value,
    $Res Function(MediaModel) then,
  ) = _$MediaModelCopyWithImpl<$Res, MediaModel>;
  @useResult
  $Res call({String? type, String? url});
}

/// @nodoc
class _$MediaModelCopyWithImpl<$Res, $Val extends MediaModel>
    implements $MediaModelCopyWith<$Res> {
  _$MediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = freezed, Object? url = freezed}) {
    return _then(
      _value.copyWith(
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            url:
                freezed == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MediaModelImplCopyWith<$Res>
    implements $MediaModelCopyWith<$Res> {
  factory _$$MediaModelImplCopyWith(
    _$MediaModelImpl value,
    $Res Function(_$MediaModelImpl) then,
  ) = __$$MediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? type, String? url});
}

/// @nodoc
class __$$MediaModelImplCopyWithImpl<$Res>
    extends _$MediaModelCopyWithImpl<$Res, _$MediaModelImpl>
    implements _$$MediaModelImplCopyWith<$Res> {
  __$$MediaModelImplCopyWithImpl(
    _$MediaModelImpl _value,
    $Res Function(_$MediaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = freezed, Object? url = freezed}) {
    return _then(
      _$MediaModelImpl(
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        url:
            freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaModelImpl implements _MediaModel {
  const _$MediaModelImpl({this.type, this.url});

  factory _$MediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaModelImplFromJson(json);

  @override
  final String? type;
  @override
  final String? url;

  @override
  String toString() {
    return 'MediaModel(type: $type, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, url);

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaModelImplCopyWith<_$MediaModelImpl> get copyWith =>
      __$$MediaModelImplCopyWithImpl<_$MediaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaModelImplToJson(this);
  }
}

abstract class _MediaModel implements MediaModel {
  const factory _MediaModel({final String? type, final String? url}) =
      _$MediaModelImpl;

  factory _MediaModel.fromJson(Map<String, dynamic> json) =
      _$MediaModelImpl.fromJson;

  @override
  String? get type;
  @override
  String? get url;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaModelImplCopyWith<_$MediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubListModel _$SubListModelFromJson(Map<String, dynamic> json) {
  return _SubListModel.fromJson(json);
}

/// @nodoc
mixin _$SubListModel {
  int get id => throw _privateConstructorUsedError;
  String get taskName => throw _privateConstructorUsedError;
  String get remarks => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  String get statusLabel => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get video => throw _privateConstructorUsedError;
  List<MediaModel> get media => throw _privateConstructorUsedError;

  /// Serializes this SubListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubListModelCopyWith<SubListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubListModelCopyWith<$Res> {
  factory $SubListModelCopyWith(
    SubListModel value,
    $Res Function(SubListModel) then,
  ) = _$SubListModelCopyWithImpl<$Res, SubListModel>;
  @useResult
  $Res call({
    int id,
    String taskName,
    String remarks,
    int status,
    String statusLabel,
    String image,
    String video,
    List<MediaModel> media,
  });
}

/// @nodoc
class _$SubListModelCopyWithImpl<$Res, $Val extends SubListModel>
    implements $SubListModelCopyWith<$Res> {
  _$SubListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskName = null,
    Object? remarks = null,
    Object? status = null,
    Object? statusLabel = null,
    Object? image = null,
    Object? video = null,
    Object? media = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            taskName:
                null == taskName
                    ? _value.taskName
                    : taskName // ignore: cast_nullable_to_non_nullable
                        as String,
            remarks:
                null == remarks
                    ? _value.remarks
                    : remarks // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as int,
            statusLabel:
                null == statusLabel
                    ? _value.statusLabel
                    : statusLabel // ignore: cast_nullable_to_non_nullable
                        as String,
            image:
                null == image
                    ? _value.image
                    : image // ignore: cast_nullable_to_non_nullable
                        as String,
            video:
                null == video
                    ? _value.video
                    : video // ignore: cast_nullable_to_non_nullable
                        as String,
            media:
                null == media
                    ? _value.media
                    : media // ignore: cast_nullable_to_non_nullable
                        as List<MediaModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubListModelImplCopyWith<$Res>
    implements $SubListModelCopyWith<$Res> {
  factory _$$SubListModelImplCopyWith(
    _$SubListModelImpl value,
    $Res Function(_$SubListModelImpl) then,
  ) = __$$SubListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String taskName,
    String remarks,
    int status,
    String statusLabel,
    String image,
    String video,
    List<MediaModel> media,
  });
}

/// @nodoc
class __$$SubListModelImplCopyWithImpl<$Res>
    extends _$SubListModelCopyWithImpl<$Res, _$SubListModelImpl>
    implements _$$SubListModelImplCopyWith<$Res> {
  __$$SubListModelImplCopyWithImpl(
    _$SubListModelImpl _value,
    $Res Function(_$SubListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskName = null,
    Object? remarks = null,
    Object? status = null,
    Object? statusLabel = null,
    Object? image = null,
    Object? video = null,
    Object? media = null,
  }) {
    return _then(
      _$SubListModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        taskName:
            null == taskName
                ? _value.taskName
                : taskName // ignore: cast_nullable_to_non_nullable
                    as String,
        remarks:
            null == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as int,
        statusLabel:
            null == statusLabel
                ? _value.statusLabel
                : statusLabel // ignore: cast_nullable_to_non_nullable
                    as String,
        image:
            null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                    as String,
        video:
            null == video
                ? _value.video
                : video // ignore: cast_nullable_to_non_nullable
                    as String,
        media:
            null == media
                ? _value._media
                : media // ignore: cast_nullable_to_non_nullable
                    as List<MediaModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubListModelImpl implements _SubListModel {
  const _$SubListModelImpl({
    this.id = 0,
    this.taskName = '',
    this.remarks = '',
    this.status = 0,
    this.statusLabel = '',
    this.image = '',
    this.video = '',
    final List<MediaModel> media = const <MediaModel>[],
  }) : _media = media;

  factory _$SubListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubListModelImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String taskName;
  @override
  @JsonKey()
  final String remarks;
  @override
  @JsonKey()
  final int status;
  @override
  @JsonKey()
  final String statusLabel;
  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey()
  final String video;
  final List<MediaModel> _media;
  @override
  @JsonKey()
  List<MediaModel> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  String toString() {
    return 'SubListModel(id: $id, taskName: $taskName, remarks: $remarks, status: $status, statusLabel: $statusLabel, image: $image, video: $video, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubListModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskName, taskName) ||
                other.taskName == taskName) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.video, video) || other.video == video) &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    taskName,
    remarks,
    status,
    statusLabel,
    image,
    video,
    const DeepCollectionEquality().hash(_media),
  );

  /// Create a copy of SubListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubListModelImplCopyWith<_$SubListModelImpl> get copyWith =>
      __$$SubListModelImplCopyWithImpl<_$SubListModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubListModelImplToJson(this);
  }
}

abstract class _SubListModel implements SubListModel {
  const factory _SubListModel({
    final int id,
    final String taskName,
    final String remarks,
    final int status,
    final String statusLabel,
    final String image,
    final String video,
    final List<MediaModel> media,
  }) = _$SubListModelImpl;

  factory _SubListModel.fromJson(Map<String, dynamic> json) =
      _$SubListModelImpl.fromJson;

  @override
  int get id;
  @override
  String get taskName;
  @override
  String get remarks;
  @override
  int get status;
  @override
  String get statusLabel;
  @override
  String get image;
  @override
  String get video;
  @override
  List<MediaModel> get media;

  /// Create a copy of SubListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubListModelImplCopyWith<_$SubListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
