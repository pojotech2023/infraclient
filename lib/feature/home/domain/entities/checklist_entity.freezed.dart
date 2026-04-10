// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChecklistEntity {
  String get stage => throw _privateConstructorUsedError;
  List<SubListEntity> get tasks => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistEntityCopyWith<ChecklistEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistEntityCopyWith<$Res> {
  factory $ChecklistEntityCopyWith(
    ChecklistEntity value,
    $Res Function(ChecklistEntity) then,
  ) = _$ChecklistEntityCopyWithImpl<$Res, ChecklistEntity>;
  @useResult
  $Res call({String stage, List<SubListEntity> tasks});
}

/// @nodoc
class _$ChecklistEntityCopyWithImpl<$Res, $Val extends ChecklistEntity>
    implements $ChecklistEntityCopyWith<$Res> {
  _$ChecklistEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistEntity
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
                        as List<SubListEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChecklistEntityImplCopyWith<$Res>
    implements $ChecklistEntityCopyWith<$Res> {
  factory _$$ChecklistEntityImplCopyWith(
    _$ChecklistEntityImpl value,
    $Res Function(_$ChecklistEntityImpl) then,
  ) = __$$ChecklistEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stage, List<SubListEntity> tasks});
}

/// @nodoc
class __$$ChecklistEntityImplCopyWithImpl<$Res>
    extends _$ChecklistEntityCopyWithImpl<$Res, _$ChecklistEntityImpl>
    implements _$$ChecklistEntityImplCopyWith<$Res> {
  __$$ChecklistEntityImplCopyWithImpl(
    _$ChecklistEntityImpl _value,
    $Res Function(_$ChecklistEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChecklistEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? stage = null, Object? tasks = null}) {
    return _then(
      _$ChecklistEntityImpl(
        stage:
            null == stage
                ? _value.stage
                : stage // ignore: cast_nullable_to_non_nullable
                    as String,
        tasks:
            null == tasks
                ? _value._tasks
                : tasks // ignore: cast_nullable_to_non_nullable
                    as List<SubListEntity>,
      ),
    );
  }
}

/// @nodoc

class _$ChecklistEntityImpl implements _ChecklistEntity {
  const _$ChecklistEntityImpl({
    required this.stage,
    required final List<SubListEntity> tasks,
  }) : _tasks = tasks;

  @override
  final String stage;
  final List<SubListEntity> _tasks;
  @override
  List<SubListEntity> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'ChecklistEntity(stage: $stage, tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistEntityImpl &&
            (identical(other.stage, stage) || other.stage == stage) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    stage,
    const DeepCollectionEquality().hash(_tasks),
  );

  /// Create a copy of ChecklistEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistEntityImplCopyWith<_$ChecklistEntityImpl> get copyWith =>
      __$$ChecklistEntityImplCopyWithImpl<_$ChecklistEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _ChecklistEntity implements ChecklistEntity {
  const factory _ChecklistEntity({
    required final String stage,
    required final List<SubListEntity> tasks,
  }) = _$ChecklistEntityImpl;

  @override
  String get stage;
  @override
  List<SubListEntity> get tasks;

  /// Create a copy of ChecklistEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistEntityImplCopyWith<_$ChecklistEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
