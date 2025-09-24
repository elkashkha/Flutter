import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/flow_chart.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/cubit/statistics_cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/cubit/statistics_state.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/statistics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsChart extends StatelessWidget {
  const StatisticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(StatisticsService())..fetchStatistics(),
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is StatisticsLoaded) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xfff0f0f0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        'عدد الحجوزات لهذا الشهر : ${state.currentMonthBookings} حجز',
                        style: GoogleFonts.notoKufiArabic(
                            color: AppTheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.list_alt,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: WavyChart(data: state.chartData),
                ),
              ],
            );
          } else if (state is StatisticsError) {
            return Center(child: Text("❌ ${state.message}"));
          }
          return const Center(child: Text("اضغط لتحديث البيانات"));
        },
      ),
    );
  }
}
