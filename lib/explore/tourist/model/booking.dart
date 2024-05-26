import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
// import 'package:ajwad_v4/request/tourist/models/offer.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';

import '../../../auth/models/user.dart';
import '../../../profile/models/profile.dart';




class Booking {
  final String? id;
  final String? placeId;
  final String? chatId;
  final String date;
  final String timeToGo;
  final String timeToReturn;
  final int? guestNumber;
  final GuestInfo? guestInfo;
  final dynamic cost;
  final String? vehicleType;
  final String? orderStatus;
  final Coordinate? coordinates;
  final String? bookingType;
  final Place? place;
  final Hospitality? hospitality;
  final List<Offer>? offers;

  // final Adventure? adventure;
  // final Event? event;

  Booking({
    required this.id,
    this.placeId,
    this.chatId,
    required this.date,
    required this.timeToGo,
    required this.timeToReturn,
    this.guestNumber,
    this.cost,
    this.vehicleType,
    this.coordinates,
    this.orderStatus,
    this.guestInfo,
    this.bookingType,
    this.place,
    this.hospitality,
    this.offers,

    // this.adventure,
    // this.event,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      placeId: json['placeId'],
      chatId: json['chatId'],
      date: json['date'],
      orderStatus: json['orderStatus'],
      timeToGo: json['timeToGo'],
      timeToReturn: json['timeToReturn'],
      guestNumber: json['guestNumber'],
      guestInfo: json["guestInfo"] == null
          ? null
          : GuestInfo.fromJson(json["guestInfo"]),
      cost: json['cost'],
      vehicleType: json['vehicleType'],
      coordinates: json['coordinates'] == null
          ? null
          : Coordinate.fromJson(json['coordinates']),
      bookingType: json['bookingType'],
      place: json['place'] == null ? null : Place.fromJson(json['place']),
      hospitality: json['hospitality'] == null
          ? null
          : Hospitality.fromJson(json['hospitality']),
     offers: json['offers'] == null
  ? null
  : (json['offers'] as List)
      .map((offer) => Offer.fromJson(offer as Map<String, dynamic>))
      .toList(),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'timeToGo': timeToGo,
      "timeToReturn": timeToReturn,
      'guestNumber': guestNumber,
      'cost': cost,
      'vehicleType': vehicleType,
      'coordinates': coordinates,
    'offers': offers?.map((offer) => offer.toJson()).toList(),

    };
  }
}

class GuestInfo {
  GuestInfo({
    required this.male,
    required this.female,
  });

  final String? male;
  final String? female;

  factory GuestInfo.fromJson(Map<String, dynamic> json) {
    return GuestInfo(
      male: json["male"],
      female: json["female"],
    );
  }

  Map<String, dynamic> toJson() => {
        "male": male,
        "female": female,
      };
}

class Offer {
  final String id;
  final String userId;
  final String status;
  final String orderStatus;
  List<Schedule>? schedule;
 // final User? user;


  Offer({
    required this.id,
    required this.userId,
    required this.status,
    required this.orderStatus,
    this.schedule,
  //this.user,

  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      userId: json['userId'],
       schedule: json['schedule'] != null
          ? (json['schedule'] as List).map((v) => Schedule.fromJson(v)).toList()
          : [],
      status: json['status'],
      orderStatus: json['orderStatus'],
      //user: json['user'] != null ? User.fromJson(json['user']) : null,

      
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'status': status,
        'orderStatus': orderStatus,
        'schedule': schedule!.map((v) => v.toJson()).toList(),
        //'user': user?.toJson(),


      };
}


// class Profile {
//   final String id;
//   final String name;
//   final dynamic image;
//   final int tourNumber;
//   final int rating;

//   Profile({
//     required this.id,
//     required this.name,
//     this.image,
//     required this.tourNumber,
//     required this.rating,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       id: json['id'],
//       name: json['name'],
//       image: json['image'],
//       tourNumber: json['tourNumber'],
//       rating: json['rating'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'image': image,
//       'tourNumber': tourNumber,
//       'rating': rating,
//     };
//   }
// }
// class Schedule {
//   final String id;
//   final String scheduleName;
//   final ScheduleTime scheduleTime;
//   final double price;
//   final bool userAgreed;

//   Schedule({
//     required this.id,
//     required this.scheduleName,
//     required this.scheduleTime,
//     required this.price,
//     required this.userAgreed,
//   });

//   factory Schedule.fromJson(Map<String, dynamic> json) {
//     return Schedule(
//       id: json['id'],
//       scheduleName: json['scheduleName'],
//       scheduleTime: ScheduleTime.fromJson(json['scheduleTime']),
//       price: json['price'].toDouble(),
//       userAgreed: json['userAgreed'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'scheduleName': scheduleName,
//         'scheduleTime': scheduleTime.toJson(),
//         'price': price,
//         'userAgreed': userAgreed,
//       };
// }

// class ScheduleTime {
//   String? from;
//   String? to;

//   ScheduleTime({this.from, this.to});

//   ScheduleTime.fromJson(Map<String, dynamic> json) {
//     from = json['from'];
//     to = json['to'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['from'] = from;
//     data['to'] = to;
//     return data;
//   }
// }


// "booking": [
//     {
//       "id": "string",
//       "date": "2023-12-29T23:09:20.227Z",
//       "time": "string",
//       "guestNumber": 0,
//       "coordinates": {
//         "longitude": "string",
//         "latitude": "string"
//       },
//       "cost": "string",
//       "vehicleType": "string"
//     }
//   ]