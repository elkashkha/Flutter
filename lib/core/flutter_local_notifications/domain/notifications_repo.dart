
import '../data/notification_model.dart';
import '../data/notifications_remote_data_source.dart';

abstract class NotificationsRepo {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepoImpl(this.remoteDataSource);

  @override
  Future<List<NotificationModel>> getNotifications() {
    return remoteDataSource.fetchNotifications();
  }
}
