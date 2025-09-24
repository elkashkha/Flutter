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
  final List<Service> services;
  final List<Portfolio> portfolio;

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
    required this.services,
    required this.portfolio,
  });

  factory SpecialistProfile.fromJson(Map<String, dynamic> json) {
    return SpecialistProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      sessionsCount: json['sessions_count'],
      experienceStartDate: DateTime.parse(json['experience_start_date']),
      experienceYears: json['experience_years'],
      workDays: json['work_days'] != null
          ? List<String>.from(jsonDecode(json['work_days']))
          : [],
      workHours: json['work_hours'] != null
          ? List<String>.from(jsonDecode(json['work_hours']))
          : [],
      profilePicture: json['profile_picture'],
      services: (json['services'] as List? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
      portfolio: (json['portfolio'] as List? ?? [])
          .map((e) => Portfolio.fromJson(e))
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
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}

class Portfolio {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? beforeImage;
  final String? afterImage;
  final Service service;

  Portfolio({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.beforeImage,
    this.afterImage,
    required this.service,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      beforeImage: json['before_image'], // ممكن ترجع null
      afterImage: json['after_image'], // ممكن ترجع null
      service: Service.fromJson(json['service']),
    );
  }
}
