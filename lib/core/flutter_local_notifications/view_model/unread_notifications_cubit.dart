import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'unread_notifications_state.dart';

class UnreadNotificationsCubit extends Cubit<UnreadNotificationsState> {
  final Dio dio;

  UnreadNotificationsCubit(this.dio) : super(UnreadNotificationsInitial());
  Future<void> getUnreadCount() async {
    emit(UnreadNotificationsLoading());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final type = prefs.getString('user_type');

    try {
      final endpoint = (type == 'specialist')
          ? 'https://apitest.alkashkhaa.com/public/api/specialist/notifications/unread-count'
          : 'https://api.alkashkhaa.com/public/api/notifications/unread-count';

      final response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final count = response.data['count'] ?? 0;
        emit(UnreadNotificationsLoaded(count));
      } else {
        emit(UnreadNotificationsError('فشل تحميل عدد الإشعارات'));
      }
    } catch (e) {
      emit(UnreadNotificationsError('حدث خطأ ما'));
    }
  }
}
