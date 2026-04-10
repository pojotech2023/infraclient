enum ConnectionStatus {
  connectedWifi,
  connectedMobile,
  connectedEthernet,
  disconnected,
}

extension ConnectionStatusExtension on ConnectionStatus {
  String get description {
    switch (this) {
      case ConnectionStatus.connectedWifi:
        return 'Connected via Wi-Fi';
      case ConnectionStatus.connectedMobile:
        return 'Connected via Mobile Data';
      case ConnectionStatus.connectedEthernet:
        return 'Connected via Ethernet';
      case ConnectionStatus.disconnected:
        return 'No Internet';
    }
  }

  bool get isConnected => this != ConnectionStatus.disconnected;
}
