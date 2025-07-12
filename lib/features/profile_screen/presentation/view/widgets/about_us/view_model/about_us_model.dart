class AboutUsModel {
  final int id;
  final TitleModel title;
  final ContentModel content;
  final List<String> images;
  final String video;
  final String createdAt;

  AboutUsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.images,
    required this.video,
    required this.createdAt,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      id: json['id'],
      title: TitleModel.fromJson(json['title']),
      content: ContentModel.fromJson(json['content']),
      images: List<String>.from(json['images']),
      video: json['video'],
      createdAt: json['created_at'],
    );
  }
}

class TitleModel {
  final String ar;
  final String en;

  TitleModel({required this.ar, required this.en});

  factory TitleModel.fromJson(Map<String, dynamic> json) {
    return TitleModel(
      ar: json['ar'],
      en: json['en'],
    );
  }
}

class ContentModel {
  final String ar;
  final String en;

  ContentModel({required this.ar, required this.en});

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      ar: json['ar'],
      en: json['en'],
    );
  }
}
