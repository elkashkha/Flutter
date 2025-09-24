import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/booking_model.dart';

abstract class ActiveBookingState {}

class ActiveBookingInitial extends ActiveBookingState {}

class ActiveBookingLoading extends ActiveBookingState {}

class ActiveBookingSuccess extends ActiveBookingState {
  final List<Booking> bookings;

  ActiveBookingSuccess(this.bookings);
}

class ActiveBookingError extends ActiveBookingState {
  final String message;

  ActiveBookingError(this.message);
}
