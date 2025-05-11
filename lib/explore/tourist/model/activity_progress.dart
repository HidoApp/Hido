class ActivityProgress {
  ActivityProgress(
      {this.id,
      this.placeId,
      this.requestId,
      this.chatId,
      this.localId,
      this.date,
      this.timeToGo,
      this.timeToReturn,
      this.guestNumber,
      this.status,
      this.orderStatus,
      this.created,
      this.activityProgress,
      this.localNameAr,
      this.localNameEn,
      this.bookingId,
      this.requestName});

  final String? id;
  final String? localId;
  final String? placeId;
  final String? requestId;
  final String? chatId;
  final String? date;
  final String? timeToGo;
  final String? timeToReturn;
  final int? guestNumber;
  final String? status;
  final String? orderStatus;
  final String? created;
  final String? activityProgress;
  final String? localNameAr;
  final String? localNameEn;
  final RequestName? requestName;
  final String? bookingId;

  factory ActivityProgress.fromJson(Map<String, dynamic> json) {
    return ActivityProgress(
      id: json["id"] ?? "",
      placeId: json["placeId"] ?? "",
      requestId: json["requestId"] ?? "",
      bookingId: json['bookingId'],
      localId: json['acceptedById'] ?? "",
      chatId: json["chatId"],
      date: json["date"] ?? "",
      timeToGo: json["timeToGo"] ?? "",
      timeToReturn: json["timeToReturn"] ?? "",
      guestNumber: json["guestNumber"] ?? "",
      status: json["status"] ?? "",
      orderStatus: json["orderStatus"] ?? "",
      created: json["created"] ?? "",
      activityProgress: json["activityProgress"] ?? "",
      localNameAr: json['nameAr'] ?? "",
      requestName: json["requestName"] == null
          ? null
          : RequestName.fromJson(json["requestName"]),
      localNameEn: json['name'] ?? "",
    );
  }
}

class RequestName {
  RequestName({
    required this.nameEn,
    required this.nameAr,
    required this.nameZh,
  });

  final String? nameEn;
  final String? nameAr;
  final String? nameZh;

  factory RequestName.fromJson(Map<String, dynamic> json) {
    return RequestName(
      nameEn: json["nameEn"] ?? "",
      nameAr: json["nameAr"] ?? "",
      nameZh: json["nameZh"] ?? "",
    );
  }
}
