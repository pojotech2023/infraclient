import '../entities/connection_status.dart';

abstract class ConnectionService {
  Future<ConnectionStatus> checkConnection();
  Stream<ConnectionStatus> get connectionStream;
}
