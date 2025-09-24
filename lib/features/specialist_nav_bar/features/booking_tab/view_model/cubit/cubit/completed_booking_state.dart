import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/booking_model.dart';

abstract class CompletedBookingState {}

class CompletedBookingInitial extends CompletedBookingState {}

class CompletedBookingLoading extends CompletedBookingState {}

class CompletedBookingSuccess extends CompletedBookingState {
  final List<Booking> bookings;

  CompletedBookingSuccess(this.bookings);
}

class CompletedBookingError extends CompletedBookingState {
  final String message;

  CompletedBookingError(this.message);
}
