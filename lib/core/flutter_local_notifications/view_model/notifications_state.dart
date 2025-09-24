import 'package:elkashkha/core/flutter_local_notifications/data/specialist_notifications.dart';

import '../data/notification_model.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class SpecialistNotificationsLoaded extends NotificationsState {
  final List<SpecialistNotificationModel> notifications;

  SpecialistNotificationsLoaded(this.notifications);
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded(this.notifications);
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}
