import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';

class Booking {
  final String? id;
  final String? placeId;
  final String? chatId;
  final String date;
  final String time;
  final int? guestNumber;
  final dynamic cost;
  final String? vehicleType;
  final String? orderStatus;
  final Coordinate? coordinates;
  final Place? place;

  Booking({
    required this.id,
    this.placeId,
    this.chatId,
    required this.date,
    required this.time,
    this.guestNumber,
    this.cost,
    this.vehicleType,
    this.coordinates,
    this.orderStatus,
    this.place,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      placeId: json['placeId'],
      chatId: json['chatId'],
      date: json['date'],
      orderStatus: json['orderStatus'],
      time: json['time'],
      guestNumber: json['guestNumber'],
      cost: json['cost'],
      vehicleType: json['vehicleType'],
      coordinates: json['coordinates'] == null
          ? null
          : Coordinate.fromJson(json['coordinates']),
      place: json['place'] == null ? null : Place.fromJson(json['place']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
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