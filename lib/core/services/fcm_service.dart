import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../config/flavor_config.dart';
import '../routes/app_router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('==================== FCM BACKGROUND MESSAGE ====================');
  print('Handling a background message: ${message.messageId}');
  print('================================================================');
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Local notifications for foreground display
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle foreground notification tap
        print('Foreground notification tapped: ${details.payload}');
        if (details.payload != null) {
          try {
            final data = jsonDecode(details.payload!);
            _handleNotificationTap(data);
          } catch (e) {
            print('Error parsing notification payload: $e');
          }
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Get the FCM token
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        _printToken(token);
        await saveTokenToServer(token);
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _printToken(newToken);
      saveTokenToServer(newToken);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        
        RemoteNotification notification = message.notification!;
        AndroidNotification? android = message.notification?.android;

        if (android != null) {
          _localNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                priority: Priority.high,
                importance: Importance.high,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    // Terminated state tap
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state via notification tap!');
      print('Data: ${initialMessage.data}');
      // Delay routing to ensure app has time to mount the router
      Future.delayed(const Duration(milliseconds: 1000), () {
        _handleNotificationTap(initialMessage.data);
      });
    }

    // Background state tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Data: ${message.data}');
      _handleNotificationTap(message.data);
    });
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    print('Handling notification routing for data: $data');
    if (data['type'] == 'checklist' || data['type'] == 'Checklist') {
      print('Navigating to Checklist tab (/dashboard)...');
      appRouter.router.go('/dashboard');
    }
  }

  void _printToken(String token) {
    print('\n==================== FCM TOKEN ====================');
    print('FCM Token:');
    print(token);
    print('==================================================\n');
  }

  Future<void> saveTokenToServer([String? token]) async {
    try {
      final box = await Hive.openBox('auth');
      final userStr = box.get('user');
      
      if (userStr == null) {
        print('User not logged in, cannot save FCM token yet.');
        return;
      }

      final Map<String, dynamic> userMap = json.decode(userStr);
      // Fallback to mobile_no or id if token is missing
      final String? authHeaderToken = userMap['token'] ?? userMap['mobile_no'] ?? userMap['id']?.toString();

      if (authHeaderToken == null) {
         print('No auth token available, cannot save FCM token.');
         return;
      }

      // If token not passed in, try to get it
      if (token == null) {
        token = await _firebaseMessaging.getToken();
        if (token == null) {
           print('Could not retrieve FCM token.');
           return;
        }
      }

      final String baseUrl = FlavorConfig.appConfig.baseUrl;
      
      print('--- API REQUEST: saveDeviceToken ---');
      print('URL: $baseUrl/save-device-token');
      
      final response = await http.post(
        Uri.parse('$baseUrl/save-device-token'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authHeaderToken',
        },
        body: json.encode({
          'token': token,
          'device_token': token,
          'fcm_token': token,
          'customer_id': userMap['id'],
        }),
      );

      print('--- API RESPONSE: saveDeviceToken ---');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ FCM token successfully saved to server.');
      } else {
        print('❌ Failed to save FCM token to server.');
      }
    } catch (e) {
      print('Error saving FCM token to server: $e');
    }
  }
}
