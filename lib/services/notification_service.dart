import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<void> init({bool requestPermission=false}) async {
    initializeTimeZones();
    setLocalLocation(getLocation('America/Toronto'));
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettings = InitializationSettings(android: androidSettings);
    await _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == "open_quote") {
          navigatorKey.currentState?.pushNamed('/quoteOfDay');
        }
      },
    );
    if(requestPermission){
      await _notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
  }

  Future<void> showQuoteNotification({
    required int id,
    required String quote,
    required String author,
  }) async {
    await _notificationPlugin.show(
      id,
      "🌞 Quote of the Day",
      '"$quote"\n— $author',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_quote_channel',
          'Daily Quotes',
          channelDescription: 'Daily quote notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_launcher_foreground',
            color: Color(0xFF764ba2),
        largeIcon: DrawableResourceAndroidBitmap('ic_launcher_foreground')
        ),
      ),
      payload: "open_quote",
    );
  }
}
