abstract class BookingApi2State {}

class BookingApiInitial extends BookingApi2State {}

class BookingApiLoading extends BookingApi2State {}

class BookingApiSuccess extends BookingApi2State {}

class BookingApiError extends BookingApi2State {
  final String message;
  BookingApiError(this.message);
}
