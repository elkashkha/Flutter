class ProductCategoriesResponse {
  final List<ProductCategory> data;
  final Links links;
  final Meta meta;

  ProductCategoriesResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory ProductCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return ProductCategoriesResponse(
      data: List<ProductCategory>.from(
          json['data'].map((x) => ProductCategory.fromJson(x))),
      links: Links.fromJson(json['links']),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class ProductCategory {
  final int id;
  final String nameAr;
  final String nameEn;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  ProductCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Links {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  Links({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<PageLink> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      links: List<PageLink>.from(
          json['links'].map((x) => PageLink.fromJson(x))),
      path: json['path'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
