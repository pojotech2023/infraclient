// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChecklistModelImpl _$$ChecklistModelImplFromJson(Map<String, dynamic> json) =>
    _$ChecklistModelImpl(
      stage: json['stage'] as String,
      tasks:
          (json['tasks'] as List<dynamic>)
              .map((e) => SubListModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$ChecklistModelImplToJson(
  _$ChecklistModelImpl instance,
) => <String, dynamic>{'stage': instance.stage, 'tasks': instance.tasks};
