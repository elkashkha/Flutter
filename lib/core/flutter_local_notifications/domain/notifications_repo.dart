import 'package:elkashkha/core/flutter_local_notifications/data/notification_model.dart';
import 'package:elkashkha/core/flutter_local_notifications/data/notifications_remote_data_source.dart';
import 'package:elkashkha/core/flutter_local_notifications/data/specialist_notifications.dart';

abstract class NotificationsRepo {
  Future<List<dynamic>> getNotifications({String endpoint = 'notifications'});
}

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepoImpl(this.remoteDataSource);

  @override
  Future<List<dynamic>> getNotifications(
      {String endpoint = 'notifications'}) async {
    final data = await remoteDataSource.fetchNotifications(endpoint: endpoint);

    if (endpoint.startsWith('specialist')) {
      // Specialist
      return data
          .map((json) => SpecialistNotificationModel.fromJson(json))
          .toList();
    } else {
      // Normal user
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    }
  }
}
