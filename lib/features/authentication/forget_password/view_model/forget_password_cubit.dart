import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  final Dio _dio = Dio();


  Future<void> sendResetCode(String email) async {
    emit(ForgetPasswordLoading());
    try {
      var response = await _dio.post(
        'https://api.alkashkhaa.com/public/api/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        emit(ForgetPasswordCodeSent());
      } else {
        emit(ForgetPasswordError('فشل في إرسال الكود'));
      }
    } catch (e) {
      emit(ForgetPasswordError('⚠️ خطأ أثناء الإرسال: $e'));
    }
  }


  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    emit(ForgetPasswordLoading());
    try {
      var response = await _dio.post(
        'https://api.alkashkhaa.com/public/api/reset-password',
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        emit(ForgetPasswordSuccess());
      } else {
        emit(ForgetPasswordError('فشل في تغيير كلمة المرور'));
      }
    } catch (e) {
      emit(ForgetPasswordError('⚠️ خطأ أثناء تغيير كلمة المرور: $e'));
    }
  }
}
