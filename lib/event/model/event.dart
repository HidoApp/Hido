
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';

class Event {
  final String id; 
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final int? price;
  final List<String>? image;
  final String? regionAr;
  final String? regionEn;
  final Coordinate? coordinates;
  final String? locationUrl;
  final String? date;
  final int allowedGuests;
  final String? status;
  final List<Booking>? booking;
    final int?seats;
  final List<Time>? times;


 

  Event({
    required this.id,
     this.descriptionAr,
     this.descriptionEn,
     this.nameAr,
     this.nameEn,
     this.regionAr,
     this.regionEn,
     this.image,
     this.price,
    this.locationUrl,
    this.date, 
    required this.allowedGuests,
    required this.status,
     this.coordinates,
    this.booking,
    this.seats,
    this.times
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']??'',
      descriptionAr: json['descriptionAr']??'',
      descriptionEn: json['descriptionEn']??'',
      nameAr: json['nameAr']??'',
      nameEn: json['nameEn']??'',
      regionAr: json['regionAr']??'',
      regionEn: json['regionEn']??'',
       image:List<String>.from(json["image"]),
       price: json['price']??0,
       locationUrl: json['locationUrl']??'',
      allowedGuests: json['allowedGuests']??0,
      status: json['status']??'',
      date: json['date']??'',
      seats: json['seats']??0,
       coordinates: Coordinate.fromJson(json['coordinates'] ?? {}),
     
      booking: json['booking'] != null
          ? (json['booking'] as List)
              .map((e) =>Booking.fromJson(e))
              .toList()
          : null,
       times: json['times'] != null
          ? (json['times'] as List)
              .map((e) => Time.fromJson(e))
              .toList()
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'regionAr': regionAr,
      'regionEn': regionEn,
      'image': image,
      'price': price,
      'locationUrl': locationUrl,
      'date': date,
     'coordinates': coordinates,
     'seats':seats
    };
  }
}





class Time {
  final String id;
  final String startTime;
  final String endTime;

  Time({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
