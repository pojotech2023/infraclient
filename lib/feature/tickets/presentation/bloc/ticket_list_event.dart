import 'package:equatable/equatable.dart';

abstract class TicketListEvent extends Equatable {
  const TicketListEvent();
  @override
  List<Object?> get props => [];
}

class TicketListLoad extends TicketListEvent {
  final int siteId;
  const TicketListLoad({required this.siteId});
}
