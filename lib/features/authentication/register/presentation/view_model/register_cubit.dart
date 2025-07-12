import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/authentication/register/presentation/view_model/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final Dio _dio = Dio();
  String? registeredEmail;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      emit(RegisterLoading());

      Response response = await _dio.post(
        'https://api.alkashkhaa.com/public/api/user/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "phone": phoneNumber,
        },
      );

      if (response.statusCode == 201) {
        registeredEmail = email;
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure("حدث خطأ أثناء التسجيل."));
      }
    } on DioException catch (e) {

      String errorMessage = _handleDioError(e);
      emit(RegisterFailure(errorMessage));
    } catch (e) {
      emit(RegisterFailure("خطأ غير متوقع: ${e.toString()}"));
    }
  }

  Future<void> verifyOtp({required String email, required String otpCode}) async {
    try {
      emit(OtpVerificationLoading());

      Response response = await _dio.post(
        'https://api.alkashkhaa.com/public/api/verify-otp',
        data: {
          "email": email,
          "otp": otpCode,
        },
      );

      if (response.statusCode == 200) {
        emit(OtpVerificationSuccess());
      } else {
        emit(OtpVerificationFailure("كود التحقق غير صحيح."));
      }
    } on DioException catch (e) {
      emit(OtpVerificationFailure(_handleDioError(e)));
    } catch (e) {
      emit(OtpVerificationFailure("خطأ في التحقق: ${e.toString()}"));
    }
  }

  Future<void> sendOtp({required String email}) async {
    try {
      emit(OtpSendLoading());

      Response response = await _dio.post(
        'https://elk.ahdafweb.com/public/api/send-otp',
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        emit(OtpSendSuccess());
      } else {
        emit(OtpSendFailure("فشل إرسال الكود. حاول مرة أخرى."));
      }
    } on DioException catch (e) {
      emit(OtpSendFailure(_handleDioError(e)));
    } catch (e) {
      emit(OtpSendFailure("خطأ في إرسال الكود: ${e.toString()}"));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response!.statusCode == 400) {
        return e.response!.data['message'] ?? "بيانات غير صحيحة.";
      } else if (e.response!.statusCode == 422) {
        return "هذا البريد الإلكتروني أو رقم الهاتف مستخدم بالفعل.";
      } else if (e.response!.statusCode == 500) {
        return "خطأ داخلي في السيرفر، حاول لاحقًا.";
      }
    }
    return "خطأ في الاتصال بالسيرفر، تحقق من الإنترنت.";
  }
}
