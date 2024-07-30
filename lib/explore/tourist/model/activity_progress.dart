class ActivityProgress {
  ActivityProgress({
    this.id,
    this.placeId,
    this.requestId,
    this.chatId,
    this.date,
    this.timeToGo,
    this.timeToReturn,
    this.guestNumber,
    this.status,
    this.orderStatus,
    this.created,
    this.activityProgress,
  });

  final String? id;
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

  factory ActivityProgress.fromJson(Map<String, dynamic> json) {
    return ActivityProgress(
      id: json["id"],
      placeId: json["placeId"],
      requestId: json["requestId"],
      chatId: json["chatId"],
      date: json["date"] ?? "",
      timeToGo: json["timeToGo"],
      timeToReturn: json["timeToReturn"],
      guestNumber: json["guestNumber"],
      status: json["status"],
      orderStatus: json["orderStatus"],
      created: json["created"] ?? "",
      activityProgress: json["activityProgress"],
    );
  }
}
