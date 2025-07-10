import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_state.dart';
import 'user_model.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.alkashkhaa.com/public/api/',
    contentType: 'application/json',
  ));

  Future<void> fetchUserProfile() async {
    emit(UserLoading());
    try {
      String? token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(UserNotLoggedIn());
        return;
      }

      Response response = await _dio.get(
        'user/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        UserModel user = UserModel.fromJson(response.data);
        emit(UserLoaded(user));
      } else {
        emit(UserFailure("فشل في جلب بيانات المستخدم."));
      }
    } catch (e) {
      emit(UserFailure("انتهت صلاحيه تسجيل الدخول "));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? profilePicture,
  }) async {
    emit(UserLoading());
    try {
      String? token = await _getToken();
      if (token == null) {
        emit(UserFailure("المستخدم غير مسجل."));
        return;
      }

      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        if (profilePicture != null)
          "profile_picture": await MultipartFile.fromFile(profilePicture, filename: "profile.jpg"),
      });

      Response response = await _dio.post(
        'user/update-profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: formData,
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        UserModel user = UserModel.fromJson({"data": response.data['user']});

        emit(UserUpdated());
        emit(UserLoaded(user));
      } else {
        emit(UserFailure("فشل في تحديث البيانات."));
      }
    } on DioException catch (e) {
      emit(UserFailure(_handleDioError(e)));
    } catch (e) {
      emit(UserFailure("انتهت صلاحيه تسجيل الدخول "));
    }
  }






  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }


  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        return "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجددًا.";
      } else if (e.response!.data != null && e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    return "خطأ في الاتصال بالسيرفر.";
  }
}
