import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class GiftService {
  final Dio dio;

  GiftService(this.dio);

  Future<PlatinumGiftResponse> getPlatinumGift() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) throw Exception('Access token not found');

    final response = await dio.get(
      'https://api.alkashkhaa.com/public/api/platinum-gift/latest',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return PlatinumGiftResponse.fromJson(response.data);
  }
}