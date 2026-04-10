
import 'package:builder_customer/feature/drawing/domain/entities/drawing_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


abstract class DrawingRepository {
  Future<Either<Failure, List<DrawingEntity>>> getDrawing(int siteId);
}
