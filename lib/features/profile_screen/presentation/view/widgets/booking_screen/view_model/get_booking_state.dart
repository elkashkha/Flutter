part of 'get_booking_cubit.dart';

abstract class GetBookingState extends Equatable {
  const GetBookingState();

  @override
  List<Object?> get props => [];
}

class GetBookingInitial extends GetBookingState {}

class GetBookingLoading extends GetBookingState {}

class GetBookingLoaded extends GetBookingState {
  final List<Booking> bookings;

  const GetBookingLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class GetBookingError extends GetBookingState {
  final String message;

  const GetBookingError(this.message);

  @override
  List<Object?> get props => [message];
}
