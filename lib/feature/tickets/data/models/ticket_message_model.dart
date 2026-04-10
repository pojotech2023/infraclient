import '../../domain/entities/ticket_message_entity.dart';

class TicketMessageModel {
  final int id;
  final int ticketId;
  final String senderType;
  final String? message;
  final String createdAt;
  final String updatedAt;
  final String? attachment;

  TicketMessageModel({
    required this.id,
    required this.ticketId,
    required this.senderType,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
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

    return TicketMessageModel(
      id: asInt(json['id']),
      ticketId: asInt(json['ticketId'] ?? json['ticket_id']),
      senderType: asString(json['senderType'] ?? json['sender_type']),
      message: json['message'] == null ? null : asString(json['message']),
      createdAt: asString(json['createdAt'] ?? json['created_at']),
      updatedAt: asString(json['updatedAt'] ?? json['updated_at']),
      attachment: json['attachment'] == null ? null : asString(json['attachment']),
    );
  }

  TicketMessageEntity toEntity() {
    return TicketMessageEntity(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
      attachment: attachment,
    );
  }
}
