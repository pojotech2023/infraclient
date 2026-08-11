class TicketMessageEntity {
  final int id;
  final int ticketId;
  final String senderType;
  final String? senderName;
  final String? message;
  final String createdAt;
  final String updatedAt;
  final String? attachment;
  final String? attachmentUrl;

  TicketMessageEntity({
    required this.id,
    required this.ticketId,
    required this.senderType,
    this.senderName,
    this.message,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
    this.attachmentUrl,
  });
}
