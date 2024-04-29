class UploadImage {
  final String id; 
  final String filePath;
  final String? publicId;



  UploadImage( {required this.id, required this.filePath,  this.publicId, });

  factory UploadImage.fromJson(Map<String, dynamic> json) {
    return UploadImage(
      id: json['id'],
      filePath: json['filePath'],
      publicId: json['publicId'],
  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'publicId': publicId,
      
    };
  }
}
