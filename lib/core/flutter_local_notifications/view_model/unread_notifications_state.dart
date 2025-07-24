part of 'unread_notifications_cubit.dart';

abstract class UnreadNotificationsState {}

class UnreadNotificationsInitial extends UnreadNotificationsState {}

class UnreadNotificationsLoaded extends UnreadNotificationsState {
  final int count;
  UnreadNotificationsLoaded(this.count);
}

class UnreadNotificationsError extends UnreadNotificationsState {
  final String message;
  UnreadNotificationsError(this.message);
}
