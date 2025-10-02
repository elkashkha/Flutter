import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__state.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'specialist_model.dart';

class SpecialistCubit extends Cubit<SpecialistState> {
  SpecialistCubit() : super(SpecialistInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://apiv2.alkashkhaa.com/public/api/',
    contentType: 'application/json',
  ));

  Future<void> fetchProfile() async {
    emit(SpecialistLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        emit(SpecialistFailure("التوكن مش موجود"));
        return;
      }

      final response = await _dio.get(
        'specialists/profile',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['specialist'];
        final profile = SpecialistProfile.fromJson(data);
        emit(SpecialistLoaded(profile));
      } else {
        emit(SpecialistFailure("فشل تحميل البيانات"));
      }
    } on DioException catch (e) {
      emit(SpecialistFailure(_handleDioError(e)));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response!.data != null) {
      return e.response!.data['message'] ?? "خطأ في السيرفر";
    }
    return "فشل الاتصال بالسيرفر";
  }
}
