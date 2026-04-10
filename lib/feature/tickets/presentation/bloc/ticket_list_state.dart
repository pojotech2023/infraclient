import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket_entity.dart';

abstract class TicketListState extends Equatable {
  const TicketListState();
  @override
  List<Object?> get props => [];
}

class TicketListInitial extends TicketListState {}
class TicketListLoading extends TicketListState {}
class TicketListLoaded extends TicketListState {
  final List<TicketEntity> tickets;
  const TicketListLoaded({required this.tickets});
  @override
  List<Object?> get props => [tickets];
}
class TicketListError extends TicketListState {
  final String message;
  const TicketListError({required this.message});
  @override
  List<Object?> get props => [message];
}
