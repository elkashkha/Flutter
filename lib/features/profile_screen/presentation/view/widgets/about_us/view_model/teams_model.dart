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
  final double rating;
  final List<Service> services;
  final List<Portfolio> portfolio;
  final List<dynamic> reviews;

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
    required this.rating,
    required this.services,
    required this.portfolio,
    required this.reviews,
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
      level: json['level'] as String? ?? '',
      overprice: json['overprice']?.toString() ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as num?)?.toDouble() ?? 0.0,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      portfolio: (json['portfolio'] as List<dynamic>?)
              ?.map((e) => Portfolio.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: json['reviews'] as List<dynamic>? ?? [],
    );
  }

  /// Helper function to handle String or List cases
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

  Service({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
    );
  }
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
}
