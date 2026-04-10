import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/checklist_entity.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, List<ChecklistEntity>>> getChecklist({required int siteId});
}
