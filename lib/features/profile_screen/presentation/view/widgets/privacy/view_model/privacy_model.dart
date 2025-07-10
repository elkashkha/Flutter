class PoliciesResponse {
  final List<Policy> policies;

  PoliciesResponse({required this.policies});

  factory PoliciesResponse.fromJson(Map<String, dynamic> json) {
    return PoliciesResponse(
      policies: (json['data'] as List)
          .map((item) => Policy.fromJson(item))
          .toList(),
    );
  }
}

class Policy {
  final int id;
  final Map<String, String> title;
  final Map<String, String> content;
  final String createdAt;

  Policy({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'],
      title: Map<String, String>.from(json['title']),
      content: Map<String, String>.from(json['content']),
      createdAt: json['created_at'],
    );
  }
}
