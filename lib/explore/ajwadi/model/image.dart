class Images {
  final String filePath;
  final String publicId;

  Images({required this.filePath, required this.publicId});


  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      filePath: json['filePath'],
      publicId: json['publicId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'publicId': publicId,
    };
  }
}