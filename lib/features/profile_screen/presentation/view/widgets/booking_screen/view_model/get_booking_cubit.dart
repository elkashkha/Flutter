import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';
part 'get_booking_state.dart';

class GetBookingCubit extends Cubit<GetBookingState> {
  GetBookingCubit() : super(GetBookingInitial());

  final Dio _dio = Dio();

  Future<void> getBookings() async {
    emit(GetBookingLoading());

    try {
      final token = await _getToken();

      if (token == null) {
        emit(const GetBookingError('الرجاء تسجيل الدخول'));
        return;
      }


      final response = await _dio.get(
        'https://api.alkashkhaa.com/public/api/bookings',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );



      if (response.data == null) {
        emit(const GetBookingError('البيانات المستلمة فارغة'));
        return;
      }


      if (response.data['data'] == null) {
        emit(const GetBookingError('لا توجد بيانات حجوزات'));
        return;
      }

      final List<dynamic> bookingsData = response.data['data'] as List;

      if (bookingsData.isEmpty) {
        emit(const GetBookingLoaded([]));
        return;
      }

      final List<Booking> bookings = bookingsData
          .map((json) => Booking.fromJson(json))
          .toList();

      emit(GetBookingLoaded(bookings));

    } on DioException catch (dioError) {

      String errorMessage;

      if (dioError.response != null) {
        final statusCode = dioError.response!.statusCode;


        switch (statusCode) {
          case 401:
            errorMessage = 'انتهت صلاحية الجلسة، الرجاء تسجيل الدخول مجددًا';
            break;
          case 403:
            errorMessage = 'ليس لديك صلاحية للوصول لهذه البيانات';
            break;
          case 404:
            errorMessage = 'الخدمة غير متاحة حالياً';
            break;
          case 500:
            errorMessage = 'خطأ في الخادم، الرجاء المحاولة لاحقاً';
            break;
          default:
            errorMessage = 'خطأ في الاتصال (كود: $statusCode)';
        }
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال، تحقق من الإنترنت';
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة استقبال البيانات';
      } else if (dioError.type == DioExceptionType.connectionError) {
        errorMessage = 'خطأ في الاتصال، تحقق من الإنترنت';
      } else {
        errorMessage = 'خطأ في الشبكة: ${dioError.message}';
      }

      emit(GetBookingError(errorMessage));

    } catch (e) {
      emit(GetBookingError('خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('access_token');
    } catch (e) {
      return null;
    }
  }
}