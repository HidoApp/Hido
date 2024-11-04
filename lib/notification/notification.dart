class Notifications {
  final String? id;
  final String? notificationId;
  final String? userId;
  final String? deviceId;
  final String? title;
  final String? body;
  final String? image;
  final String? data; // Changed from Map<String, String> to String
  final bool? isRead;
  final String? notificationType;
  final String? entityId;
  final String? notificationStatus;
  final String? status;
  final String? created;

  Notifications({
    this.id,
    this.notificationId,
    this.userId,
    this.deviceId,
    this.title,
    this.body,
    this.image,
    this.data,
    this.isRead,
    this.notificationType,
    this.entityId,
    this.notificationStatus,
    this.status,
    this.created,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'] ?? '',
      notificationId: json['notificationId'] ?? '',
      userId: json['userId'] ?? '',
      deviceId: json['deviceId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
      data: json['data'] ?? '', // Adjusted to handle String
      isRead: json['isRead'] as bool? ?? true,
      notificationType: json['notificationType'] ?? '',
      entityId: json['entityId'] ?? '',
      notificationStatus: json['notificationStatus'] ?? '',
      status: json['status'] ?? '',
      created: json['created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notificationId': notificationId,
      'userId': userId,
      'deviceId': deviceId,
      'title': title,
      'body': body,
      'image': image,
      'data': data, // Kept as String
      'isRead': isRead,
      'notificationType': notificationType,
      'entityId': entityId,
      'notificationStatus': notificationStatus,
      'status': status,
      'created': created,
    };
  }
}
