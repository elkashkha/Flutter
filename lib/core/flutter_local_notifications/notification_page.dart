import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList("notifications") ?? [];
    });
  }

  Future<void> clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("notifications");
    setState(() {
      notifications.clear();
    });
  }

  Future<void> removeNotification(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications.removeAt(index);
    await prefs.setStringList("notifications", notifications);
    setState(() {});
  }

  Future<void> addNotification(String notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications.add(notification);
    await prefs.setStringList("notifications", notifications);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Text(
          locale.notifications,
          style: const TextStyle(color: AppTheme.primary),
        ),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: clearNotifications,
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: SvgPicture.asset(
                'assets/images/undraw_fresh-notification_hnv2 (1) 1.svg',
                width: 233,
                height: 191,
                fit: BoxFit.cover,
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(notifications[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      removeNotification(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تم مسح الإشعار")),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
