import 'package:equatable/equatable.dart';
import '../../domain/entities/connection_status.dart';

abstract class ConnectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckConnectionEvent extends ConnectionEvent {}

class ConnectionStatusChangedEvent extends ConnectionEvent {
  final ConnectionStatus status;
  
  ConnectionStatusChangedEvent(this.status);
  
  @override
  List<Object?> get props => [status];
}
