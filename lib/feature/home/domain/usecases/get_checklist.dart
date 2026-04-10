import 'package:dartz/dartz.dart';
import '../entities/checklist_entity.dart';
import '../respositories/checklist_repository.dart';
import '../../../../core/error/failures.dart';

class GetChecklist {
  final ChecklistRepository repository;

  GetChecklist(this.repository);

  Future<Either<Failure, List<ChecklistEntity>>> call({required int siteId}) {
    return repository.getChecklist(siteId: siteId);
  }
}
