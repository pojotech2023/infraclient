import '../entities/connection_status.dart';
import '../repositories/connection_service.dart';

class CheckConnection {
  final ConnectionService service;

  CheckConnection(this.service);

  Future<ConnectionStatus> call() => service.checkConnection();
}
