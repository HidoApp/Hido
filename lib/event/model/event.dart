import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/services/model/booking_dates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';

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
  //final String? date;
  final int allowedGuests;
  final String? status;
  final List<Booking>? booking;
  final List<DayInfo>? daysInfo;
  final List<BookingDates>? bookingDates;

  final Profile? user;
  final List<String> images;
  final String? cost; //final int?seats;
  //final List<Time>? times;
  final double? rating;
  final bool allowCoupons;
  final bool hasFreeBooking;
  final int totalSeats;
  Event(
      {required this.id,
      this.descriptionAr,
      this.rating,
      this.descriptionEn,
      this.nameAr,
      this.nameEn,
      this.regionAr,
      this.regionEn,
      this.image,
      this.cost,
      this.price,
      this.locationUrl,
      this.bookingDates,
      // this.date,
      required this.allowedGuests,
      required this.status,
      required this.allowCoupons,
      this.user,
      this.daysInfo,
      this.coordinates,
      this.booking,
      required this.images,
      required this.hasFreeBooking,
      required this.totalSeats

      //this.seats,
      //this.times
      });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      allowCoupons: json['allowCoupons'] ?? true,
      hasFreeBooking: json['hasFreeBooking'] ?? true,
      totalSeats: json['totalSeats'] ?? 0,
      id: json['id'] ?? '',
      cost: json['cost'] ?? "",
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      regionAr: json['regionAr'] ?? '',
      regionEn: json['regionEn'] ?? '',
      image: List<String>.from(json["image"]),
      price: json['price'] ?? 0,
      locationUrl: json['locationUrl'] ?? '',
      allowedGuests: json['allowedGuests'] ?? 0,
      status: json['status'] ?? '',
      images: (json['image'] as List<dynamic>).map((e) => e as String).toList(),

      // date: json['date']??'',
      // seats: json['seats']??0,
      coordinates: Coordinate.fromJson(json['coordinates'] ?? {}),
      user: json['user'] != null && json['user']['profile'] != null
          ? Profile.fromJson(json['user']['profile'])
          : null,

      booking: json['booking'] != null
          ? (json['booking'] as List).map((e) => Booking.fromJson(e)).toList()
          : null,
      daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List).map((e) => DayInfo.fromJson(e)).toList()
          : [],
      bookingDates: json['bookingDates'] != null
          ? (json['bookingDates'] as List)
              .map((e) => BookingDates.fromJson(e))
              .toList()
          : [],
      rating: json['rating'] != null
          ? double.parse((json['rating'] as num).toStringAsFixed(1))
          : 0.0,
      //  times: json['times'] != null
      //     ? (json['times'] as List)
      //         .map((e) => Time.fromJson(e))
      //         .toList()
      //     : null,
    );
  }
  Event copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    bool? allowCoupons,
    bool? hasFreeBooking,
    int? totalSeats,
    int? price,
    List<String>? image,
    String? regionAr,
    String? regionEn,
    String? locationUrl,
    List<BookingDates>? bookingDates,
    int? allowedGuests,
    String? status,
    Profile? user,
    List<DayInfo>? daysInfo,
    Coordinate? coordinates,
    List<Booking>? booking,
    List<String>? images,
    String? cost,
    double? rating,
  }) {
    return Event(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      price: price ?? this.price,
      image: image != null ? List<String>.from(image) : this.image,
      regionAr: regionAr ?? this.regionAr,
      regionEn: regionEn ?? this.regionEn,
      locationUrl: locationUrl ?? this.locationUrl,
      bookingDates: bookingDates != null
          ? List<BookingDates>.from(bookingDates)
          : this.bookingDates,
      allowedGuests: allowedGuests ?? this.allowedGuests,
      status: status ?? this.status,
      user: user ?? this.user,
      daysInfo: daysInfo != null ? List<DayInfo>.from(daysInfo) : this.daysInfo,
      coordinates: coordinates ?? this.coordinates,
      booking: booking != null ? List<Booking>.from(booking) : this.booking,
      images: images != null ? List<String>.from(images) : this.images,
      cost: cost ?? this.cost,
      rating: rating ?? this.rating,
      hasFreeBooking: hasFreeBooking ?? this.hasFreeBooking,
      allowCoupons: allowCoupons ?? this.allowCoupons,
      totalSeats: totalSeats ?? this.totalSeats,
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
      //'date': date,
      'coordinates': coordinates,
      // 'seats':seats
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
