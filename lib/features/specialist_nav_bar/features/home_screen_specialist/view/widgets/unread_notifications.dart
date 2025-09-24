import 'package:dio/dio.dart';
import 'package:elkashkha/core/flutter_local_notifications/view_model/unread_notifications_cubit.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UnreadNotificationWidget extends StatelessWidget {
  const UnreadNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnreadNotificationsCubit(Dio())..getUnreadCount(),
      child: BlocBuilder<UnreadNotificationsCubit, UnreadNotificationsState>(
        builder: (context, state) {
          if (state is UnreadNotificationsLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is UnreadNotificationsLoaded) {
            if (state.count == 0) {
              return const SizedBox(); // لو مفيش إشعارات مش هنظهر حاجة
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 344,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xfffaf6f1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active_outlined,
                        color: Color(0xffC9A36C),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'لديك ${state.count} إشعار جديد اليوم',
                        style: GoogleFonts.notoKufiArabic(
                          color: const Color(0xffC9A36C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is UnreadNotificationsError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
