import '../../domain/entities/ticket_message_entity.dart';

class TicketMessageModel {
  final int id;
  final int ticketId;
  final String senderType;
  final String? senderName;
  final String? message;
  final String createdAt;
  final String updatedAt;
  final String? attachment;
  final String? attachmentUrl;

  TicketMessageModel({
    required this.id,
    required this.ticketId,
    required this.senderType,
    this.senderName,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
    this.attachmentUrl,
  });

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
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

    final String type = asString(json['senderType'] ?? json['sender_type']);
    String name = asString(json['senderName'] ?? json['sender_name'] ?? json['name']);
    
    // Fallback to nested objects if the backend includes them
    if (name.isEmpty) {
      if (json['supervisor'] != null && json['supervisor']['name'] != null) {
        name = asString(json['supervisor']['name']);
      } else if (json['admin'] != null && json['admin']['name'] != null) {
        name = asString(json['admin']['name']);
      } else if (json['customer'] != null && json['customer']['name'] != null) {
        name = asString(json['customer']['name']);
      } else if (json['client'] != null && json['client']['name'] != null) {
        name = asString(json['client']['name']);
      } else if (json['user'] != null && json['user']['name'] != null) {
        name = asString(json['user']['name']);
      }
    }

    if (name.isEmpty) {
      name = type.isNotEmpty ? '${type[0].toUpperCase()}${type.substring(1)}' : 'Unknown';
    }

    return TicketMessageModel(
      id: asInt(json['id']),
      ticketId: asInt(json['ticketId'] ?? json['ticket_id']),
      senderType: type,
      senderName: name,
      message: json['message'] == null ? null : asString(json['message']),
      createdAt: asString(json['createdAt'] ?? json['created_at']),
      updatedAt: asString(json['updatedAt'] ?? json['updated_at']),
      attachment: json['attachment'] == null ? null : asString(json['attachment']),
      attachmentUrl: json['attachment_url'] == null ? null : asString(json['attachment_url']),
    );
  }

  TicketMessageEntity toEntity() {
    return TicketMessageEntity(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderName: senderName,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
      attachment: attachment,
      attachmentUrl: attachmentUrl,
    );
  }
}
