

import '../../domain/entities/drawing_entity.dart';

class DrawingModel {
  final int drawingId;
  final String drawingName;
  final String drawingViewUrl;
  final String drawingDownloadUrl;

  DrawingModel({
     required this.drawingId,
    required this.drawingName,
      required this.drawingViewUrl,
    required this.drawingDownloadUrl,
  });

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? 0;
      }
      return 0;
    }

    String asString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return DrawingModel(
      drawingId: asInt(json['drawing_id']),
      drawingName: asString(json['drawing_name']),
      drawingViewUrl: asString(json['drawing_view_url']),
      drawingDownloadUrl: asString(json['drawing_download_url']),
  
    );
  }

  DrawingEntity toEntity() {
    return DrawingEntity(
      drawingId: drawingId,
      drawingName: drawingName,
      drawingViewUrl: drawingViewUrl,
      drawingDownloadUrl: drawingDownloadUrl,
  
    );
  }
}
