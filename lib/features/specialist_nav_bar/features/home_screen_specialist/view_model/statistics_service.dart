import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'statistics_model.dart';

class StatisticsService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://apitest.alkashkhaa.com/public/api/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<StatisticsModel> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception("❌ التوكن غير موجود، لازم تعمل تسجيل دخول الأول");
    }

    final response = await dio.get(
      "specialists/statistics",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      return StatisticsModel.fromJson(response.data);
    } else {
      throw Exception("⚠️ فشل في جلب الإحصائيات: ${response.statusCode}");
    }
  }
}
