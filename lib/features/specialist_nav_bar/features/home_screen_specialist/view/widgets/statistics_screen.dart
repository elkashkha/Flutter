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
            // Find highest bookings month dynamically from the loaded backend data
            ChartData? highestMonth;
            if (state.chartData.isNotEmpty) {
              highestMonth = state.chartData.reduce((a, b) => a.value > b.value ? a : b);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'عدد الحجوزات اخر 6 شهور',
                    style: GoogleFonts.notoKufiArabic(
                      color: const Color(0xff0B0B0F),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                // Chart
                SizedBox(
                  height: 180,
                  child: WavyChart(data: state.chartData),
                ),
                const SizedBox(height: 12),
                // Dynamically fetched highest month detail
                if (highestMonth != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${highestMonth.month} : ${highestMonth.value.toInt()} حجز',
                      style: GoogleFonts.notoKufiArabic(
                        color: const Color(0xff0B0B0F),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
