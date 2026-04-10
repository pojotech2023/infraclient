import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class TicketMessageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTicketMessages extends TicketMessageEvent {
  final int ticketId;
  LoadTicketMessages({required this.ticketId});
  @override
  List<Object?> get props => [ticketId];
}

class SendMessage extends TicketMessageEvent {
    final String siteId;
  final String ticketId;
  final String senderType;
  final String message;
  final File? attachment;

  SendMessage({
    required this.siteId,
    required this.ticketId,
    required this.senderType,
    required this.message,
    this.attachment,
  });

  @override
  List<Object?> get props => [siteId,ticketId, message, attachment];
}
