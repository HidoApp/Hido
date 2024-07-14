import 'package:ajwad_v4/explore/ajwadi/model/local_trip.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';

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
  bool get isEmpty {
    return (id == null || id!.isEmpty) &&
        (activityProgress == null || activityProgress!.isEmpty) &&
        requestName == null &&
        booking == null;
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

// class Booking {
//     String id;
//     String chatId;
//     String date;
//     String timeToGo;
//     String timeToReturn;
//     int guestNumber;
//     Coordinate coordinates;
//     String orderStatus;

//     Booking({
//         required this.id,
//         required this.chatId,
//         required this.date,
//         required this.timeToGo,
//         required this.timeToReturn,
//         required this.guestNumber,
//         required this.coordinates,
//         required this.orderStatus,
//     });

// }

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
