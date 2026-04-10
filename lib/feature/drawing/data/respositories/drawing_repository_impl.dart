import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/drawing_entity.dart';
import '../../domain/respositories/drawing_repositories.dart';
import '../datasources/drawing_remote_datasource.dart';


class DrawingRepositoryImpl implements DrawingRepository {
  final DrawingRemoteDatasource remoteDataSource;

  DrawingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DrawingEntity>>> getDrawing(int siteId) async {
    try {
      final models = await remoteDataSource.fetchDrawing(siteId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
  
 


}
