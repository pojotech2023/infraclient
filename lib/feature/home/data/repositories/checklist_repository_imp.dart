import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/respositories/checklist_repository.dart';
import '../datasources/checklist_remote_datasource.dart';
import '../models/checklist_model.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDataSource remoteDataSource;

  ChecklistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChecklistEntity>>> getChecklist({required int siteId}) async {
    try {

      final models = await remoteDataSource.getChecklist(siteId: siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
