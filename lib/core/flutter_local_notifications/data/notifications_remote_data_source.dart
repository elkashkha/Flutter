import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_model.dart';

class NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSource(this.dio);

  Future<List<NotificationModel>> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await dio.get(
      'https://api.alkashkhaa.com/public/api/my-notifications',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );

    final data = response.data['dat'] as List;

    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }
}
