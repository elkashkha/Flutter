import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/booking_model.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/cubit/completed_booking_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedBookingCubit extends Cubit<CompletedBookingState> {
  CompletedBookingCubit() : super(CompletedBookingInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://apiv2.alkashkhaa.com/public/api/",
    contentType: "application/json",
  ));

  Future<void> fetchCompletedBookings() async {
    emit(CompletedBookingLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null) {
        emit(CompletedBookingError("التوكن غير موجود"));
        return;
      }

      final response = await _dio.get(
        "specialists/completed-bookings",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        final bookingResponse = BookingResponse.fromJson(response.data);
        emit(CompletedBookingSuccess(bookingResponse.data));
      } else {
        emit(CompletedBookingError("فشل تحميل البيانات"));
      }
    } catch (e) {
      emit(CompletedBookingError("خطأ: ${e.toString()}"));
    }
  }
}
