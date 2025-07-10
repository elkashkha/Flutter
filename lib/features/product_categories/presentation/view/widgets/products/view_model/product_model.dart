import 'dart:convert';

class Product {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double originalPrice;
  final double discountedPrice;
  final List<String> images;
  final List<String> ingredientsAr;
  final List<String> ingredientsEn;
  final List<String> benefitsAr;
  final List<String> benefitsEn;
  final String usageInstructionsAr;
  final String usageInstructionsEn;
  final double averageRating;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.originalPrice,
    required this.discountedPrice,
    required this.images,
    required this.ingredientsAr,
    required this.ingredientsEn,
    required this.benefitsAr,
    required this.benefitsEn,
    required this.usageInstructionsAr,
    required this.usageInstructionsEn,
    required this.averageRating,
    required this.reviews,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      nameAr: map['name_ar'] ?? '',
      nameEn: map['name_en'] ?? '',
      descriptionAr: map['description_ar'] ?? '',
      descriptionEn: map['description_en'] ?? '',
      originalPrice: (map['original_price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (map['discounted_price'] as num?)?.toDouble() ?? 0.0,
      images: List<String>.from(map['images'] ?? []),
      ingredientsAr: _parseStringList(map['ingredients_ar']),
      ingredientsEn: _parseStringList(map['ingredients_en']),
      benefitsAr: _parseStringList(map['benefits_ar']),
      benefitsEn: _parseStringList(map['benefits_en']),
      usageInstructionsAr: map['usage_instructions_ar'] ?? '',
      usageInstructionsEn: map['usage_instructions_en'] ?? '',
      averageRating: (map['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (map['reviews'] != null && map['reviews'] is List)
          ? List<Review>.from(map['reviews'].map((review) => Review.fromMap(review)))
          : [],
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    } else if (value is String) {
      try {
        return List<String>.from(jsonDecode(value));
      } catch (e) {
        return [value];
      }
    }
    return [];
  }
}

class Review {
  final int id;
  final String user;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? 0,
      user: map['user'] ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}

class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromMap(Map<String, dynamic> map) {
    return ProductResponse(
      products: List<Product>.from(map['data'].map((x) => Product.fromMap(x))),
    );
  }
}
