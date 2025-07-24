import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/notifications_repo.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo repo;

  NotificationsCubit(this.repo) : super(NotificationsInitial());

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = await repo.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError('فشل تحميل الإشعارات'));
    }
  }
  Future<void> deleteNotification(int id) async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await dio.delete(
        'https://api.alkashkhaa.com/public/api/notifications/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        await getNotifications();
      }
    } catch (e) {
      emit(NotificationsError('فشل في حذف الإشعار'));
    }
  }


  Future<void> markNotificationAsRead(int id) async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await dio.post(
        'https://api.alkashkhaa.com/public/api/mark-as-read/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        await getNotifications();
      }
    } catch (e) {
      emit(NotificationsError('فشل في تعليم الإشعار كمقروء'));
    }
  }
}
