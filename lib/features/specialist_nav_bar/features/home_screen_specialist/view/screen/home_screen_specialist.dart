import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view/widgets/active_booking_screen.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/specialist_header.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/statistics_screen.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/unread_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bar_specialist.dart';
import '../widgets/circel_pross_customer.dart';

class HomeScreenSpecialist extends StatelessWidget {
  const HomeScreenSpecialist({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarSpecialist(
            title: 'لوحه التحكم',
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child: SpecialistHeaderBlocWidget(),
          ),
          UnreadNotificationWidget(),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: StatisticsChart(),
          ),
          Padding(padding: EdgeInsets.all(8.0), child: CircelProssCustomer()),
          ActiveBookingScreen(isNested: true)
          // SizedBox(height: 250, child: PortfolioScreen()),
        ],
      ),
    );
  }
}
