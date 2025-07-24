import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialization() async {
    if (Platform.isAndroid) {
      await _requestNotificationPermission();
    }

    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  /// إعداد الإشعارات المحلية (لازم عشان نعرض إشعار لما ييجي من FCM)
  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iOSInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationClick(response.payload);
      },
    );
  }


  static Future<void> _initFirebaseMessaging() async {

    String? fcmToken = await _firebaseMessaging.getToken();
    print("📲 FCM Token: $fcmToken");


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 Notification Clicked: ${message.data}");
    });


    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data.toString());
    }
  }

  static void _handleNotificationClick(String? payload) {
    if (payload != null) {
      print("📬 Notification clicked: $payload");
    }
  }


  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'Firebase Notifications',
      channelDescription: 'Channel for FCM',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "إشعار",
      message.notification?.body ?? "تفاصيل الإشعار",
      notificationDetails,
      payload: message.data.toString(),
    );

    await _saveNotification(message.notification?.body ?? '');
  }

  static Future<bool> _requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.notification.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      print("⚠️ الإذن مرفوض نهائيًا! افتح الإعدادات يدويًا.");
      await openAppSettings();
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
