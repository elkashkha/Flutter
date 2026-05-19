import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view/widgets/active_booking_screen.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/specialist_header.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/statistics_screen.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/unread_notifications.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar_specialist.dart';
import '../widgets/circel_pross_customer.dart';

class HomeScreenSpecialist extends StatelessWidget {
  const HomeScreenSpecialist({super.key});

  @override
  Widget build(BuildContext context) {
    final specialistCubit = context.read<SpecialistCubit>();
    if (specialistCubit.state is SpecialistInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        specialistCubit.fetchProfile();
      });
    }

    return BlocBuilder<SpecialistCubit, SpecialistState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppBarSpecialist(
                title: 'لوحه التحكم',
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: SpecialistHeaderBlocWidget(),
              ),
              const UnreadNotificationWidget(),

              // Upcoming Bookings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_left, color: Colors.black, size: 24),
                    Text(
                      'الحجوزات القادمة',
                      style: GoogleFonts.notoKufiArabic(
                        color: const Color(0xff0B0B0F),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ActiveBookingScreen(isNested: true),
              ),

              // Chart Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: StatisticsChart(),
              ),

              // Circular Progress Customer Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: CircelProssCustomer(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
