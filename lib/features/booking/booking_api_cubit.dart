import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_api_state.dart';

class BookingCubitApi extends Cubit<BookingApiState> {
  final Dio _dio = Dio();

  BookingCubitApi() : super(BookingInitial());

  Future<void> createBooking({
    required String phone,
    required String email,
    required String name,
    required String currency,
    required String amount,
  }) async {
    emit(BookingLoading());
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception("المستخدم غير مسجل.");
      }

      final requestData = {
        "phone": phone,
        "email": email,
        "name": name,
        "currency": currency,
        "amount": amount,
      };

      print("📤 Booking Data Before Sending: $requestData");

      final response = await _dio.post(
        'https://api.alkashkhaa.com/public/api/sadad/create-invoice',
        data: requestData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      print("📥 Booking Response Status: ${response.statusCode}");
      print("📥 Booking Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final invoiceUrl = data["sadad_response"]?["sadad_response"]?["InvoiceURL"];
        emit(BookingSuccess(data, invoiceUrl));
      } else {
        print("❌ Booking failed with status: ${response.statusCode}");
        throw Exception("❌ فشل في إنشاء الحجز.");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.response?.data ?? e.message}");
      final errorMessage = _handleDioError(e);
      final statusCode = e.response?.statusCode;
      emit(BookingFailure(errorMessage, statusCode: statusCode));
    } catch (e) {
      print("❌ General Error: ${e.toString()}");
      emit(BookingFailure("❌ حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('access_token');
    } catch (e) {
      print("❌ Error fetching token: $e");
      return null;
    }
  }

  Future<int?> _getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
    } catch (e) {
      print("❌ Error fetching user ID: $e");
      return null;
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final message = e.response!.data?['message'] ?? "❌ حدث خطأ غير معروف.";
      return message;
    }
    return "❌ خطأ في الاتصال بالسيرفر.";
  }
}