import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.alkashkhaa.com/public/api/',
    contentType: 'application/json',
  ));

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      Response response = await _dio.post(
        'user/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        String token = response.data['access_token'];
        int userId = response.data['user']['id'];
        await _saveAuthData(token, userId);
        emit(LoginSuccess(token, userId));
      } else {
        emit(LoginFailure("فشل تسجيل الدخول، تحقق من البيانات."));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 403) {
        // التحقق من رسالة البريد غير المفعل
        if (e.response!.data != null &&
            e.response!.data['message'] == "Email not verified. OTP sent to email for verification.") {
          emit(OtpRequired(email));
        } else {
          emit(LoginFailure(_handleDioError(e)));
        }
      } else {
        emit(LoginFailure(_handleDioError(e)));
      }
    }
  }

  // Future<void> deleteUser(BuildContext context) async {
  //   emit(LoginLoading());
  //   try {
  //     String? token = await getToken();
  //     if (token == null) throw Exception("المستخدم غير مسجل.");
  //
  //     Response response = await _dio.delete(
  //       'user/delete',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       await _clearAuthData();
  //       context.goNamed('login');
  //       emit(LoginSuccess("", 0));
  //     } else {
  //       emit(LoginFailure("فشل في حذف المستخدم."));
  //     }
  //   } on DioException catch (e) {
  //     emit(LoginFailure(_handleDioError(e)));
  //   }
  // }
  Future<void> deleteUser(BuildContext context) async {
    emit(LoginLoading());

    try {
      int? userId = await getUserId();

      if (userId == null) {
        emit(LoginFailure("المستخدم غير مسجل."));
        return;
      }

      String url = 'user/$userId';

      Response response = await _dio.delete(url); // بدون Authorization headers

      if (response.statusCode == 200) {
        await _clearAuthData();
        if (context.mounted) {
          context.go('/LoginScreenView'); // التنقل بعد الحذف
        }
      } else {
        emit(LoginFailure("فشل في حذف المستخدم."));
      }

    } on DioException catch (e) {
      emit(LoginFailure(_handleDioError(e)));
    } catch (e) {
      emit(LoginFailure("حدث خطأ غير متوقع."));
    }
  }


  Future<void> _saveAuthData(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setInt('user_id', userId);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_id');
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
      } else if (e.response!.data != null && e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    return "خطأ في الاتصال بالسيرفر.";
  }
}
