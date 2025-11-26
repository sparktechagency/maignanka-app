import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';

// ✅ Background message handler (MUST be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔔 Background notification received: ${message.notification?.title}");
  // Ekhane background logic add korte paren if needed
}

class FirebaseNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Singleton pattern
  FirebaseNotificationService._privateConstructor();

  static final FirebaseNotificationService instance =
  FirebaseNotificationService._privateConstructor();

  /// **Initialize Firebase Notifications**
  static Future<void> initialize() async {
    try {
      // ✅ Register background message handler FIRST
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        sound: true,
        badge: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint("🚫 Notification permission denied");
        return;
      }

      debugPrint("✅ Notification permission: ${settings.authorizationStatus}");

      // Initialize local notifications
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint("📩 Notification tapped (foreground): ${response.payload}");
          // Handle notification tap here
        },
        onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
      );

      // Handle FCM messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        debugPrint("📩 App opened from notification: ${message.data}");
        // Handle notification tap navigation here
      });

      debugPrint("✅ Firebase Notifications initialized");
    } catch (e) {
      debugPrint("❌ Error initializing notifications: $e");
    }
  }

  /// ✅ Background notification tap handler
  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    debugPrint("📩 Background notification tapped: ${response.payload}");
    // Handle background notification tap
  }

  /// **Handle foreground FCM messages and show local notification**
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint("📩 Received foreground notification: ${message.notification?.title}");

    final notification = message.notification;
    final android = notification?.android;

    if (notification != null &&
        (android != null || defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'reservation_channel',
              'Gestion App',
              channelDescription: 'Reservation notifications',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              styleInformation: BigTextStyleInformation(
                notification.body ?? '',
                contentTitle: notification.title ?? '',
              ),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              interruptionLevel: InterruptionLevel.timeSensitive, // ✅ iOS 15+ support
            ),
          ),
          payload: message.data.toString(),
        );
      } catch (e) {
        debugPrint("❌ Error showing notification: $e");
      }
    }
  }

  /// **Retrieve FCM Token**
  static Future<String?> getFCMToken() async {
    try {
      // Request notification permissions first
      final settings = await _firebaseMessaging.getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        final newSettings = await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        if (newSettings.authorizationStatus == AuthorizationStatus.denied) {
          debugPrint("❌ User denied notification permission");
          return null;
        }
      }

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {

        // For iOS, wait for APNs token
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          String? apnsToken;
          int attempts = 0;
          const maxAttempts = 10;

          // Retry fetching APNs token for up to 5 seconds
          while (apnsToken == null && attempts < maxAttempts) {
            apnsToken = await _firebaseMessaging.getAPNSToken();
            if (apnsToken == null) {
              await Future.delayed(const Duration(milliseconds: 500));
              attempts++;
              debugPrint("⏳ Waiting for APNs token... Attempt $attempts/$maxAttempts");
            }
          }

          if (apnsToken == null) {
            debugPrint("🚫 APNs token not available after $maxAttempts attempts");
            // Continue anyway, FCM might still work
          } else {
            debugPrint("✅ APNs token: $apnsToken");
          }
        }

        // Get the FCM token
        final fcmToken = await _firebaseMessaging.getToken();

        if (fcmToken != null) {
          debugPrint("✅ FCM token: $fcmToken");
          return fcmToken;
        } else {
          debugPrint("⚠️ FCM token is null");
          return null;
        }
      }

      debugPrint("❌ Notification permission not granted");
      return null;
    } catch (e) {
      debugPrint("❌ Error getting FCM token: $e");
      return null;
    }
  }

  /// **Print FCM Token & Store it in Preferences**
  static Future<void> printFCMToken() async {
    try {
      String token = await PrefsHelper.getString(AppConstants.fcmToken);

      if (token.isNotEmpty) {
        debugPrint("🔑 FCM Token (Stored): $token");
      } else {
        token = await getFCMToken() ?? '';

        if (token.isNotEmpty) {
          await PrefsHelper.setString(AppConstants.fcmToken, token);
          debugPrint("🔑 FCM Token (New & Saved): $token");
        } else {
          debugPrint("⚠️ Could not retrieve FCM token");
        }
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint("🔄 FCM Token refreshed: $newToken");
        PrefsHelper.setString(AppConstants.fcmToken, newToken);
      });
    } catch (e) {
      debugPrint("❌ Error in printFCMToken: $e");
    }
  }
}