part of 'unread_notifications_cubit.dart';

abstract class UnreadNotificationsState {}

class UnreadNotificationsInitial extends UnreadNotificationsState {}

class UnreadNotificationsLoading
    extends UnreadNotificationsState {} // 👈 ضيف دي

class UnreadNotificationsLoaded extends UnreadNotificationsState {
  final int count;
  UnreadNotificationsLoaded(this.count);
}

class UnreadNotificationsError extends UnreadNotificationsState {
  final String message;
  UnreadNotificationsError(this.message);
}
