class BookingResponse {
  final List<Booking> data;

  BookingResponse({required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => Booking.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class Booking {
  final int id;
  final int? userId;
  final int? teamId;
  final int specialistId;
  final String bookingDate;
  final String bookingTime;
  final String name;
  final String email;
  final String phone;
  final double? totalPrice;
  final String specialistLevel;
  final double? overprice;
  final String paymentMethod;
  final String? invoiceId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final User user;
  final List<Service> services;
  final List<Package> packages;
  final List<dynamic> offers;

  Booking({
    required this.id,
    this.userId,
    this.teamId,
    required this.specialistId,
    required this.bookingDate,
    required this.bookingTime,
    required this.name,
    required this.email,
    required this.phone,
    this.totalPrice,
    required this.specialistLevel,
    this.overprice,
    required this.paymentMethod,
    this.invoiceId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.services,
    required this.packages,
    required this.offers,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      teamId: json['team_id'] as int?,
      specialistId: json['specialist_id'] as int,
      bookingDate: json['booking_date'] as String,
      bookingTime: json['booking_time'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      totalPrice: double.tryParse(json['total_price'] as String ?? '0'),
      specialistLevel: json['specialist_level'] as String,
      overprice: double.tryParse(json['overprice'] as String ?? '0'),
      paymentMethod: json['payment_method'] as String,
      invoiceId: json['invoice_id'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      user: User.fromJson(json['user']),
      services: (json['services'] as List<dynamic>)
          .map((item) => Service.fromJson(item))
          .toList(),
      packages: (json['packages'] as List<dynamic>)
          .map((item) => Package.fromJson(item))
          .toList(),
      offers: json['offers'] as List<dynamic>,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'team_id': teamId,
      'specialist_id': specialistId,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'name': name,
      'email': email,
      'phone': phone,
      'total_price': totalPrice,
      'specialist_level': specialistLevel,
      'overprice': overprice,
      'payment_method': paymentMethod,
      'invoice_id': invoiceId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toJson(),
      'services': services.map((item) => item.toJson()).toList(),
      'packages': packages.map((item) => item.toJson()).toList(),
      'offers': offers,
    };
  }
}

class User {
  final int id;
  final String name;
  final int points;
  final String accountType;
  final List<dynamic> payments;

  User({
    required this.id,
    required this.name,
    required this.points,
    required this.accountType,
    required this.payments,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      points: json['points'] as int,
      accountType: json['account_type'] as String,
      payments: json['payments'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'account_type': accountType,
      'payments': payments,
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
  final int averageRating;
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
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      descriptionAr: json['description_ar'] as String,
      descriptionEn: json['description_en'] as String,
      price: json['price'] as String,
      duration: json['duration'] as String,
      imageUrl: json['image_url'] as String,
      details: ServiceDetails.fromJson(json['details']),
      averageRating: json['average_rating'] as int,
      reviews: json['reviews'] as List<dynamic>,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      tools: List<String>.from(json['tools']),
      staff: json['staff'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tools': tools,
      'staff': staff,
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
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      descriptionAr: json['description_ar'] as String,
      descriptionEn: json['description_en'] as String,
      originalPrice: json['original_price'] as String,
      discountedPrice: json['discounted_price'] as String,
      services: List<String>.from(json['services']),
      imageUrl: json['image_url'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
