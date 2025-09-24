import 'package:bloc/bloc.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view/widgets/flow_chart.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/statistics_model.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/home_screen_specialist/view_model/statistics_service.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsService service;

  StatisticsCubit(this.service) : super(StatisticsInitial());

  void fetchStatistics() async {
    emit(StatisticsLoading());
    try {
      final model = await service.getStatistics();
      final sortedKeys = model.sixMonthsBookings.keys.toList()..sort();
      final chartData = sortedKeys.map((key) {
        final monthNum = key.split('-')[1];
        final monthName = _getMonthName(monthNum);
        return ChartData(monthName, model.sixMonthsBookings[key].toDouble());
      }).toList();
      emit(StatisticsLoaded(
        chartData: chartData,
        repeatCustomersPercentage: model.repeatCustomersPercentage,
        repeatCustomers: model.repeatCustomers,
        currentMonthBookings: model.currentMonthBookings,
      ));
    } catch (e) {
      emit(StatisticsError(message: e.toString()));
    }
  }

  String _getMonthName(String monthNum) {
    const Map<String, String> monthNames = {
      '01': 'يناير',
      '02': 'فبراير',
      '03': 'مارس',
      '04': 'أبريل',
      '05': 'مايو',
      '06': 'يونيو',
      '07': 'يوليو',
      '08': 'أغسطس',
      '09': 'سبتمبر',
      '10': 'أكتوبر',
      '11': 'نوفمبر',
      '12': 'ديسمبر',
    };
    return monthNames[monthNum] ?? monthNum;
  }
}
