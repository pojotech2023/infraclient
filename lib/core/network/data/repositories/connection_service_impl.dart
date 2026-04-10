import '../../domain/entities/connection_status.dart';
import '../../domain/repositories/connection_service.dart';
import '../datasources/connection_checker_impl.dart';

class ConnectionServiceImpl implements ConnectionService {
  final ConnectionCheckerImpl _checker;

  ConnectionServiceImpl(this._checker);

  @override
  Stream<ConnectionStatus> get connectionStream => _checker.connectionStream;

  @override
  Future<ConnectionStatus> checkConnection() => _checker.checkConnection();
}
