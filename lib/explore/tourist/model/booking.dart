
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';

class Booking {
  final String? id;
  final String? placeId;
  final String? chatId;
  final String date;
  final String timeToGo;
  final String timeToReturn;
  final int? guestNumber;
  final dynamic cost;
  final String? vehicleType;
  final String? orderStatus;
  final Coordinate? coordinates;
  // final String? bookingType;
  final Place? place;
  final Hospitality? hospitality;
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
    // this.bookingType,
    this.place,
    this.hospitality,
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
      cost: json['cost'],
      vehicleType: json['vehicleType'],
      coordinates: json['coordinates'] == null
          ? null
          : Coordinate.fromJson(json['coordinates']),
      // bookingType:json['bookingType'],
      place: json['place'] == null ? null : Place.fromJson(json['place']),
      hospitality: json['hospitality'] == null? null :Hospitality.fromJson(json['hospitality']),
      // adventure: json['adventure'] == null? null :Adventure.fromJson(json['adventure']),

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
    };
  }
}


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