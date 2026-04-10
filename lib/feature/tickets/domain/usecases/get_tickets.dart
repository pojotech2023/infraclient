import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ticket_entity.dart';
import '../respositories/ticket_repository.dart';


class GetTickets {
  final TicketRepository repository;

  GetTickets(this.repository);

  Future<Either<Failure, List<TicketEntity>>> call(int siteId) async {
    return await repository.getTickets(siteId);
  }
}

class AddTicket {
  final TicketRepository repository;

  AddTicket(this.repository);

  Future<Either<Failure, void>> call({required int siteId, required int customerId, required String ticket, String? attachmentPath}) async {
    return await repository.addTicket(siteId: siteId, customerId: customerId, ticket: ticket, attachmentPath: attachmentPath);
  }
}