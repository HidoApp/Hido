class Bookmark {
  final String id;
  final String titleEn;
  final String titleAr;
  final String image;
  final String type;
  final bool isBookMarked;

  Bookmark({
    required this.id,
    required this.isBookMarked,
    required this.titleEn,
    required this.titleAr,
    required this.image,
    required this.type,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] ?? '',
      isBookMarked: json['isBookMarked'] ?? false,
      titleEn: json['titleEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isBookMarked': isBookMarked,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'image': image,
      'type': type,
    };
  }
}
