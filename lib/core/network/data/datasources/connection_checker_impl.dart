import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../network.dart';

class ConnectionCheckerImpl {
  final Connectivity _connectivity;

  ConnectionCheckerImpl(this._connectivity);

  Stream<ConnectionStatus> get connectionStream async* {
    yield await checkConnection();
    await for (final results in _connectivity.onConnectivityChanged) {
      yield await _getConnectionStatus(results);
    }
  }

  Future<ConnectionStatus> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return _getConnectionStatus(results);
  }

  Future<ConnectionStatus> _getConnectionStatus(List<ConnectivityResult> results) async {
    // Get the primary connectivity result
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    if (result == ConnectivityResult.none) return ConnectionStatus.disconnected;

    // On Flutter Web, avoid dart:io DNS lookups (not supported/reliable).
    if (!kIsWeb) {
      try {
        final lookup = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));
        if (lookup.isEmpty || lookup[0].rawAddress.isEmpty) {
          return ConnectionStatus.disconnected;
        }
      } catch (_) {
        return ConnectionStatus.disconnected;
      }
    }

    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionStatus.connectedWifi;
      case ConnectivityResult.mobile:
        return ConnectionStatus.connectedMobile;
      case ConnectivityResult.ethernet:
        return ConnectionStatus.connectedEthernet;
      default:
        return ConnectionStatus.disconnected;
    }
  }
}
