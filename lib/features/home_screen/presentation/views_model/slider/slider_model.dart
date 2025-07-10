class SliderModel {
  List<Data>? data;

  SliderModel({this.data});

  SliderModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<Data>.from(json['data'].map((v) => Data.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  int? id;
  Map<String, String>? title;
  Map<String, String>? subtitle;
  String? image;
  String? createdAt;

  Data({this.id, this.title, this.subtitle, this.image, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']?.cast<String, String>();
    subtitle = json['subtitle']?.cast<String, String>();
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'created_at': createdAt,
    };
  }
}
