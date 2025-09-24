import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://apitest.alkashkhaa.com/public/api/',
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
        String type = response.data['type'];

        await _saveAuthData(token, userId, type);
        emit(LoginSuccess(token, userId, type));

        await sendFcmTokenToServer();
      } else {
        emit(LoginFailure("فشل تسجيل الدخول، تحقق من البيانات."));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 403) {
        if (e.response!.data != null &&
            e.response!.data['message'] ==
                "Email not verified. OTP sent to email for verification.") {
          emit(OtpRequired(email));
        } else {
          emit(LoginFailure(_handleDioError(e)));
        }
      } else {
        emit(LoginFailure(_handleDioError(e)));
      }
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    emit(LoginLoading());

    try {
      int? userId = await getUserId();

      if (userId == null) {
        emit(LoginFailure("المستخدم غير مسجل."));
        return;
      }

      String url = 'user/$userId';

      Response response = await _dio.delete(url);

      if (response.statusCode == 200) {
        await _clearAuthData();
        if (context.mounted) {
          context.go('/LoginScreenView');
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

  Future<void> sendFcmTokenToServer() async {
    try {
      final String? token = await getToken();
      final String? type = await getType();

      final int? userId = await getUserId();

      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (token == null || userId == null || fcmToken == null) {
        print("❌ البيانات ناقصة، مش هينفع نكمل إرسال التوكن");
        return;
      }

      final response = await Dio().post(
        'https://apitest.alkashkhaa.com/public/api/notifications/save-token',
        data: {
          "fcm_token": fcmToken,
          "type": type,
          "id": userId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        print("✅ تم إرسال FCM Token بنجاح");
      } else {
        print("⚠️ فشل إرسال FCM Token: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 خطأ أثناء إرسال FCM Token: $e");
    }
  }

  Future<void> _saveAuthData(String token, int userId, String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setInt('user_id', userId);
    await prefs.setString('user_type', type);
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
    await prefs.remove('user_type');
  }

  Future<String?> getType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_type');
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
      } else if (e.response!.data != null &&
          e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    return "خطأ في الاتصال بالسيرفر.";
  }
}
