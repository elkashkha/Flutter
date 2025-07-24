abstract class BookingApiState {}

class BookingInitial extends BookingApiState {}

class BookingLoading extends BookingApiState {}

class BookingSuccess extends BookingApiState {
  final String paymentUrl;

  BookingSuccess( this.paymentUrl);
}

class BookingFailure extends BookingApiState {
  final String message;
  final int? statusCode;
  BookingFailure(this.message, {this.statusCode});
}