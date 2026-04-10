import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/checklist_entity.dart';
import 'task_model.dart';

part 'checklist_model.freezed.dart';
part 'checklist_model.g.dart';

@freezed
class ChecklistModel with _$ChecklistModel {
  const factory ChecklistModel({
    required String stage,
    required List<SubListModel> tasks,
  }) = _ChecklistModel;

  factory ChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistModelFromJson(json);
}

extension ChecklistModelX on ChecklistModel {
  ChecklistEntity toEntity() {
    return ChecklistEntity(
      stage: stage,
      tasks: tasks.map((e) => e.toEntity()).toList(),
    );
  }
}

// SubListModel moved to task_model.dart

extension ChecklistModelFromMapSafe on ChecklistModel {
  static ChecklistModel fromMapSafe(Map<String, dynamic>? json) {
    final Map<String, dynamic> map = json ?? const {};
    final String stage = (map['stage'] as String?) ?? '';

    final List<SubListModel> tasks = (map['tasks'] as List?)
            ?.map((e) => SubListModel.fromMapSafe(e as Map<String, dynamic>?))
            .toList()
        ?? <SubListModel>[];

    return ChecklistModel(stage: stage, tasks: tasks);
  }
}

