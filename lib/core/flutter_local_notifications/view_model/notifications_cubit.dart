import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elkashkha/core/flutter_local_notifications/data/notification_model.dart';
import 'package:elkashkha/core/flutter_local_notifications/data/specialist_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/notifications_repo.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo repo;

  NotificationsCubit(this.repo) : super(NotificationsInitial());

  Future<String?> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_type');
  }

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    try {
      final userType = await _getUserType();
      if (userType == null) {
        emit(NotificationsError('نوع المستخدم غير معروف'));
        return;
      }

      final endpoint = (userType == 'specialist')
          ? 'specialist/notifications'
          : 'my-notifications';

      final response = await repo.getNotifications(endpoint: endpoint);
      print('📩 Notifications Response: $response');

      if (userType == 'specialist') {
        emit(SpecialistNotificationsLoaded(
            response.cast<SpecialistNotificationModel>()));
      } else {
        emit(NotificationsLoaded(response.cast<NotificationModel>()));
      }
    } on DioException catch (dioError) {
      print('❌ Dio Error: ${dioError.response?.data}');
      emit(NotificationsError('فشل تحميل الإشعارات: ${dioError.message}'));
    } catch (e) {
      print('❌ Unexpected Error: $e');
      emit(NotificationsError('فشل تحميل الإشعارات: $e'));
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final userType = await _getUserType();
      if (userType == null) {
        emit(NotificationsError('نوع المستخدم غير معروف.'));
        return;
      }

      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // حدد الـ endpoint بناءً على الـ type
      final endpoint = (userType == 'specialist')
          ? 'specialist/notifications/$id'
          : 'notifications/$id';

      final response = await dio.delete(
        'https://apiv2.alkashkhaa.com/public/api/$endpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      print('🟢 Mark Read Response: ${response.data}');

      if (response.statusCode == 200) {
        await getNotifications(); // Refresh the list
      }
    } catch (e) {
      emit(NotificationsError('فشل في حذف الإشعار'));
    }
  }

  Future<void> markNotificationAsRead(int id) async {
    try {
      final userType = await _getUserType();
      if (userType == null) {
        emit(NotificationsError('نوع المستخدم غير معروف.'));
        return;
      }

      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final endpoint = (userType == 'specialist')
          ? 'specialist/notifications/$id/read'
          : 'mark-as-read/$id';

      final response = await dio.post(
        'https://apiv2.alkashkhaa.com/public/api/$endpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        await getNotifications(); // Refresh the list
      }
    } catch (e) {
      emit(NotificationsError('فشل في تعليم الإشعار كمقروء'));
    }
  }
}
