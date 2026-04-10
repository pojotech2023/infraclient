import 'package:freezed_annotation/freezed_annotation.dart';
import 'sublist_entity.dart';

part 'checklist_entity.freezed.dart';


@freezed
class ChecklistEntity with _$ChecklistEntity {
  const factory ChecklistEntity({
    required String stage,
    required List<SubListEntity> tasks,
  }) = _ChecklistEntity;
}

