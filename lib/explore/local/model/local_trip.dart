import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';

class LocalTrip {
   final String id;
    final String date;
    final Place? place;
    final Booking? booking;


    LocalTrip({
        required this.id,
        required this.date,
        required this.place,
        required this.booking,
    });

factory LocalTrip.fromJson(Map<String, dynamic> json) {
    return LocalTrip(
       id: json['id']??'',
      date: json['date'] ?? '',
      place: json['place'] == null ? null : Place.fromJson(json['place']),
      booking: json['booking'] == null ? null : Booking.fromJson(json['booking']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      

    

    };
  }

}
class Place {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final List<String> image;

  Place({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'image': image,
    };
  }
}



class Booking {
  final String id;
  final String chatId;
  final String timeToGo;
  final String timeToReturn;
  final int guestNumber;
  final Coordinate coordinates;
  final String orderStatus;
  final String touristName;
  final String? date;


  Booking({
    required this.id,
    required this.chatId,
    required this.timeToGo,
    required this.timeToReturn,
    required this.guestNumber,
    required this.coordinates,
    required this.orderStatus,
    required this.touristName,
    this.date
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      timeToGo: json['timeToGo'] ?? '',
      timeToReturn: json['timeToReturn'] ?? '',
      guestNumber: json['guestNumber'] ?? 0,
      touristName: json['touristName'] ?? '',
     date: json['date'] ?? '',


    coordinates: Coordinate.fromJson(json['coordinates'] ?? {}),

     
     orderStatus: json['orderStatus'] ?? '',
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'timeToGo': timeToGo,
      'timeToReturn': timeToReturn,
      'guestNumber': guestNumber,
      'coordinates': coordinates.toJson(),
      'orderStatus': orderStatus,
       'touristName':touristName,
       'date':date,

    };
  }
}

