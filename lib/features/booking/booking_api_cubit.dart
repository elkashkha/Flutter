import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_api_state.dart';

class BookingCubitApi extends Cubit<BookingApiState> {
  final Dio _dio = Dio();

  BookingCubitApi() : super(BookingInitial());

  Future<void> createBooking({
    required String bookingDate,
    required String bookingTime,
    required String name,
    required String email,
    required String phone,
    int? teamId,
    List<int>? services,
    List<int>? packages,
    List<int>? offers,
  }) async {
    emit(BookingLoading());

    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception("المستخدم غير مسجل.");
      }

      final requestData = {
        if (teamId != null) "specialist_id": teamId,
        "booking_date": bookingDate,
        "booking_time": bookingTime,
        "name": name,
        "email": email,
        "phone": phone,
        if (services != null && services.isNotEmpty) "service": services,
        if (packages != null && packages.isNotEmpty) "packages": packages,
        if (offers != null && offers.isNotEmpty) "offers": offers,
      };

      print("📤 Booking Data Before Sending: $requestData");

      final response = await _dio.post(
        'https://apitest.alkashkhaa.com/public/api/bookings',
        data: requestData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      print("📥 Booking Response Status: ${response.statusCode}");
      print("📥 Booking Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final paymentUrl = response.data['payment_url'] as String?;

        if (paymentUrl == null || paymentUrl.isEmpty) {
          emit(BookingFailure("❌ لم يتم استلام رابط الدفع من السيرفر."));
          return;
        }

        emit(BookingSuccess(paymentUrl));
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
