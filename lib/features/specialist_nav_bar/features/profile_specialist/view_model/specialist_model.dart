import 'dart:convert';

class SpecialistProfile {
  final int id;
  final String name;
  final String email;
  final String status;
  final int sessionsCount;
  final DateTime experienceStartDate;
  final int experienceYears;
  final List<String> workDays;
  final List<String> workHours;
  final String? profilePicture;
  final String level;
  final String overprice;
  final double overallRating;
  final double adminRatingsAvg;
  final int monthlyProducts;
  final int monthlyExtras;
  final List<Service> services;
  final List<Portfolio> portfolio;
  final List<Review> reviews;
  final List<AdminRating> adminRatings;

  SpecialistProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.sessionsCount,
    required this.experienceStartDate,
    required this.experienceYears,
    required this.workDays,
    required this.workHours,
    this.profilePicture,
    required this.level,
    required this.overprice,
    required this.overallRating,
    required this.adminRatingsAvg,
    required this.monthlyProducts,
    required this.monthlyExtras,
    required this.services,
    required this.portfolio,
    required this.reviews,
    required this.adminRatings,
  });

  factory SpecialistProfile.fromJson(Map<String, dynamic> json) {
    final specialistJson = json['specialist'] ?? json;

    return SpecialistProfile(
      id: specialistJson['id'],
      name: specialistJson['name'] ?? '',
      email: specialistJson['email'] ?? '',
      status: specialistJson['status'] ?? '',
      sessionsCount: specialistJson['sessions_count'] ?? 0,
      experienceStartDate:
          DateTime.tryParse(specialistJson['experience_start_date'] ?? '') ??
              DateTime.now(),
      experienceYears: specialistJson['experience_years'] ?? 0,
      workDays: specialistJson['work_days'] != null
          ? List<String>.from(jsonDecode(specialistJson['work_days']))
          : [],
      workHours: specialistJson['work_hours'] != null
          ? List<String>.from(jsonDecode(specialistJson['work_hours']))
          : [],
      profilePicture: specialistJson['profile_picture'],
      level: specialistJson['level']?.toString() ??
          '', // لو جاي int هيحولها String
      overprice: specialistJson['overprice']?.toString() ?? '',
      adminRatingsAvg:
          (specialistJson['admin_ratings_avg'] as num?)?.toDouble() ?? 0.0,
      monthlyProducts:
          int.tryParse(specialistJson['monthly_products']?.toString() ?? "0") ??
              0,
      monthlyExtras:
          int.tryParse(specialistJson['monthly_extras']?.toString() ?? "0") ??
              0,
      overallRating: double.tryParse(
              specialistJson['overall_rating']?.toString() ?? "0") ??
          0.0,
      services: (specialistJson['services'] as List? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
      portfolio: (specialistJson['portfolio'] as List? ?? [])
          .map((e) => Portfolio.fromJson(e))
          .toList(),
      reviews: (specialistJson['reviews'] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
      adminRatings: (specialistJson['admin_ratings'] as List? ?? [])
          .map((e) => AdminRating.fromJson(e))
          .toList(),
    );
  }
}

class Service {
  final int id;
  final String nameAr;
  final String nameEn;

  Service({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
      };
}

class Portfolio {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? beforeImage;
  final String? afterImage;
  final int productsSold;
  final int extraServicesUsed;
  final Service service;

  Portfolio({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.beforeImage,
    this.afterImage,
    required this.productsSold,
    required this.extraServicesUsed,
    required this.service,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      beforeImage: json['before_image'],
      afterImage: json['after_image'],
      productsSold: json['products_sold'] ?? 0,
      extraServicesUsed: json['extra_services_used'] ?? 0,
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : Service(id: 0, nameAr: '', nameEn: ''), // ✅ fallback safe
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
        'description_ar': descriptionAr,
        'description_en': descriptionEn,
        'before_image': beforeImage,
        'after_image': afterImage,
        'products_sold': productsSold,
        'extra_services_used': extraServicesUsed,
        'service': service.toJson(),
      };
}

class Review {
  final int id;
  final int rating;
  final String comment;
  final ReviewUser user;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      user: ReviewUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'rating': rating,
        'comment': comment,
        'user': user.toJson(),
      };
}

class ReviewUser {
  final int id;
  final String name;

  ReviewUser({required this.id, required this.name});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class AdminRating {
  final int id;
  final int attendance;
  final int cleanliness;
  final int salesEffort;
  final String salesNotes;
  final Admin admin;

  AdminRating({
    required this.id,
    required this.attendance,
    required this.cleanliness,
    required this.salesEffort,
    required this.salesNotes,
    required this.admin,
  });

  factory AdminRating.fromJson(Map<String, dynamic> json) {
    return AdminRating(
      id: json['id'],
      attendance: json['attendance'] ?? 0,
      cleanliness: json['cleanliness'] ?? 0,
      salesEffort: json['sales_effort'] ?? 0,
      salesNotes: json['sales_notes'] ?? '',
      admin: Admin.fromJson(json['admin']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'attendance': attendance,
        'cleanliness': cleanliness,
        'sales_effort': salesEffort,
        'sales_notes': salesNotes,
        'admin': admin.toJson(),
      };
}

class Admin {
  final int id;
  final String name;
  final String email;

  Admin({required this.id, required this.name, required this.email});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
