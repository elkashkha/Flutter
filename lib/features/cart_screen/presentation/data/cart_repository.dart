import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';

class CartRepository {
  final Dio dio;

  CartRepository(this.dio);

  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await dio.post(
      'https://api.alkashkhaa.com/public/api/cart/add',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في الإضافة إلى السلة');
    }
  }
  Future<CartModel> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) throw Exception('Access token not found');

    final response = await dio.get(
        'https://api.alkashkhaa.com/public/api/cart',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(response.data['data']);
    } else {
      throw Exception('فشل في جلب بيانات العربة');
    }
  }


}
