import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Timer? _timer;

  static Future<void> initialization() async {
    if (Platform.isAndroid) {
      bool granted = await _requestNotificationPermission();
      if (!granted) {
        print("❌ الإذن مرفوض، لن يتم إرسال الإشعارات");
        return;
      }
    }

    await localNotificationInitialization();
    scheduleMinutelyNotification();
  }

  static Future<void> localNotificationInitialization() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );
  }

  static void _handleNotificationClick(String? payload) {
    if (payload != null) {

      print("Notification clicked: $payload");
    }
  }


  static Future<void> scheduleMinutelyNotification() async {
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.cancelAll();
    _sendNotification();

    _timer = Timer.periodic(const Duration(minutes: 10080), (timer) {
      _sendNotification();
    });
  }

  static Future<void> _sendNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'minute_channel',
      'Minutely Notifications',
      channelDescription: 'Notification every minute',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    String notificationText = "📢 عروض جديدة متاحة الآن!";
    await _saveNotification(notificationText);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'عروض وخصومات',
      notificationText,
      now.add(const Duration(minutes  : 5)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<bool> _requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.notification.request();
      if (status.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      print("⚠️ الإذن مرفوض نهائيًا! يجب فتح الإعدادات يدويًا.");
      await openAppSettings();
      return false;
    }

    return false;
  }

  static Future<void> _saveNotification(String notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList("notifications") ?? [];
    notifications.insert(0, notification);
    await prefs.setStringList("notifications", notifications);
  }
}