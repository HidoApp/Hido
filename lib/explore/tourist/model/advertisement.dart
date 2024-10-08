// models/advertisement.dart
class Advertisement {
  final String id;
  final String? title;
  final String? description;
  final List<String>? imageUrls;
  final String type;
  final String content;
  final String? redirectUrl;
  final String? relatedEntityId;
  final String startDate;
  final String endDate;
  final String advertisementStatus;
  final String status;
  final String created;

  Advertisement({
    required this.id,
    this.title,
    this.description,
    this.imageUrls,
    required this.type,
    required this.content,
    this.redirectUrl,
    this.relatedEntityId,
    required this.startDate,
    required this.endDate,
    required this.advertisementStatus,
    required this.status,
    required this.created,
  });

  // Factory method to parse JSON response into Advertisement object
  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id']??'',
      title: json['title']??'',
      description: json['description']??'',
      imageUrls:json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : null,
      type: json['type']??'',
      content: json['content']??'',
      redirectUrl: json['redirectUrl']??'',
      relatedEntityId: json['relatedEntityId']??'',
      startDate: json['startDate']??'',
      endDate: json['endDate']??'',
      advertisementStatus: json['advertisementStatus']??'',
      status: json['status']??'',
      created: json['created']??'',
    );
  }
}
