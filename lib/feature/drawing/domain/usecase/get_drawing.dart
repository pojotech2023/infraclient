
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/drawing_entity.dart';
import '../respositories/drawing_repositories.dart';

class GetDrawing{
  final DrawingRepository repository;

  GetDrawing(this.repository);

  Future<Either<Failure, List<DrawingEntity>>> call(int siteId) async {
    return await repository.getDrawing(siteId);
  }
}
