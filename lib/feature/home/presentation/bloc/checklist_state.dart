import 'package:equatable/equatable.dart';
import '../../domain/entities/checklist_entity.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();
  @override
  List<Object?> get props => [];
}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final List<ChecklistEntity> checklist;
  const ChecklistLoaded(this.checklist);
  @override
  List<Object?> get props => [checklist];
}

class ChecklistError extends ChecklistState {
  final String message;
  const ChecklistError(this.message);
  @override
  List<Object?> get props => [message];
}
