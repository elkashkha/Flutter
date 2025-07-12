import 'dart:convert';

class PackagesResponse {
  final List<Package> data;

  PackagesResponse({required this.data});

  factory PackagesResponse.fromJson(String str) =>
      PackagesResponse.fromMap(json.decode(str));

  factory PackagesResponse.fromMap(Map<String, dynamic> json) =>
      PackagesResponse(
        data: List<Package>.from(
            (json["data"] ?? []).map((x) => Package.fromMap(x))),
      );
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
  final DateTime createdAt;
  final DateTime updatedAt;

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

  factory Package.fromJson(String str) => Package.fromMap(json.decode(str));

  factory Package.fromMap(Map<String, dynamic> json) => Package(
    id: json["id"] ?? 0,
    nameAr: json["name_ar"] ?? "",
    nameEn: json["name_en"] ?? "",
    descriptionAr: json["description_ar"] ?? "",
    descriptionEn: json["description_en"] ?? "",
    originalPrice: json["original_price"] ?? "0.00",
    discountedPrice: json["discounted_price"] ?? "0.00",
    services: List<String>.from((json["services"] ?? []).map((x) => x)),
    imageUrl: json["image_url"] ?? "",
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime(2000, 1, 1),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime(2000, 1, 1),
  );
}
