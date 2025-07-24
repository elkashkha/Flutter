import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'unread_notifications_state.dart';

class UnreadNotificationsCubit extends Cubit<UnreadNotificationsState> {
  final Dio dio;

  UnreadNotificationsCubit(this.dio) : super(UnreadNotificationsInitial());

  Future<void> getUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    try {
      final response = await dio.get(
        'https://api.alkashkhaa.com/public/api/notifications/unread-count',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final count = response.data['unread_count'] ?? 0;
        emit(UnreadNotificationsLoaded(count));
      } else {
        emit(UnreadNotificationsError('فشل تحميل عدد الإشعارات'));
      }
    } catch (e) {
      emit(UnreadNotificationsError('حدث خطأ ما'));
    }
  }

  void resetCount() {
    emit(UnreadNotificationsLoaded(0));
  }
}
