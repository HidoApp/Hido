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
  final List<AdventureBooking>? booking;
  final List<Time>? times;
  final double? rating;
  final String userId;

  Adventure({
    required this.id,
    required this.userId,
    this.descriptionAr,
    this.descriptionEn,
    this.rating,
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
    this.booking,
    this.times,
  });

  Adventure copyWith({
    String? id,
    String? userId,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    int? price,
    List<String>? image,
    String? regionAr,
    String? regionEn,
    Coordinate? coordinates,
    String? locationUrl,
    String? date,
    String? adventureGenre,
    int? seats,
    String? status,
    Profile? user,
    List<AdventureBooking>? booking,
    List<Time>? times,
    double? rating,
  }) {
    return Adventure(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      price: price ?? this.price,
      image: image != null ? List<String>.from(image) : this.image,
      regionAr: regionAr ?? this.regionAr,
      regionEn: regionEn ?? this.regionEn,
      coordinates: coordinates ?? this.coordinates,
      locationUrl: locationUrl ?? this.locationUrl,
      date: date ?? this.date,
      adventureGenre: adventureGenre ?? this.adventureGenre,
      seats: seats ?? this.seats,
      status: status ?? this.status,
      user: user ?? this.user,
      booking:
          booking != null ? List<AdventureBooking>.from(booking) : this.booking,
      times: times != null ? List<Time>.from(times) : this.times,
      rating: rating ?? this.rating,
    );
  }

  factory Adventure.fromJson(Map<String, dynamic> json) {
    return Adventure(
      userId: json['userId'] ?? '',
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      user: json['user'] != null && json['user']['profile'] != null
          ? Profile.fromJson(json['user']['profile'])
          : null,
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      regionAr: json['regionAr'] ?? '',
      regionEn: json['regionEn'] ?? '',
      image: json['image'] != null ? List<String>.from(json['image']) : null,
      price: json['price'] ?? 0,
      locationUrl: json['locationUrl'],
      seats: json['seats'] ?? 0,
      adventureGenre: json['adventureGenre'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      coordinates: json['coordinates'] != null
          ? Coordinate.fromJson(json['coordinates'])
          : null,
      times: json['times'] != null
          ? (json['times'] as List).map((e) => Time.fromJson(e)).toList()
          : null,
      booking: json['booking'] != null
          ? (json['booking'] as List)
              .map((e) => AdventureBooking.fromJson(e))
              .toList()
          : null,
      rating: json['rating'] != null
          ? double.parse((json['rating'] as num).toStringAsFixed(1))
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'price': price,
      'image': image,
      'regionAr': regionAr,
      'regionEn': regionEn,
      'coordinates': coordinates?.toJson(),
      'locationUrl': locationUrl,
      'date': date,
      'adventureGenre': adventureGenre,
      'seats': seats,
      'status': status,
      'user': user?.toJson(),
      //  'booking': booking?.map((e) => e.toJson()).toList(),
      'times': times?.map((e) => e.toJson()).toList(),
      'rating': rating,
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
  final double cost;

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
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      adventureId: json['adventureId'] ?? '',
      date: json['date'] ?? '',
      timeToGo: json['timeToGo'] ?? '',
      timeToReturn: json['timeToReturn'] ?? '',
      guestNumber: json['guestNumber'] ?? 0,
      status: json['status'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      created: DateTime.parse(json['created']),
      cost: (json['cost'] is int)
          ? double.parse((json['cost'] as int).toDouble().toStringAsFixed(1))
          : double.parse((json['cost'] as double? ?? 0.0).toStringAsFixed(1)),
    );
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
