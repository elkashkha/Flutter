class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePicture;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String? accountType;
  final int? points;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePicture,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.accountType,
    this.points,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserModel(
      id: data['id'] as int?,
      name: data['name'] as String,
      email: data['email'] as String,
      phone: data['phone'] as String?,
      profilePicture: data['profile_picture'] as String?,
      emailVerifiedAt: data['email_verified_at'] as String?,
      createdAt: data['created_at'] as String,
      updatedAt: data['updated_at'] as String,
      accountType: data['account_type'] as String?,
      points: data['points'] != null ? int.tryParse(data['points'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "profile_picture": profilePicture,
      "email_verified_at": emailVerifiedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "account_type": accountType,
      "points": points,
    };
  }
}