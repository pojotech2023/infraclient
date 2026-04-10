class TicketEntity {
  final int id;
  final int siteId;
  final String senderType;
  final int customerId;
  final String ticket;
  final String createdAt;
  final String updatedAt;
  final String? filePath;

  TicketEntity({
    required this.id,
    required this.siteId,
      required this.senderType,
    required this.customerId,
    required this.ticket,
    required this.createdAt,
    required this.updatedAt,
    this.filePath,
  });
}
