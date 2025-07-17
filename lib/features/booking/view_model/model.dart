class BookingRequestModel {
  final int teamId;
  final String bookingDate;
  final String bookingTime;
  final String name;
  final String email;
  final String phone;
  final List<int> services;
  final List<int> packages;
  final List<int> offers;

  BookingRequestModel({
    required this.teamId,
    required this.bookingDate,
    required this.bookingTime,
    required this.name,
    required this.email,
    required this.phone,
    required this.services,
    required this.packages,
    required this.offers,
  });

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'name': name,
      'email': email,
      'phone': phone,
      'services': services,
      'packages': packages,
      'offers': offers,
    };
  }
}
