import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ticket_message_entity.dart';
import '../respositories/ticket_message_repository.dart';

class GetTicketMessages {
  final TicketMessageRepository repository;

  GetTicketMessages(this.repository);

  Future<Either<Failure, List<TicketMessageEntity>>> call(int ticketId) {
    return repository.getMessages(ticketId);
  }
}
