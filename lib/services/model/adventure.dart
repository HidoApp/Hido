import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/profile/models/profile.dart';

class Adventure {
  final String id;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final int price;
  final List<String>? image;
  final String? regionAr;
  final String? regionEn;
  final Coordinate? coordinates;
  final String? locationUrl;
  final String? date;
  final String? adventureGenre;
  final int seats;
  final String? status;
  final Profile? user;
  final List<String>? times;
    final List<AdventureBooking>? booking;


  final String userId;

  Adventure({
    required this.id,
    required this.userId,
    this.descriptionAr,
    this.descriptionEn,
    this.nameAr,
    this.nameEn,
    this.regionAr,
    this.regionEn,
    this.user,
    this.image,
    required this.price,
    this.locationUrl,
    this.date,
    this.adventureGenre,
    required this.seats,
    required this.status,
    this.coordinates,
    this.times,
    this.booking
  });

  factory Adventure.fromJson(Map<String, dynamic> json) {
    return Adventure(
      userId: json['userId'],
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      user: Profile.fromJson(json['user']['profile']),
      descriptionAr: json['descriptionAr'],
      descriptionEn: json['descriptionEn'],
      regionAr: json['regionAr'],
      regionEn: json['regionEn'],
      image: List<String>.from(json["image"]),
      price: json['price'],
      locationUrl: json['locationUrl'],
      seats: json['seats'],
      adventureGenre: json['adventureGenre'],
      status: json['status'],
      date: json['date'],
      coordinates: Coordinate.fromJson(json['coordinates']),
      times: (json['times'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],

      // booking: json['booking'] == null
      //     ? null
      //     : (json['booking'] as List).map((e) => Booking.fromJson(e)).toList(),
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
      'times': times,

    };
  }

}
class AdventureBooking {
 final String id;
  final String userId;
  final String adventureId;
  final String date;
  final String timeToGo;
  final String timeToReturn;
  final int guestNumber;
  final int cost;
  final String status;
  final String orderStatus;
  final DateTime created;

 AdventureBooking({
    required this.id,
    required this.userId,
    required this.adventureId,
    required this.date,
    required this.timeToGo,
    required this.timeToReturn,
    required this.guestNumber,
    required this.cost,
    required this.status,
    required this.orderStatus,
    required this.created,
  });


  factory AdventureBooking.fromJson(Map<String, dynamic> json) {
    return AdventureBooking(
  
      id: json['id']??'',
      userId: json['userId']??'',
      adventureId: json['adventureId']??'',
      date: json['date']??'',
      timeToGo: json['timeToGo'],
      timeToReturn: json['timeToReturn'],
      guestNumber: json['guestNumber']??0,
      cost: json['cost']??0,
      status: json['status']??'',
      orderStatus: json['orderStatus']??'',
      created: DateTime.parse(json['created']),

    );
  }
    
}
