class CartModel {
  final int id;
  final int userId;
  final List<CartItem> items;
  final double totalPrice;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total_price': totalPrice,
    };
  }
}

class CartItem {
  final int id;
  final int productId;
  final int quantity;
  final Product product;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.product,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'product': product.toJson(),
      'total_price': totalPrice,
    };
  }
}

class Product {
  final int id;
  final Category category;
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
  final List<dynamic> reviews;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.category,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      category: Category.fromJson(json['category']),
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      originalPrice: (json['original_price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      images: List<String>.from(json['images']),
      ingredientsAr: List<String>.from(json['ingredients_ar']),
      ingredientsEn: List<String>.from(json['ingredients_en']),
      benefitsAr: List<String>.from(json['benefits_ar']),
      benefitsEn: List<String>.from(json['benefits_en']),
      usageInstructionsAr: json['usage_instructions_ar'],
      usageInstructionsEn: json['usage_instructions_en'],
      averageRating: (json['average_rating'] as num).toDouble(),
      reviews: json['reviews'] ?? [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'original_price': originalPrice,
      'discounted_price': discountedPrice,
      'images': images,
      'ingredients_ar': ingredientsAr,
      'ingredients_en': ingredientsEn,
      'benefits_ar': benefitsAr,
      'benefits_en': benefitsEn,
      'usage_instructions_ar': usageInstructionsAr,
      'usage_instructions_en': usageInstructionsEn,
      'average_rating': averageRating,
      'reviews': reviews,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
    };
  }
}