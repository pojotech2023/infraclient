import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sublist_entity.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Optional media model for structured attachments (image/video)
@freezed
class MediaModel with _$MediaModel {
  const factory MediaModel({
    String? type,
    String? url,
  }) = _MediaModel;

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);
}

/// Main SubList model
@freezed
class SubListModel with _$SubListModel {
  const factory SubListModel({
    @Default(0) int id,
    @Default('') String taskName,
    @Default('') String remarks,
    @Default(0) int status,
    @Default('') String statusLabel,
    @Default('') String image,
    @Default('') String video,
    @Default(<MediaModel>[]) List<MediaModel> media,
  }) = _SubListModel;

  factory SubListModel.fromJson(Map<String, dynamic> json) =>
      _$SubListModelFromJson(json);

  /// Safe constructor for inconsistent JSON keys
  factory SubListModel.fromMapSafe(Map<String, dynamic>? json) {
    final map = json ?? {};

    String _readString(List<String> keys) {
      for (final key in keys) {
        final value = map[key];
        if (value != null) return value.toString();
      }
      return '';
    }

    int _readInt(String key) {
      final value = map[key];
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    // Safe parse media list
    final mediaList = (map['media'] as List?)
            ?.whereType<Map>()
            .map((e) => MediaModel.fromJson(
                e.map((k, v) => MapEntry(k.toString(), v?.toString()))))
            .toList() ??
        [];

    return SubListModel(
      id: _readInt('id'),
      taskName: _readString(['taskName', 'task_name']),
      remarks: _readString(['remarks']),
      status: _readInt('status'),
      statusLabel: _readString(['statusLabel', 'status_label']),
      image: _readString(['image']),
      video: _readString(['video']),
      media: mediaList,
    );
  }
}

/// Convert model to entity (domain layer)
extension SubListModelX on SubListModel {
  SubListEntity toEntity() {
    return SubListEntity(
      id: id,
      taskName: taskName,
      remarks: remarks,
      media: media
          .map((m) => {'type': m.type, 'url': m.url})
          .toList(), // keep domain flexible
      status: status,
      statusLabel: statusLabel,
      image: image,
      video: video,
    );
  }
}
