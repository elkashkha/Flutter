abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  final int userId;

  LoginSuccess(this.token, this.userId);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

// حالات الـ OTP في تسجيل الدخول
class OtpSendLoading extends LoginState {}
class OtpSendSuccess extends LoginState {}
class OtpSendFailure extends LoginState {
  final String error;
  OtpSendFailure(this.error);
}

class OtpVerificationLoading extends LoginState {}

class OtpVerificationSuccess extends LoginState {}
class OtpRequired extends LoginState {
  final String email;
  OtpRequired(this.email);
}
class OtpVerificationFailure extends LoginState {
  final String error;
  OtpVerificationFailure(this.error);

}
