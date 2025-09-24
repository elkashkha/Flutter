import 'package:elkashkha/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarSpecialist extends StatelessWidget {
  final String title;
  const AppBarSpecialist({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 28,
            //   backgroundImage: const AssetImage(
            //       'assets/images/undraw_agree_g19h (2) 1.png'),
            // ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                color: AppTheme.white,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            PopupMenuButton<int>(
              icon: const Icon(
                Icons.menu,
                color: AppTheme.white,
              ),
              color: Colors.black87, // لون الباكجراوند للقائمة
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                if (value == 0) {
                  context.push('/BookingSpecialistScreen');
                } else if (value == 1) {
                  context.push('/PortfolioScreen');
                } else if (value == 2) {
                  context.push('/NotificationsScreen');
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.folder, color: Colors.white),
                      SizedBox(width: 10),
                      Text("الحجوزات", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.image, color: Colors.white),
                      SizedBox(width: 10),
                      Text("معرض الاعمال",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.white),
                      SizedBox(width: 10),
                      Text("الاشعارات", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
