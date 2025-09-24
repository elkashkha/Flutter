class RepeatCustomer {
  final int id;
  final String name;
  final String email;
  final int bookingCount;

  RepeatCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.bookingCount,
  });

  factory RepeatCustomer.fromJson(Map<String, dynamic> json) {
    return RepeatCustomer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      bookingCount: json['booking_count'] ?? 0,
    );
  }
}

class StatisticsModel {
  final int currentMonthBookings;
  final Map<String, dynamic> sixMonthsBookings;
  final double repeatCustomersPercentage;
  final List<RepeatCustomer> repeatCustomers;

  StatisticsModel({
    required this.currentMonthBookings,
    required this.sixMonthsBookings,
    required this.repeatCustomersPercentage,
    required this.repeatCustomers,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      currentMonthBookings: json['statistics']['current_month_bookings'] ?? 0,
      sixMonthsBookings: Map<String, dynamic>.from(
          json['statistics']['six_months_bookings'] ?? {}),
      repeatCustomersPercentage:
          (json['statistics']['repeat_customers_percentage'] as num?)
                  ?.toDouble() ??
              0.0,
      repeatCustomers:
          (json['statistics']['repeat_customers'] as List<dynamic>? ?? [])
              .map((e) => RepeatCustomer.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
