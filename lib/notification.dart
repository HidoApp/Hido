class Notifications {
  final int? totalCount;
  final List<NotificationItem>? resultList;

  Notifications({
   this.totalCount,
    this.resultList,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      totalCount: json['total_count'] ??0 ,
      // resultList: (json['result_list'] as List)
      //     .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
      //     .toList(),
     resultList: json['result_list'] != null
          ? (json['result_list'] as List)
              .map((e) => NotificationItem.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount??0,
      'result_list': resultList?.map((item) => item.toJson()).toList(),
      
    };
  }
}

class NotificationItem {
  final String id;
  final String notificationId;
  final String userId;
  final String? deviceId;
  final String title;
  final String body;
  final String image;
  final Map<String, String> data;
  final bool isRead;
  final String notificationType;
  final String? entityId;
  final String notificationStatus;
  final String status;
  final DateTime created;

  NotificationItem({
    required this.id,
    required this.notificationId,
    required this.userId,
    this.deviceId,
    required this.title,
    required this.body,
    required this.image,
    required this.data,
    required this.isRead,
    required this.notificationType,
    this.entityId,
    required this.notificationStatus,
    required this.status,
    required this.created,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']??'',
      notificationId: json['notification_id']??'',
      userId: json['user_id'] ??'',
      deviceId: json['device_id'] ??'',
      title: json['title'] ??'',
      body: json['body'] ??'',
      image: json['image'] ??'',
      data: Map<String, String>.from(json['data'] as Map),
      isRead: json['is_read'] as bool,
      notificationType: json['notification_type'] ??'',
      entityId: json['entity_id'] ??'',
      notificationStatus: json['notification_status']??'',
      status: json['status'] ??'',
      created: DateTime.parse(json['created'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'user_id': userId,
      'device_id': deviceId,
      'title': title,
      'body': body,
      'image': image,
      'data': data,
      'is_read': isRead,
      'notification_type': notificationType,
      'entity_id': entityId,
      'notification_status': notificationStatus,
      'status': status,
      'created': created.toIso8601String(),
    };
  }
}
