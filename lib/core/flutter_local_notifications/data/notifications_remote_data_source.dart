import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> fetchNotifications({
    String endpoint = 'notifications',
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('No auth token found');

      final response = await dio.get(
        'https://apitest.alkashkhaa.com/public/api/$endpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // لو ال API بيرجع مباشرة List
        if (data is List) return List<Map<String, dynamic>>.from(data);

        // لو ال API بيرجع Map
        if (data is Map) {
          // حاول نلقى أي مفتاح يحتوي على List
          List<Map<String, dynamic>>? notifications;

          if (data['data'] is List) {
            notifications = List<Map<String, dynamic>>.from(data['data']);
          } else if (data['notifications'] is List) {
            notifications =
                List<Map<String, dynamic>>.from(data['notifications']);
          } else if (data['dat'] is List) {
            // المفتاح اللي عندك دلوقتي
            notifications = List<Map<String, dynamic>>.from(data['dat']);
          }

          if (notifications != null) return notifications;
        }

        // لو مفيش List متاحة
        return [];
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
