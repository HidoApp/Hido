class AcceptedOffer {
  final String? id;
  final String? userId;
  final String? placeId;
  final String? bookingId;
  final String? requestType;
  final String? senderName;
  final String? senderImage;
  final Map<String, dynamic>? requestName;
  final String? date;
  final String? orderStatus;
  final String? created;

  AcceptedOffer({
    this.id,
    this.userId,
    this.placeId,
    this.bookingId,
    this.requestType,
    this.senderName,
    this.senderImage,
    this.requestName,
    this.date,
    this.orderStatus,
    this.created,
  });

  factory AcceptedOffer.fromJson(Map<String, dynamic> json) {
    return AcceptedOffer(
      id: json['id'],
      userId: json['userId'],
      placeId: json['placeId'],
      bookingId: json['bookingId'],
      requestType: json['requestType'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      requestName: json['requestName'],
      date: json['date'],
      orderStatus: json['orderStatus'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'bookingId': bookingId,
      'requestType': requestType,
      'senderName': senderName,
      'senderImage': senderImage,
      'requestName': requestName,
      'date': date,
      'orderStatus': orderStatus,
      'created': created,
    };
  }
}
