// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaModelImpl _$$MediaModelImplFromJson(Map<String, dynamic> json) =>
    _$MediaModelImpl(
      type: json['type'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$MediaModelImplToJson(_$MediaModelImpl instance) =>
    <String, dynamic>{'type': instance.type, 'url': instance.url};

_$SubListModelImpl _$$SubListModelImplFromJson(Map<String, dynamic> json) =>
    _$SubListModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      taskName: json['taskName'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      status: (json['status'] as num?)?.toInt() ?? 0,
      statusLabel: json['statusLabel'] as String? ?? '',
      image: json['image'] as String? ?? '',
      video: json['video'] as String? ?? '',
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaModel>[],
    );

Map<String, dynamic> _$$SubListModelImplToJson(_$SubListModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskName': instance.taskName,
      'remarks': instance.remarks,
      'status': instance.status,
      'statusLabel': instance.statusLabel,
      'image': instance.image,
      'video': instance.video,
      'media': instance.media,
    };
