import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking_state.dart';
import 'model.dart';

class BookingApi extends Cubit<BookingApi2State> {
  BookingApi() : super(BookingApiInitial());

  Future<void> makeBooking(BookingRequestModel bookingRequest) async {
    emit(BookingApiLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(BookingApiError('⚠️ لا يوجد توكن، سجل الدخول الأول.'));
        return;
      }

      final response = await Dio().post(
        'https://api.alkashkhaa.com/public/api/bookings',
        data: bookingRequest.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(BookingApiSuccess());
      } else {
        emit(BookingApiError('فشل الحجز، حاول مره اخري.'));
      }
    } catch (e) {
      emit(BookingApiError(e.toString()));
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
}
