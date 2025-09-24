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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFCFA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircularProgress(
                percentage: percentage,
                size: 120,
                strokeWidth: 20,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'العملاء المتكررين',
                      style: GoogleFonts.notoKufiArabic(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$customerCount عميل قاموا ب الحجز معك مجدداً هذا الشهر',
                      style: GoogleFonts.notoKufiArabic(
                        color: AppTheme.primary.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
