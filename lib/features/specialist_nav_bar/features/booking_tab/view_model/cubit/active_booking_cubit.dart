import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/booking_model.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/active_booking_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveBookingCubit extends Cubit<ActiveBookingState> {
  ActiveBookingCubit() : super(ActiveBookingInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://apitest.alkashkhaa.com/public/api/",
    contentType: "application/json",
  ));

  Future<void> fetchActiveBookings() async {
    emit(ActiveBookingLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null) {
        emit(ActiveBookingError("التوكن غير موجود"));
        return;
      }

      final response = await _dio.get(
        "specialists/active-bookings",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        final bookingResponse = BookingResponse.fromJson(response.data);
        emit(ActiveBookingSuccess(bookingResponse.data));
      } else {
        emit(ActiveBookingError("فشل تحميل البيانات"));
      }
    } catch (e) {
      emit(ActiveBookingError("خطأ: ${e.toString()}"));
    }
  }

  Future<void> manageBooking(int bookingId, String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null) {
        emit(ActiveBookingError("التوكن غير موجود"));
        return;
      }

      final response = await _dio.post(
        "specialists/bookings/$bookingId/manage",
        data: {"action": action},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        print("✅ العملية نجحت: ${response.data}");
        await fetchActiveBookings();
      } else {
        emit(ActiveBookingError("فشل في تنفيذ العملية"));
      }
    } catch (e) {
      emit(ActiveBookingError("خطأ: ${e.toString()}"));
    }
  }

  Future<void> acceptBooking(int bookingId) async {
    await manageBooking(bookingId, "confirm");
  }

  Future<void> rejectBooking(int bookingId) async {
    await manageBooking(bookingId, "cancel");
  }
}
