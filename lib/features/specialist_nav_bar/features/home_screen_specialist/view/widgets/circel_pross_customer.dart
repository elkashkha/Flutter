import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/cubit/statistics_cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/cubit/statistics_state.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/statistics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/app_theme.dart';
import 'circel_pross.dart';

class CircelProssCustomer extends StatelessWidget {
  const CircelProssCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatisticsCubit(StatisticsService())..fetchStatistics(),
      child: const _CircelProssCustomerBody(),
    );
  }
}

class _CircelProssCustomerBody extends StatelessWidget {
  const _CircelProssCustomerBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        double percentage = 0;
        int customerCount = 0;

        if (state is StatisticsLoaded) {
          percentage = state.repeatCustomersPercentage;
          customerCount = state.repeatCustomers.length;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgress(
                percentage: percentage,
                size: 90,
                strokeWidth: 10,
                progressColor: const Color(0xff0B0B0F),
                backgroundColor: const Color(0xffE2E2E6),
                textStyle: GoogleFonts.notoKufiArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0B0B0F),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$customerCount عميل حجزوا معاك مرة اخرى',
                style: GoogleFonts.notoKufiArabic(
                  color: const Color(0xff0B0B0F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
