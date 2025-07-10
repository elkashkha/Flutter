class Offer {
  final int id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final double originalPrice;
  final double discountedPrice;
  final String discountPercentage;
  final String startDate;
  final String endDate;
  final String status;
  final bool isFeatured;
  final int maxRedemptions;
  final int priority;
  final String offerCode;
  final Package package;
  final String imageUrl;

  Offer({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isFeatured,
    required this.maxRedemptions,
    required this.priority,
    required this.offerCode,
    required this.package,
    required this.imageUrl,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      originalPrice: json['original_price'] != null
          ? double.parse(json['original_price'].toString())
          : 0.0,
      discountedPrice: json['discounted_price'] != null
          ? double.parse(json['discounted_price'].toString())
          : 0.0,
      discountPercentage: json['discount_percentage'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      isFeatured: json['is_featured'] == 1,
      maxRedemptions: json['max_redemptions'] ?? 0,
      priority: json['priority'] ?? 0,
      offerCode: json['offer_code'] ?? '',
      package: json['package'] != null
          ? Package.fromJson(json['package'])
          : Package.empty(),
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class Package {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double originalPrice;
  final double discountedPrice;
  final List<String> services;
  final String imageUrl;

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
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      originalPrice: json['original_price'] != null
          ? double.parse(json['original_price'].toString())
          : 0.0,
      discountedPrice: json['discounted_price'] != null
          ? double.parse(json['discounted_price'].toString())
          : 0.0,
      services:
          json['services'] != null ? List<String>.from(json['services']) : [],
      imageUrl: json['image_url'] ?? '',
    );
  }

  factory Package.empty() {
    return Package(
      id: 0,
      nameAr: '',
      nameEn: '',
      descriptionAr: '',
      descriptionEn: '',
      originalPrice: 0.0,
      discountedPrice: 0.0,
      services: [],
      imageUrl: '',
    );
  }
}
