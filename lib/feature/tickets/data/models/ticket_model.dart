import '../../domain/entities/ticket_entity.dart';

class TicketModel {
  final int id;
  final int siteId;
  final int customerId;
    final String senderType;
  final String ticket;
  final String createdAt;
  final String updatedAt;
  final String? filePath;

  TicketModel({
    required this.id,
    required this.siteId,
    required this.customerId,
    required this.senderType,
    required this.ticket,
    required this.createdAt,
    required this.updatedAt,
    this.filePath,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
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

    return TicketModel(
      id: asInt(json['id']),
      siteId: asInt(json['site_id']),
      customerId: asInt(json['customer_id']),
      senderType: asString(json['sender_type']),
      ticket: asString(json['ticket']),
      createdAt: asString(json['created_at']),
      updatedAt: asString(json['updated_at']),
      filePath: json['filePath'] == null ? null : asString(json['filePath']),
    );
  }

  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      siteId: siteId,
      senderType: senderType,
      customerId: customerId,
      ticket: ticket,
      createdAt: createdAt,
      updatedAt: updatedAt,
      filePath: filePath,
    );
  }
}
