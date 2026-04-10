import 'package:equatable/equatable.dart';

import '../../../domain/entities/ticket_message_entity.dart';

abstract class TicketMessageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TicketMessageInitial extends TicketMessageState {}
class TicketMessageLoading extends TicketMessageState {}
class TicketMessageSending extends TicketMessageState {}
class TicketMessageLoaded extends TicketMessageState {
  final List<TicketMessageEntity> messages;

  TicketMessageLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}
class TicketMessageError extends TicketMessageState {
  final String message;

  TicketMessageError({required this.message});

  @override
  List<Object?> get props => [message];
}
