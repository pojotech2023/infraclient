import 'package:flutter_bloc/flutter_bloc.dart';
import 'checklist_event.dart';
import 'checklist_state.dart';
import '../../domain/usecases/get_checklist.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GetChecklist getChecklistUseCase;

  ChecklistBloc({required this.getChecklistUseCase}) : super(ChecklistInitial()) {
    on<FetchChecklistEvent>((event, emit) async {
      emit(ChecklistLoading());
      final result = await getChecklistUseCase(siteId: event.siteId);
      result.fold(
            (failure) => emit(ChecklistError(failure.message)),
            (checklist) => emit(ChecklistLoaded(checklist)),
      );
    });
  }
}
