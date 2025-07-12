import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cart_model.dart';
import '../data/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;
  final Dio _dio = Dio();


  CartCubit(this.repository) : super(CartInitial());

  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {

    emit(CartLoading());
    try {
      await repository.addToCart(productId: productId, quantity: quantity);
      emit(CartSuccess('تمت الإضافة إلى السلة بنجاح'));
      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
  Future<void> checkout(BuildContext context) async {
    emit(CartLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(CartError('التوكن غير موجود'));
        return;
      }
      final response = await _dio.post(
        'https://api.alkashkhaa.com/public/api/cart/checkout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final invoiceUrl = response.data["sadad_response"]?["sadad_response"]?["InvoiceURL"];

        emit(CheckoutSuccess(invoiceUrl));
      } else {
        emit(CartError('فشل في إتمام الشراء: غير متوقع ${response.statusCode}'));
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'خطأ في السيرفر';
        print('Error Response: ${e.response?.data}');
        emit(CartError('فشل في إتمام الشراء: $errorMessage'));
      } else {
        emit(CartError('فشل في إتمام الشراء: $e'));
      }
    }
  }  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> getCart() async {
    emit(CartLoading());
    try {
      final cartData = await repository.getCart();
      emit(CartLoaded(cartData));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
  Future<void> deleteCartItem(int cartItemId) async {
    emit(CartLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(CartError('التوكن غير موجود'));
        return;
      }

      final response = await _dio.delete(
        'https://api.alkashkhaa.com/public/api/cart/item/$cartItemId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(CartSuccess('تم حذف العنصر من السلة بنجاح'));
        await getCart();
      } else {
        emit(CartError('فشل في حذف العنصر: ${response.statusCode}'));
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'خطأ في السيرفر';
        emit(CartError('فشل في حذف العنصر: $errorMessage'));
      } else {
        emit(CartError('فشل في حذف العنصر: $e'));
      }
    }
  }



}
