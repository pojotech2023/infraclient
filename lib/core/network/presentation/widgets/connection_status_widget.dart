import 'dart:async';
import 'package:builder_customer/core/network/domain/entities/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/connection_bloc.dart';
import 'package:builder_customer/core/network/presentation/bloc/connection_state.dart' as connection;

class ConnectionStatusWidget extends StatefulWidget {
  final Widget child;

  const ConnectionStatusWidget({super.key, required this.child});

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _showGreenBanner = false;
  String _connectedMessage = "";

  Timer? _timer;

  void _showTemporaryGreen(String msg) {
    _timer?.cancel();
    setState(() {
      _showGreenBanner = true;
      _connectedMessage = msg;
    });

    // Hide after 2 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showGreenBanner = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        BlocListener<ConnectionBloc, connection.ConnectionState>(
          listener: (context, state) {
            if (state is connection.ConnectionLoaded) {
              if (state.status.isConnected) {
                // Show green banner with message
                _showTemporaryGreen(state.status.description);
              }
            }
          },
          child: BlocBuilder<ConnectionBloc, connection.ConnectionState>(
            builder: (context, state) {
              if (state is connection.ConnectionLoaded &&
                  !state.status.isConnected) {
                // Red banner when offline
                return _buildBanner(
                  Colors.red,
                  Colors.red.shade800,
                  Icons.signal_cellular_connected_no_internet_0_bar_sharp,
                  state.status.description,
                );
              }

              if (_showGreenBanner) {
                // Green banner for 2 sec when online again
                return _buildBanner(
                  Colors.green,
                  Colors.green.shade800,
                  Icons.check_circle_rounded,
                  _connectedMessage,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(
      Color color1,
      Color color2,
      IconData icon,
      String text,
      ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.only(top: kTextTabBarHeight),
        height: kTextTabBarHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: [color1, color2]),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
