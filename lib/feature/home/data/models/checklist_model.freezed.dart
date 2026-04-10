// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChecklistModel _$ChecklistModelFromJson(Map<String, dynamic> json) {
  return _ChecklistModel.fromJson(json);
}

/// @nodoc
mixin _$ChecklistModel {
  String get stage => throw _privateConstructorUsedError;
  List<SubListModel> get tasks => throw _privateConstructorUsedError;

  /// Serializes this ChecklistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistModelCopyWith<ChecklistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistModelCopyWith<$Res> {
  factory $ChecklistModelCopyWith(
    ChecklistModel value,
    $Res Function(ChecklistModel) then,
  ) = _$ChecklistModelCopyWithImpl<$Res, ChecklistModel>;
  @useResult
  $Res call({String stage, List<SubListModel> tasks});
}

/// @nodoc
class _$ChecklistModelCopyWithImpl<$Res, $Val extends ChecklistModel>
    implements $ChecklistModelCopyWith<$Res> {
  _$ChecklistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? stage = null, Object? tasks = null}) {
    return _then(
      _value.copyWith(
            stage:
                null == stage
                    ? _value.stage
                    : stage // ignore: cast_nullable_to_non_nullable
                        as String,
            tasks:
                null == tasks
                    ? _value.tasks
                    : tasks // ignore: cast_nullable_to_non_nullable
                        as List<SubListModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChecklistModelImplCopyWith<$Res>
    implements $ChecklistModelCopyWith<$Res> {
  factory _$$ChecklistModelImplCopyWith(
    _$ChecklistModelImpl value,
    $Res Function(_$ChecklistModelImpl) then,
  ) = __$$ChecklistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stage, List<SubListModel> tasks});
}

/// @nodoc
class __$$ChecklistModelImplCopyWithImpl<$Res>
    extends _$ChecklistModelCopyWithImpl<$Res, _$ChecklistModelImpl>
    implements _$$ChecklistModelImplCopyWith<$Res> {
  __$$ChecklistModelImplCopyWithImpl(
    _$ChecklistModelImpl _value,
    $Res Function(_$ChecklistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? stage = null, Object? tasks = null}) {
    return _then(
      _$ChecklistModelImpl(
        stage:
            null == stage
                ? _value.stage
                : stage // ignore: cast_nullable_to_non_nullable
                    as String,
        tasks:
            null == tasks
                ? _value._tasks
                : tasks // ignore: cast_nullable_to_non_nullable
                    as List<SubListModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistModelImpl implements _ChecklistModel {
  const _$ChecklistModelImpl({
    required this.stage,
    required final List<SubListModel> tasks,
  }) : _tasks = tasks;

  factory _$ChecklistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistModelImplFromJson(json);

  @override
  final String stage;
  final List<SubListModel> _tasks;
  @override
  List<SubListModel> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'ChecklistModel(stage: $stage, tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistModelImpl &&
            (identical(other.stage, stage) || other.stage == stage) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    stage,
    const DeepCollectionEquality().hash(_tasks),
  );

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistModelImplCopyWith<_$ChecklistModelImpl> get copyWith =>
      __$$ChecklistModelImplCopyWithImpl<_$ChecklistModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistModelImplToJson(this);
  }
}

abstract class _ChecklistModel implements ChecklistModel {
  const factory _ChecklistModel({
    required final String stage,
    required final List<SubListModel> tasks,
  }) = _$ChecklistModelImpl;

  factory _ChecklistModel.fromJson(Map<String, dynamic> json) =
      _$ChecklistModelImpl.fromJson;

  @override
  String get stage;
  @override
  List<SubListModel> get tasks;

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistModelImplCopyWith<_$ChecklistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
