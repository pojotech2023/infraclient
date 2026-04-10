class TicketMessageEntity {
  final int id;
  final int ticketId;
  final String senderType;
  final String? message;
  final String createdAt;
  final String updatedAt;
  final String? attachment;

  TicketMessageEntity({
    required this.id,
    required this.ticketId,
    required this.senderType,
    this.message,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
  });
}
