import 'dart:convert';

class SpecialistsResponse {
  final List<Specialist> data;

  SpecialistsResponse({required this.data});

  factory SpecialistsResponse.fromJson(Map<String, dynamic> json) {
    return SpecialistsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Specialist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class Specialist {
  final int id;
  final String name;
  final String email;
  final String status;
  final int sessionsCount;
  final DateTime experienceStartDate;
  final int experienceYears;
  final List<String> workDays;
  final List<String> workHours;
  final String profilePicture;
  final String level;
  final String overprice;
  final double overallRating;
  final double adminRatingsAvg;
  final List<Service> services;
  final List<Portfolio> portfolio;
  final List<Review> reviews;
  final List<AdminRating> adminRatings;

  Specialist({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.sessionsCount,
    required this.experienceStartDate,
    required this.experienceYears,
    required this.workDays,
    required this.workHours,
    required this.profilePicture,
    required this.level,
    required this.overprice,
    required this.overallRating,
    required this.adminRatingsAvg,
    required this.services,
    required this.portfolio,
    required this.reviews,
    required this.adminRatings,
  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? '',
      sessionsCount: json['sessions_count'] as int? ?? 0,
      experienceStartDate:
          DateTime.tryParse(json['experience_start_date'] ?? '') ??
              DateTime.now(),
      experienceYears: json['experience_years'] as int? ?? 0,
      workDays: _parseStringOrList(json['work_days']),
      workHours: _parseStringOrList(json['work_hours']),
      profilePicture: json['profile_picture'] as String? ?? '',
      level: json['level']?.toString() ?? '',
      overprice: json['overprice']?.toString() ?? '',
      overallRating: (json['overall_rating'] != null)
          ? (json['overall_rating'] as num).toDouble()
          : 0.0,
      adminRatingsAvg: (json['admin_ratings_avg'] != null)
          ? (json['admin_ratings_avg'] as num).toDouble()
          : 0.0,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      portfolio: (json['portfolio'] as List<dynamic>?)
              ?.map((e) => Portfolio.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      adminRatings: (json['admin_ratings'] as List<dynamic>?)
              ?.map((e) => AdminRating.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'status': status,
        'sessions_count': sessionsCount,
        'experience_start_date': experienceStartDate.toIso8601String(),
        'experience_years': experienceYears,
        'work_days': jsonEncode(workDays),
        'work_hours': jsonEncode(workHours),
        'profile_picture': profilePicture,
        'level': level,
        'overprice': overprice,
        'overall_rating': overallRating,
        'admin_ratings_avg': adminRatingsAvg,
        'services': services.map((e) => e.toJson()).toList(),
        'portfolio': portfolio.map((e) => e.toJson()).toList(),
        'reviews': reviews.map((e) => e.toJson()).toList(),
        'admin_ratings': adminRatings.map((e) => e.toJson()).toList(),
      };

  static List<String> _parseStringOrList(dynamic value) {
    if (value == null) return <String>[];
    if (value is String && value.isNotEmpty) {
      try {
        return List<String>.from(jsonDecode(value));
      } catch (_) {
        return <String>[];
      }
    } else if (value is List) {
      return List<String>.from(value.map((e) => e.toString()));
    }
    return <String>[];
  }
}

class Service {
  final int id;
  final String nameAr;
  final String nameEn;

  Service({required this.id, required this.nameAr, required this.nameEn});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
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
  final String beforeImage;
  final String afterImage;
  final Service service;

  Portfolio({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.beforeImage,
    required this.afterImage,
    required this.service,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      beforeImage: json['before_image'] as String? ?? '',
      afterImage: json['after_image'] as String? ?? '',
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
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
      id: json['id'] as int,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      user: ReviewUser.fromJson(json['user'] as Map<String, dynamic>),
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
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
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
      id: json['id'] as int,
      attendance: json['attendance'] as int? ?? 0,
      cleanliness: json['cleanliness'] as int? ?? 0,
      salesEffort: json['sales_effort'] as int? ?? 0,
      salesNotes: json['sales_notes'] as String? ?? '',
      admin: Admin.fromJson(json['admin'] as Map<String, dynamic>),
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
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
