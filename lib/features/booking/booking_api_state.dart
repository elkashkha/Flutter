abstract class BookingApiState {}

class BookingInitial extends BookingApiState {}

class BookingLoading extends BookingApiState {}

class BookingSuccess extends BookingApiState {
  final Map<String, dynamic> data;
  final String InvoiceURL;

  BookingSuccess(this.data, this.InvoiceURL);
}

class BookingFailure extends BookingApiState {
  final String message;
  final int? statusCode;
  BookingFailure(this.message, {this.statusCode});
}