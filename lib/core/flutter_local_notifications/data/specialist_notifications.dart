class SpecialistNotificationModel {
  final int id;
  final int specialistId;
  final int? bookingId;
  final String title;
  final String body;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
  final NotificationDetails? details;

  SpecialistNotificationModel({
    required this.id,
    required this.specialistId,
    this.bookingId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.details,
  });

  factory SpecialistNotificationModel.fromJson(Map<String, dynamic> json) {
    return SpecialistNotificationModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      specialistId: int.tryParse(json['specialist_id']?.toString() ?? '') ?? 0,
      bookingId: int.tryParse(json['booking_id']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      details: json['details'] != null
          ? NotificationDetails.fromJson(json['details'])
          : null,
    );
  }
}

class NotificationDetails {
  final int bookingId;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String date;
  final String time;
  final List<Map<String, String>> services;
  final List<Map<String, String>> packages;
  final List<Map<String, String>> offers;
  final num totalPrice;
  final String status;

  NotificationDetails({
    required this.bookingId,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.date,
    required this.time,
    required this.services,
    required this.packages,
    required this.offers,
    required this.totalPrice,
    required this.status,
  });

  factory NotificationDetails.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> safeParse(dynamic raw) {
      if (raw is List) {
        return raw.where((e) => e != null && e is Map).map((e) {
          final map = e as Map;
          return map.map((key, value) => MapEntry(
                key.toString(),
                value?.toString() ?? '', // أي null يبقى ''
              ));
        }).toList();
      }
      return [];
    }

    return NotificationDetails(
      bookingId: int.tryParse(json['booking_id']?.toString() ?? '') ?? 0,
      clientName: json['client_name']?.toString() ?? '',
      clientEmail: json['client_email']?.toString() ?? '',
      clientPhone: json['client_phone']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      services: safeParse(json['services']),
      packages: safeParse(json['packages']),
      offers: safeParse(json['offers']),
      totalPrice: num.tryParse(json['total_price']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? '',
    );
  }
}
