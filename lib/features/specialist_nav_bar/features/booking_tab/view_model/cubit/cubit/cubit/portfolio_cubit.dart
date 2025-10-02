import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/cubit/completed_booking_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit() : super(PortfolioInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://apiv2.alkashkhaa.com/public/api/",
    contentType: "application/json",
  ));

  Future<void> addPortfolio({
    required int bookingId,
    required String nameAr,
    required String nameEn,
    required String descAr,
    int? productsSold,
    int? extraServicesUsed,
    required String descEn,
    required int serviceId,
    String? beforeImage,
    String? afterImage,
  }) async {
    emit(PortfolioLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null) {
        emit(PortfolioError("التوكن غير موجود"));
        return;
      }

      final formData = FormData.fromMap({
        "name_ar": nameAr,
        "name_en": nameEn,
        "description_ar": descAr,
        "description_en": descEn,
        "service_id": serviceId,
        if (productsSold != null) "products_sold": productsSold,
        if (extraServicesUsed != null) "extra_services_used": extraServicesUsed,
        if (beforeImage != null)
          "before_image": await MultipartFile.fromFile(beforeImage),
        if (afterImage != null)
          "after_image": await MultipartFile.fromFile(afterImage),
      });

      final response = await _dio.post(
        "specialists/bookings/$bookingId/portfolio",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 201) {
        emit(PortfolioSuccess());
        await CompletedBookingCubit().fetchCompletedBookings();
      } else {
        emit(PortfolioError("فشل في إضافة البورتفوليو"));
      }
    } catch (e) {
      emit(PortfolioError("خطأ: ${e.toString()}"));
    }
  }
}
