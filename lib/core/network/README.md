# Internet Connection Checker

A robust singleton implementation for monitoring internet connectivity in Flutter applications.

## Features

- **Singleton Pattern**: Ensures only one instance throughout the app lifecycle
- **Real-time Monitoring**: Continuously monitors connection status changes
- **Dual Verification**: Checks both device connectivity and actual internet reachability
- **BLoC Integration**: Seamless state management with flutter_bloc
- **UI Components**: Ready-to-use widgets for displaying connection status
- **Error Handling**: Comprehensive error handling and logging
- **Configurable**: Customizable hosts and check intervals

## Usage

### 1. Initialize in your main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/network.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the connection checker
  await InternetConnectionChecker.instance.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectionBloc()..add(ConnectionStarted()),
        ),
        // ... other BLoCs
      ],
      child: MaterialApp(
        home: ConnectionStatusWidget(
          child: MyHomePage(),
        ),
      ),
    );
  }
}
```

### 2. Listen to Connection Changes

```dart
import 'core/network/network.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription<InternetConnectionStatus> _connectionSubscription;

  @override
  void initState() {
    super.initState();
    
    // Listen to connection changes
    _connectionSubscription = InternetConnectionChecker.instance
        .connectionStream
        .listen((status) {
      if (status.isDisconnected) {
        // Handle disconnection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection lost!')),
        );
      } else if (status.isConnected) {
        // Handle reconnection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected!')),
        );
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
```

### 3. Check Connection Before API Calls

```dart
Future<void> makeApiCall() async {
  final hasConnection = await InternetConnectionChecker.instance.hasInternetConnection;
  
  if (!hasConnection) {
    throw Exception('No internet connection available');
  }
  
  // Proceed with API call
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  // Handle response...
}
```

### 4. Use BLoC for State Management

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [
          ConnectionIndicator(showText: true),
        ],
      ),
      body: BlocBuilder<ConnectionBloc, ConnectionState>(
        builder: (context, state) {
          if (state is ConnectionDisconnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('No Internet Connection'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConnectionBloc>().add(ConnectionCheckRequested());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          return YourMainContent();
        },
      ),
    );
  }
}
```

### 5. Force Connection Check

```dart
// Force a connection check
final isConnected = await InternetConnectionChecker.instance.forceCheck();

// Or using BLoC
context.read<ConnectionBloc>().add(ConnectionCheckRequested());
```

## Configuration

The connection checker uses these default settings:

- **Check Interval**: 30 seconds
- **Timeout Duration**: 10 seconds
- **Default Hosts**: google.com, cloudflare.com, 1.1.1.1, 8.8.8.8

You can customize these by modifying the constants in `InternetConnectionChecker`.

## Best Practices

1. **Initialize Early**: Initialize the connection checker in your app's main function
2. **Use BLoC**: Leverage the provided BLoC for consistent state management
3. **Handle Errors**: Always handle connection errors gracefully
4. **Show Status**: Use the provided widgets to keep users informed
5. **Retry Logic**: Implement retry mechanisms for failed operations
6. **Dispose Properly**: Always dispose of subscriptions and resources

## Error Handling

The connection checker includes comprehensive error handling:

- Network timeouts
- DNS resolution failures
- Platform-specific connectivity issues
- Resource cleanup on disposal

All errors are logged using Flutter's `debugPrint` for debugging purposes.
