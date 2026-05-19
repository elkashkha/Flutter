import 'package:dio/dio.dart';
import 'package:elkashkha/core/flutter_local_notifications/view_model/unread_notifications_cubit.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Decorative background circular elements for a high-end feel
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Icon(Icons.star, size: 6, color: Colors.grey[400]),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 14,
                        child: Icon(Icons.star, size: 8, color: Colors.grey[400]),
                      ),
                      SvgPicture.asset(
                        'assets/images/Notificationillustration.svg',
                        width: 42,
                        height: 42,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حجز جديد اليوم',
                        style: GoogleFonts.notoKufiArabic(
                          color: const Color(0xff0B0B0F),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/images/arrow_icon.svg',
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ],
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
