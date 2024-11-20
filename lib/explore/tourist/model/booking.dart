import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
// import 'package:ajwad_v4/request/tourist/models/offer.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';

import '../../../auth/models/user.dart';

class Booking {
  final String? id;
  final String? placeId;
  final String? chatId;
  final String? localId;
  final String date;
  final String timeToGo;
  final String timeToReturn;
  final int? guestNumber;
  final GuestInfo? guestInfo;
  final RequestName? requestName;
  final String? titleAr;
  final String? titleEn;
  final String? nameAr;
  final String? nameEn;
  final String? vehicleType;
  final String? orderStatus;
  final Coordinate? coordinates;
  final String? bookingType;
  final Place? place;
  final Hospitality? hospitality;
  final List<Offer>? offers;
  final Adventure? adventure;
  final Event? event;
  final BookUser? user;
  // final Event? event;
  final String? profileId;
  final String? cost;
  final bool? hasPayment;
  Booking(
      {required this.id,
      this.placeId,
      this.chatId,
      required this.date,
      required this.timeToGo,
      required this.timeToReturn,
      this.guestNumber,
      this.localId,
      this.cost,
      this.vehicleType,
      this.coordinates,
      this.orderStatus,
      this.guestInfo,
      this.bookingType,
      this.place,
      this.hospitality,
      this.offers,
      this.adventure,
      this.profileId,
      this.event,
      this.user,
      this.requestName,
      this.titleAr,
      this.titleEn,
      this.nameAr,
      this.nameEn,
      this.hasPayment
      // this.event,
      });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      placeId: json['placeId'] ?? '',
      chatId: json['chatId'] ?? '',
      localId: json['localId'] ?? '',
      date: json['date'] ?? '',
      orderStatus: json['orderStatus'],
      timeToGo: json['timeToGo'] ?? '',
      timeToReturn: json['timeToReturn'] ?? '',
      guestNumber: json['guestNumber'] ?? 0,
      guestInfo: json["guestInfo"] == null
          ? null
          : GuestInfo.fromJson(json["guestInfo"]),
      //guestInfo: GuestInfo.fromJson(json['guestInfo'] ?? {}),
      requestName: json["requestName"] == null
          ? null
          : RequestName.fromJson(json["requestName"]),
      profileId: json['profileId'] ?? '',
      cost: json['cost'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      coordinates: json['coordinates'] == null
          ? null
          : Coordinate.fromJson(json['coordinates']),
      bookingType: json['bookingType'] ?? '',
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      place: json['place'] == null ? null : Place.fromJson(json['place']),
      event: json['event'] == null ? null : Event.fromJson(json['event']),
      hospitality: json['hospitality'] == null
          ? null
          : Hospitality.fromJson(json['hospitality']),
      adventure: json['adventure'] == null
          ? null
          : Adventure.fromJson(json['adventure']),

      hasPayment: json['hasPayment'] ?? true,

      user: json["user"] == null ? null : BookUser.fromJson(json['user']),
      //offers: json['offers'] == null ? null : (json['offers'] as List).map((offer) => Offer.fromJson(offer as Map<String, dynamic>)).toList(),
      offers: json['offers'] == null
          ? null
          : (json['offers'] as List<dynamic>)
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
      'guestInfo': guestInfo?.toJson(),
      'profileId': profileId,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'localId': localId,
      'hasPayment': hasPayment
//     this.profileId
    };
  }
}

class GuestInfo {
  final int female;
  final int male;
  final int guestNumber;
  final String dayId;

  GuestInfo(
      {required this.female,
      required this.male,
      required this.dayId,
      required this.guestNumber});

  factory GuestInfo.fromJson(Map<String, dynamic> json) {
    return GuestInfo(
      guestNumber: json['guestNumber'] ?? 0,
      female: json['female'] ?? 0,
      male: json['male'] ?? 0,
      dayId: json['dayId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'female': female, 'male': male, 'dayId': dayId};
  }
}

class RequestName {
  final String nameAr;
  final String nameEn;

  RequestName({
    required this.nameAr,
    required this.nameEn,
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

class Offer {
  final String id;
  final String userId;
  final String status;
  final String orderStatus;
  List<Schedule>? schedule;
  final BookUser? user;

  // final User? user;

  Offer(
      {required this.id,
      required this.userId,
      required this.status,
      required this.orderStatus,
      this.schedule,
      this.user
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
      user: json["user"] == null ? null : BookUser.fromJson(json['user']),

      //user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'status': status,
        'orderStatus': orderStatus,
        'schedule': schedule!.map((v) => v.toJson()).toList(),
        'user': user?.toJson(),
      };
}

class BookUser {
  final BookProfile profile;

  BookUser({required this.profile});

  factory BookUser.fromJson(Map<String, dynamic> json) {
    return BookUser(
      profile: BookProfile.fromJson(json['profile'] ?? {}),
    );
  }
  Map<String, dynamic> toJson() => {
        'profile': profile.toJson(),
      };
}

// class Hospitality {
//   final String id;
//   final String titleAr;
//   final String titleEn;
//   final String regionAr;
//   final String regionEn;
//   final List<String> images;
//   final Coordinate coordinates;
//   final String location;

//   Hospitality({
//     required this.id,
//     required this.titleAr,
//     required this.titleEn,
//     required this.regionAr,
//     required this.regionEn,
//     required this.images,
//     required this.coordinates,
//     required this.location,
//   });

//   factory Hospitality.fromJson(Map<String, dynamic> json) {
//     return Hospitality(
//       id: json['id'],
//       titleAr: json['titleAr'],
//       titleEn: json['titleEn'],
//       regionAr: json['regionAr'],
//       regionEn: json['regionEn'],
//       images: List<String>.from(json['image']),
//       coordinates: Coordinate.fromJson(json['coordinates']),
//       location: json['location'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'titleAr': titleAr,
//       'titleEn': titleEn,
//       'regionAr': regionAr,
//       'regionEn': regionEn,
//       'image': images,
//       'coordinates': coordinates.toJson(),
//       'location': location,
//     };
//   }
// }

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



// class Booking {
//   final String? id;
//   final String? placeId;
//   final String? chatId;
//   final String date;
//   final String timeToGo;
//   final String timeToReturn;
//   final int? guestNumber;
//   final GuestInfo? guestInfo;
//   final String? cost;
//   final String? vehicleType;
//   final String? orderStatus;
//   final Coordinate? coordinates;
//   final String? bookingType;
//   final Place? place;
//   final Hospitality? hospitality;
//   final List<Offer>? offers;
//   final Adventure? adventure;
//   final String? profileId;


//   Booking({
//     required this.id,
//     this.placeId,
//     this.chatId,
//     required this.date,
//     required this.timeToGo,
//     required this.timeToReturn,
//     this.guestNumber,
//     this.cost,
//     this.vehicleType,
//     this.coordinates,
//     this.orderStatus,
//     this.guestInfo,
//     this.bookingType,
//     this.place,
//     this.hospitality,
//     this.offers,
//     this.adventure,
//     // this.event,
//     this.profileId

//   });

//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//        id: json['id']??'',
//       placeId: json['placeId']??'',
//       chatId: json['chatId']??'',
//       date: json['date'] ?? '',
//       orderStatus: json['orderStatus'],
//       timeToGo: json['timeToGo'] ?? '',
//       timeToReturn: json['timeToReturn'] ?? '',
//       guestNumber: json['guestNumber']??0,
//       guestInfo: json["guestInfo"] == null ? null : GuestInfo.fromJson(json["guestInfo"]),
//       //guestInfo: GuestInfo.fromJson(json['guestInfo'] ?? {}),

//       cost: json['cost']??'',
//       vehicleType: json['vehicleType']??'',
//       coordinates: json['coordinates'] == null ? null : Coordinate.fromJson(json['coordinates']),
//       bookingType: json['bookingType']??'',
//       place: json['place'] == null ? null : Place.fromJson(json['place']),
//       hospitality: json['hospitality'] == null ? null : Hospitality.fromJson(json['hospitality']),
//       adventure: json['adventure'] == null ? null : Adventure.fromJson(json['adventure']),
//       profileId: json['profileId']??'',


//       //offers: json['offers'] == null ? null : (json['offers'] as List).map((offer) => Offer.fromJson(offer as Map<String, dynamic>)).toList(),
//        offers: json['offers'] == null ? null : (json['offers'] as List<dynamic>).map((offer) => Offer.fromJson(offer as Map<String, dynamic>)).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'date': date,
//       'timeToGo': timeToGo,
//       "timeToReturn": timeToReturn,
//       'guestNumber': guestNumber,
//       'cost': cost,
//       'vehicleType': vehicleType,
//       'coordinates': coordinates,
//       'offers': offers?.map((offer) => offer.toJson()).toList(),
//       'guestInfo': guestInfo?.toJson(),
//       'profileId': profileId,


    

//     };
//   }
// }