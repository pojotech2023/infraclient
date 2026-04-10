import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ticket_message_entity.dart';

abstract class TicketMessageRepository {
  Future<Either<Failure, List<TicketMessageEntity>>> getMessages(int ticketId);
   Future<Either<Failure, Unit>> sendMessage(String siteId,String ticketId,String senderType, String? message, File? attachment);
}
