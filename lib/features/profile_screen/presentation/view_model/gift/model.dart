import 'dart:convert';

class PlatinumGiftResponse {
  final GiftModel? gift;
  final bool canClaim;

  PlatinumGiftResponse({
    this.gift,
    required this.canClaim,
  });

  factory PlatinumGiftResponse.fromJson(Map<String, dynamic> json) {
    return PlatinumGiftResponse(
      gift: json['gift'] != null ? GiftModel.fromJson(json['gift']) : null,
      canClaim: json['can_claim'] ?? false,
    );
  }
}

class GiftModel {
  final int id;
  final int giftableId;
  final String giftableType;
  final String titleAr;
  final String titleEn;
  final String reason;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GiftableModel giftable;

  GiftModel({
    required this.id,
    required this.giftableId,
    required this.giftableType,
    required this.titleAr,
    required this.titleEn,
    required this.reason,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.giftable,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'],
      giftableId: json['giftable_id'],
      giftableType: json['giftable_type'],
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      reason: json['reason'],
      active: json['active'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      giftable: GiftableModel.fromJson(json['giftable']),
    );
  }
}

class GiftableModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String originalPrice;
  final String discountedPrice;
  final String image;
  final List<String> services;

  GiftableModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.originalPrice,
    required this.discountedPrice,
    required this.image,
    required this.services,
  });

  factory GiftableModel.fromJson(Map<String, dynamic> json) {
    List<String> servicesList = [];
    if (json['services'] != null && json['services'] is String) {
      try {
        servicesList = (jsonDecode(json['services']) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      } catch (e) {
        servicesList = [];
      }
    }

    return GiftableModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      originalPrice: json['original_price'] ?? '0.00',
      discountedPrice: json['discounted_price'] ?? '0.00',
      image: json['image'],
      services: servicesList,
    );
  }
}