import 'package:equatable/equatable.dart';
import '../../domain/entities/connection_status.dart';

abstract class ConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends ConnectionState {}
class ConnectionLoading extends ConnectionState {}
class ConnectionLoaded extends ConnectionState {
  final ConnectionStatus status;
  ConnectionLoaded(this.status);

  @override
  List<Object?> get props => [status];
}
class ConnectionError extends ConnectionState {
  final String message;
  ConnectionError(this.message);

  @override
  List<Object?> get props => [message];
}
