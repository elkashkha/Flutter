import 'package:dio/dio.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/cubit/update_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateSpecialistProfileCubit extends Cubit<UpdateProfileState> {
  UpdateSpecialistProfileCubit() : super(UpdateProfileInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://apiv2.alkashkhaa.com/public/api/',
    contentType: 'multipart/form-data',
  ));

  Future<void> updateProfile({
    String? profilePicturePath,
    String? name, // بقت اختيارية
  }) async {
    emit(UpdateProfileLoading());

    try {
      final token = await _getToken();
      final userId = await _getUserId();

      if (token == null || userId == null) {
        emit(UpdateProfileError("❌ البيانات ناقصة، لا يمكن إكمال العملية"));
        return;
      }

      FormData formData = FormData();

      // إضافة الاسم لو موجود
      if (name != null && name.isNotEmpty) {
        formData.fields.add(MapEntry("name", name));
      }

      // إضافة الصورة لو موجودة
      if (profilePicturePath != null) {
        formData.files.add(MapEntry(
          "profile_picture",
          await MultipartFile.fromFile(profilePicturePath),
        ));
      }

      final response = await _dio.post(
        'specialists/update/profile/$userId',
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(UpdateProfileSuccess("✅ تم تحديث البروفايل بنجاح"));
      } else {
        emit(UpdateProfileError(
            response.data['message'] ?? "حدث خطأ أثناء التحديث"));
      }
    } on DioException catch (e) {
      emit(UpdateProfileError(_handleDioError(e)));
    } catch (e) {
      emit(UpdateProfileError("حدث خطأ غير متوقع: $e"));
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        return "غير مصرح لك.";
      } else if (e.response!.data != null &&
          e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    return "خطأ في الاتصال بالسيرفر.";
  }
}
