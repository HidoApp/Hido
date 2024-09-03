class Bookmark {
  final String id;
  final String titleEn;
  final String titleAr;
  final String image;
  final String type;
  final bool isBookMarked;
  Bookmark(
      {required this.id,
      required this.isBookMarked,
      required this.titleEn,
      required this.titleAr,
      required this.image,
      required this.type});
}
