import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ticket_entity.dart';

abstract class TicketRepository {
  Future<Either<Failure, List<TicketEntity>>> getTickets(int siteId);
  Future<Either<Failure, void>> addTicket({required int siteId, required int customerId, required String ticket, String? attachmentPath});
}
