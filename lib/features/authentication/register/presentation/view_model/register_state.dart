abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

class OtpSendLoading extends RegisterState {}
class OtpSendSuccess extends RegisterState {}
class OtpSendFailure extends RegisterState {
  final String error;
  OtpSendFailure(this.error);
}
class OtpVerificationLoading extends RegisterState {}

class OtpVerificationSuccess extends RegisterState {}

class OtpVerificationFailure extends RegisterState {
  final String error;
  OtpVerificationFailure(this.error);
}
