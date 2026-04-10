import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ticket_message_entity.dart';
import '../respositories/ticket_message_repository.dart';

class SendTicketMessage {
  final TicketMessageRepository repository;

  SendTicketMessage(this.repository);

  Future<Either<Failure, Unit>> call(
    String siteId,
    String ticketId,
    String senderType,
    String message,
    File? attachment,
  ) {
    return repository.sendMessage(siteId,ticketId,senderType, message, attachment);
  }
}
