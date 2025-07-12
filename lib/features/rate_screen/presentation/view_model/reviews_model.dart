class ReviewModel {
  final int id;
  final UserModel user;
  final int rating;
  final String comment;
  final String status;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.status,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      rating: json['rating'],
      comment: json['comment'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['image_url'],
    );
  }
}
