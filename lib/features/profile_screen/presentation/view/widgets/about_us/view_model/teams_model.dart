class TeamResponse {
  final List<TeamMember> data;

  TeamResponse({required this.data});

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TeamMember {
  final int id;
  final String nameAr; // تغيير من Name إلى nameAr وnameEn مباشرة
  final String nameEn;
  final String titleAr;
  final String titleEn;
  final String? descriptionAr; // nullable لأنه قد يكون null
  final String? descriptionEn; // nullable لأنه قد يكون null
  final List<String> specialtiesAr;
  final List<String> specialtiesEn;
  final String image;
  final List<Project> projects;
  final List<dynamic> reviews; // يمكن استبداله بنموذج Review إذا كان له هيكلية محددة
  final DateTime createdAt;
  final DateTime updatedAt;

  TeamMember({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.titleAr,
    required this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.specialtiesAr,
    required this.specialtiesEn,
    required this.image,
    required this.projects,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      specialtiesAr: (json['specialties_ar'] as List<dynamic>?)?.cast<String>() ?? [],
      specialtiesEn: (json['specialties_en'] as List<dynamic>?)?.cast<String>() ?? [],
      image: json['image'] as String? ?? '',
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      reviews: json['reviews'] as List<dynamic>? ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class Project {
  final int id;
  final int teamId;
  final List<String> images;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.teamId,
    required this.images,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      teamId: json['team_id'] as int,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}