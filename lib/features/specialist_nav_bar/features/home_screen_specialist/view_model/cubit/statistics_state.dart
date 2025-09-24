import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/flow_chart.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/statistics_model.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final List<ChartData> chartData;
  final double repeatCustomersPercentage;
  final List<RepeatCustomer> repeatCustomers;
  final int currentMonthBookings;

  StatisticsLoaded(
      {required this.chartData,
      required this.repeatCustomersPercentage,
      required this.repeatCustomers,
      required this.currentMonthBookings});

  get statistics => null;
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError({required this.message});
}
