import 'package:equatable/equatable.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();
  @override
  List<Object?> get props => [];
}

class FetchChecklistEvent extends ChecklistEvent {
  final int siteId;
  const FetchChecklistEvent(this.siteId);
  @override
  List<Object?> get props => [siteId];
}
