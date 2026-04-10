import 'package:equatable/equatable.dart';

class SubListEntity extends Equatable {
  final int id;
  final String taskName;
  final String remarks;
  final int status;
     final String statusLabel;
      final String image;
       final String video;
  final List<Map<String, String?>> media;

  const SubListEntity({
    required this.id,
    required this.taskName,
    required this.remarks,
    required this.media,
       required this.status,
          required this.statusLabel,
             required this.image,
                required this.video,

  });

  @override
  List<Object?> get props => [id, taskName, remarks, media];
}


