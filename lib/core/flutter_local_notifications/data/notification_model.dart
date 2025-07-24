class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['is_read'] == 1,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
