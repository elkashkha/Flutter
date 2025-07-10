import 'dart:convert';

class Booking {
  final int id;
  final int userId;
  final int? teamId;
  final int? serviceId;
  final int? packagesId;
  final int? offerId;
  final String bookingDate;
  final String bookingTime;
  final String name;
  final String email;
  final String phone;
  final String paymentMethod;
  final String? invoiceId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final User user;
  final Team? team;
  final Service? service;
  final Package? package;
  final Offer? offer;

  Booking({
    required this.id,
    required this.userId,
    this.teamId,
    this.serviceId,
    this.packagesId,
    this.offerId,
    required this.bookingDate,
    required this.bookingTime,
    required this.name,
    required this.email,
    required this.phone,
    required this.paymentMethod,
    this.invoiceId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.team,
    this.service,
    this.package,
    this.offer,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      teamId: json['team_id'] == 'لا يوجد' || json['team_id'] == null
          ? null
          : int.tryParse(json['team_id']?.toString() ?? ''),
      serviceId: json['service_id'] == 'لا يوجد' || json['service_id'] == null
          ? null
          : int.tryParse(json['service_id']?.toString() ?? ''),
      packagesId: json['packages_id'] == 'لا يوجد' || json['packages_id'] == null
          ? null
          : int.tryParse(json['packages_id']?.toString() ?? ''),
      offerId: json['offer_id'] == 'لا يوجد' || json['offer_id'] == null
          ? null
          : int.tryParse(json['offer_id']?.toString() ?? ''),
      bookingDate: json['booking_date'] ?? '',
      bookingTime: json['booking_time'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      paymentMethod: json['payment_method'] ?? '',
      invoiceId: json['invoice_id'] == 'لا يوجد' || json['invoice_id'] == null
          ? null
          : json['invoice_id']?.toString(),
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      // إصلاح parsing للكائنات المعقدة
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'])
          : User.empty(), // إنشاء user فارغ في حالة عدم وجود بيانات
      team: json['team'] != null &&
          json['team'] != 'لا يوجد' &&
          json['team'] is Map<String, dynamic>
          ? Team.fromJson(json['team'])
          : null,
      service: json['service'] != null &&
          json['service'] != 'لا يوجد' &&
          json['service'] is Map<String, dynamic>
          ? Service.fromJson(json['service'])
          : null,
      package: json['package'] != null &&
          json['package'] != 'لا يوجد' &&
          json['package'] is Map<String, dynamic>
          ? Package.fromJson(json['package'])
          : null,
      offer: json['offer'] != null &&
          json['offer'] != 'لا يوجد' &&
          json['offer'] is Map<String, dynamic>
          ? Offer.fromJson(json['offer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'team_id': teamId,
      'service_id': serviceId,
      'packages_id': packagesId,
      'offer_id': offerId,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'name': name,
      'email': email,
      'phone': phone,
      'payment_method': paymentMethod,
      'invoice_id': invoiceId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toJson(),
      'team': team?.toJson(),
      'service': service?.toJson(),
      'package': package?.toJson(),
      'offer': offer?.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final int points;
  final String accountType;
  final List<Payment> payments;

  User({
    required this.id,
    required this.name,
    required this.points,
    required this.accountType,
    required this.payments,
  });

  // إنشاء constructor لـ user فارغ
  factory User.empty() {
    return User(
      id: 0,
      name: '',
      points: 0,
      accountType: '',
      payments: [],
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? '',
      points: json['points'] is int
          ? json['points']
          : int.tryParse(json['points']?.toString() ?? '') ?? 0,
      accountType: json['account_type'] ?? '',
      payments: json['payments'] != null && json['payments'] is List
          ? (json['payments'] as List<dynamic>)
          .where((payment) => payment is Map<String, dynamic>) // تأكد من أن العنصر map
          .map((payment) => Payment.fromJson(payment))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'account_type': accountType,
      'payments': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}

class Payment {
  final int id;
  final String amount;
  final String description;
  final String createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      amount: json['amount']?.toString() ?? '0',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'created_at': createdAt,
    };
  }
}

class Team {
  final int id;
  final String? name;
  final String image;

  Team({
    required this.id,
    this.name,
    required this.image,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'],
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class Service {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String price;
  final String duration;
  final String imageUrl;
  final ServiceDetails details;
  final double averageRating;
  final List<dynamic> reviews;
  final String createdAt;
  final String updatedAt;

  Service({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.duration,
    required this.imageUrl,
    required this.details,
    required this.averageRating,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      price: json['price']?.toString() ?? '0',
      duration: json['duration'] ?? '',
      imageUrl: json['image_url'] ?? '',
      details: json['details'] != null && json['details'] is Map<String, dynamic>
          ? ServiceDetails.fromJson(json['details'])
          : ServiceDetails.empty(),
      averageRating: (json['average_rating'] is num
          ? json['average_rating']
          : double.tryParse(json['average_rating']?.toString() ?? '') ?? 0)
          .toDouble(),
      reviews: json['reviews'] is List ? json['reviews'] : [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'price': price,
      'duration': duration,
      'image_url': imageUrl,
      'details': details.toJson(),
      'average_rating': averageRating,
      'reviews': reviews,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ServiceDetails {
  final List<String> tools;
  final int staff;

  ServiceDetails({
    required this.tools,
    required this.staff,
  });

  factory ServiceDetails.empty() {
    return ServiceDetails(
      tools: [],
      staff: 0,
    );
  }

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      tools: json['tools'] != null && json['tools'] is List
          ? (json['tools'] as List<dynamic>)
          .where((tool) => tool is String)
          .cast<String>()
          .toList()
          : [],
      staff: json['staff'] is int
          ? json['staff']
          : int.tryParse(json['staff']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tools': tools,
      'staff': staff,
    };
  }
}

class Offer {
  final int id;
  final String titleAr;
  final String? titleEn;
  final String descriptionAr;
  final String? descriptionEn;
  final double originalPrice;
  final double discountedPrice;
  final String discountPercentage;
  final String startDate;
  final String endDate;
  final String status;
  final bool isFeatured;
  final int maxRedemptions;
  final int priority;
  final String offerCode;
  final String imageUrl;

  Offer({
    required this.id,
    required this.titleAr,
    this.titleEn,
    required this.descriptionAr,
    this.descriptionEn,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isFeatured,
    required this.maxRedemptions,
    required this.priority,
    required this.offerCode,
    required this.imageUrl,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'],
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'],
      originalPrice:
      double.tryParse(json['original_price']?.toString() ?? '0') ?? 0.0,
      discountedPrice:
      double.tryParse(json['discounted_price']?.toString() ?? '0') ?? 0.0,
      discountPercentage: json['discount_percentage'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      maxRedemptions: json['max_redemptions'] is int
          ? json['max_redemptions']
          : int.tryParse(json['max_redemptions']?.toString() ?? '') ?? 0,
      priority: json['priority'] is int
          ? json['priority']
          : int.tryParse(json['priority']?.toString() ?? '') ?? 0,
      offerCode: json['offer_code'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'original_price': originalPrice,
      'discounted_price': discountedPrice,
      'discount_percentage': discountPercentage,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'is_featured': isFeatured ? 1 : 0,
      'max_redemptions': maxRedemptions,
      'priority': priority,
      'offer_code': offerCode,
      'image_url': imageUrl,
    };
  }
}

class Package {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String originalPrice;
  final String discountedPrice;
  final List<String> services;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  Package({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.originalPrice,
    required this.discountedPrice,
    required this.services,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      originalPrice: json['original_price']?.toString() ?? '0',
      discountedPrice: json['discounted_price']?.toString() ?? '0',
      services: json['services'] != null && json['services'] is List
          ? (json['services'] as List<dynamic>)
          .where((service) => service is String)
          .cast<String>()
          .toList()
          : [],
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'original_price': originalPrice,
      'discounted_price': discountedPrice,
      'services': services,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class BookingResponse {
  final List<Booking> data;

  BookingResponse({required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List<dynamic>)
          .where((item) => item is Map<String, dynamic>) // تأكد من نوع البيانات
          .map((item) {
        try {
          return Booking.fromJson(item);
        } catch (e) {
          print('Error parsing booking: $e');
          return null;
        }
      })
          .where((booking) => booking != null) // إزالة العناصر null
          .cast<Booking>()
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((booking) => booking.toJson()).toList(),
    };
  }
}


BookingResponse parseBookingResponse(String jsonString) {
  try {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return BookingResponse.fromJson(jsonData);
  } catch (e) {
    print('Error parsing booking response: $e');
    return BookingResponse(data: []);
  }
}