import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ticket_entity.dart';

import '../../domain/respositories/ticket_repository.dart';
import '../datasources/ticket_remote_datasource.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remoteDataSource;

  TicketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TicketEntity>>> getTickets(int siteId) async {
    try {
      final models = await remoteDataSource.getTickets(siteId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> addTicket({required int siteId, required int customerId, required String ticket, String? attachmentPath}) async {
    try {
      await remoteDataSource.addTicket(siteId: siteId, customerId: customerId, ticket: ticket, attachmentPath: attachmentPath);
        
        print("API CALLING TOCKET RESPO IMPL-------------");
    
      return const Right(null);
    } catch (e) {
        print("API CALLING TOCKET RESPO IMPL-------------${e}");
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
