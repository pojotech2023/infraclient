import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/usecases/check_connection.dart';
import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final CheckConnection checkConnection;
  final Stream<ConnectionStatus> connectionStream;
  StreamSubscription? _subscription;

  ConnectionBloc(this.checkConnection, this.connectionStream)
      : super(ConnectionInitial()) {

    on<CheckConnectionEvent>((event, emit) async {
      emit(ConnectionLoading());
      try {
        final status = await checkConnection();
        emit(ConnectionLoaded(status));
      } catch (e) {
        emit(ConnectionError(e.toString()));
      }
    });

    _subscription = connectionStream.listen((status) {
      add(ConnectionStatusChangedEvent(status));
    });

    on<ConnectionStatusChangedEvent>((event, emit) {
      emit(ConnectionLoaded(event.status));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
