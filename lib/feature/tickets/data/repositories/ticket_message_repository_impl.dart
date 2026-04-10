import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ticket_message_entity.dart';
import '../../domain/respositories/ticket_message_repository.dart';
import '../datasources/ticket_message_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ticket_message_entity.dart';
import '../../domain/respositories/ticket_message_repository.dart';
import '../datasources/ticket_message_remote_datasource.dart';

class TicketMessageRepositoryImpl implements TicketMessageRepository {
  final TicketMessageRemoteDataSource remoteDataSource;

  TicketMessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TicketMessageEntity>>> getMessages(int ticketId) async {
    try {
      final models = await remoteDataSource.getTicketMessages(ticketId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e, stack) {
      print("❌ [getMessages] Error: $e\n$stack");
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> sendMessage(String siteId, String ticketId, String senderType, String? message, File? attachment)  async {
    print("📤  Sending Message at Repo Impl =>  siteId : $siteId  |  TicketID: $ticketId | Message: $message   |  sender : $senderType"  );
    try {
      await remoteDataSource.sendTicketMessage(
        siteId: siteId,
        ticketId: ticketId,
        senderType: senderType,
        message: message ?? '',
        attachment: attachment,
      );
      return const Right(unit);
    } catch (e, stack) {
      print("❌ [sendMessage] Error: $e\n$stack");
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }



}
