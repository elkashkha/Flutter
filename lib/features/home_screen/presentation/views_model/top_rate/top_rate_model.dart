import 'dart:convert';

class TopRatedSpecialist {
  final int id;
  final String name;
  final String email;
  final String status;
  final int sessionsCount;
  final String experienceStartDate;
  final int experienceYears;
  final List<String> workDays;
  final List<String> workHours;
  final String profilePicture;
  final String level;
  final String overprice;
  final double rating;
  final List<Service> services;
  final List<Review> reviews;

  TopRatedSpecialist({
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
    required this.reviews,
  });

  factory TopRatedSpecialist.fromJson(Map<String, dynamic> json) {
    return TopRatedSpecialist(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      sessionsCount: json['sessions_count'],
      experienceStartDate: json['experience_start_date'],
      experienceYears: json['experience_years'],
      workDays: List<String>.from(jsonDecode(json['work_days'])),
      workHours: List<String>.from(jsonDecode(json['work_hours'])),
      profilePicture: json['profile_picture'] ?? '',
      level: json['level'],
      overprice: json['overprice'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      services:
          (json['services'] as List).map((e) => Service.fromJson(e)).toList(),
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
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

class Review {
  final int id;
  final double rating;
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
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      comment: json['comment'],
      user: ReviewUser.fromJson(json['user']),
    );
  }
}

class ReviewUser {
  final int id;
  final String name;

  ReviewUser({
    required this.id,
    required this.name,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'],
    );
  }
}
