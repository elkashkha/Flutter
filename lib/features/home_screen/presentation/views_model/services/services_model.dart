import 'dart:convert';

class ServiceResponse {
  final List<Service> data;

  ServiceResponse({required this.data});

  factory ServiceResponse.fromJson(String str) =>
      ServiceResponse.fromMap(json.decode(str));

  factory ServiceResponse.fromMap(Map<String, dynamic> json) => ServiceResponse(
    data: List<Service>.from(
        (json["data"] ?? []).map((x) => Service.fromMap(x))),
  );
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
  final Details details;
  final double averageRating;
  final List<dynamic> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  factory Service.fromJson(String str) => Service.fromMap(json.decode(str));

  factory Service.fromMap(Map<String, dynamic> json) => Service(
    id: json["id"] ?? 0,
    nameAr: json["name_ar"] ?? "",
    nameEn: json["name_en"] ?? "",
    descriptionAr: json["description_ar"] ?? "",
    descriptionEn: json["description_en"] ?? "",
    price: json["price"] ?? "",
    duration: json["duration"] ?? "",
    imageUrl: json["image_url"] ?? "",
    details: json["details"] != null
        ? Details.fromMap(json["details"])
        : Details(tools: [], staff: 0),
    averageRating: (json["average_rating"] ?? 0).toDouble(),
    reviews: List<dynamic>.from((json["reviews"] ?? []).map((x) => x)),
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime(2000, 1, 1),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime(2000, 1, 1),
  );
}

class Details {
  final List<String> tools;
  final int staff;

  Details({
    required this.tools,
    required this.staff,
  });

  factory Details.fromJson(String str) => Details.fromMap(json.decode(str));

  factory Details.fromMap(Map<String, dynamic> json) => Details(
    tools: List<String>.from((json["tools"] ?? []).map((x) => x)),
    staff: json["staff"] ?? 0,
  );
}
