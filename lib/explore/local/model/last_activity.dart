import 'package:ajwad_v4/explore/local/model/local_trip.dart';

class NextActivity {
  final String? id;
  final String? activityProgress;
  final RequestName? requestName;
  final Booking? booking;

  NextActivity({
    this.id,
    this.activityProgress,
    this.requestName,
    this.booking,
  });

  factory NextActivity.fromJson(Map<String, dynamic> json) {
    return NextActivity(
      id: json['id'] ?? '',
      activityProgress: json['activityProgress'] ?? '',
      requestName: json['requestName'] == null
          ? null
          : RequestName.fromJson(json['requestName']),
      booking:
          json['booking'] == null ? null : Booking.fromJson(json['booking']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityProgress': activityProgress,
      'requestName': requestName?.toJson(),
      'booking': booking?.toJson(),
    };
  }
}

class RequestName {
  String nameEn;
  String nameAr;

  RequestName({
    required this.nameEn,
    required this.nameAr,
  });

  factory RequestName.fromJson(Map<String, dynamic> json) {
    return RequestName(
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nameAr': nameAr, 'nameEn': nameEn};
  }
}
