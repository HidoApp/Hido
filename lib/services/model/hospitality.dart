import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/booking_dates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';

class Hospitality {
  final String id;
  final String userId;
  final String bioAr;
  final String bioEn;
  final String mealTypeAr;
  final String mealTypeEn;
  final String categoryAr;
  final String categoryEn;
  final String titleAr;
  final String titleEn;
  final String email;
  final Coordinate coordinate;
  final List<HospitalityBooking>? booking;
  final List<String> images;
  final String iban;
  final String? location;
  final int price;
  final String? regionAr;
  final String regionEn;
  final List<DayInfo> daysInfo;
  final HostUser user;
  final String status;
  final String? touristsGender;
  final List<BookingDates>? bookingDates;
  final double? rating;

  Hospitality({
    this.rating,
    required this.id,
    required this.bioAr,
    this.touristsGender,
    this.booking,
    required this.userId,
    required this.bioEn,
    required this.mealTypeAr,
    required this.mealTypeEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.titleAr,
    required this.titleEn,
    required this.email,
    required this.images,
    required this.iban,
    required this.location,
    required this.price,
    this.regionAr,
    required this.regionEn,
    required this.coordinate,
    required this.daysInfo,
    required this.user,
    required this.status,
    this.bookingDates,
  });

  factory Hospitality.fromJson(Map<String, dynamic> json) {
    return Hospitality(
      id: json['id'] ?? '',
      bioAr: json['bioAr'] ?? '',
      bioEn: json['bioEn'] ?? '',
      mealTypeAr: json['mealTypeAr'] ?? '',
      mealTypeEn: json['mealTypeEn'] ?? '',
      categoryAr: json['categoryAr'] ?? '',
      categoryEn: json['categoryEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      email: json['email'] ?? '',
      coordinate: Coordinate.fromJson(json['coordinates'] ?? {}),
      userId: json['userId'] ?? '',
      booking: json['booking'] != null
          ? (json['booking'] as List)
              .map((e) => HospitalityBooking.fromJson(e))
              .toList()
          : null,
      rating: json['rating'] != null
          ? double.parse((json['rating'] as num).toStringAsFixed(1))
          : 0.0,
      images: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      iban: json['iban'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      regionAr: json['regionAr'] ?? '',
      regionEn: json['regionEn'] ?? '',
      user: HostUser.fromJson(json['user'] ?? {}),
      status: json['status'] ?? '',
      touristsGender: json['touristsGender'] ?? '',
      daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List).map((e) => DayInfo.fromJson(e)).toList()
          : [],
      bookingDates: json['bookingDates'] != null
          ? (json['bookingDates'] as List)
              .map((e) => BookingDates.fromJson(e))
              .toList()
          : [],
    );
  }

  /// CopyWith method
  Hospitality copyWith({
    String? id,
    String? userId,
    String? bioAr,
    String? bioEn,
    String? mealTypeAr,
    String? mealTypeEn,
    String? categoryAr,
    String? categoryEn,
    String? titleAr,
    String? titleEn,
    String? email,
    Coordinate? coordinate,
    List<HospitalityBooking>? booking,
    List<String>? images,
    String? iban,
    String? location,
    int? price,
    String? regionAr,
    String? regionEn,
    List<DayInfo>? daysInfo,
    HostUser? user,
    String? status,
    String? touristsGender,
    List<BookingDates>? bookingDates,
    double? rating,
  }) {
    return Hospitality(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bioAr: bioAr ?? this.bioAr,
      bioEn: bioEn ?? this.bioEn,
      mealTypeAr: mealTypeAr ?? this.mealTypeAr,
      mealTypeEn: mealTypeEn ?? this.mealTypeEn,
      categoryAr: categoryAr ?? this.categoryAr,
      categoryEn: categoryEn ?? this.categoryEn,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      email: email ?? this.email,
      coordinate: coordinate ?? this.coordinate,
      booking: booking ?? this.booking,
      images: images ?? this.images,
      iban: iban ?? this.iban,
      location: location ?? this.location,
      price: price ?? this.price,
      regionAr: regionAr ?? this.regionAr,
      regionEn: regionEn ?? this.regionEn,
      daysInfo: daysInfo ?? this.daysInfo,
      user: user ?? this.user,
      status: status ?? this.status,
      touristsGender: touristsGender ?? this.touristsGender,
      bookingDates: bookingDates ?? this.bookingDates,
      rating: rating ?? this.rating,
    );
  }
}

class HospitalityBooking {
  final String id;
  final String userId;
  final String hospitalityId;
  final String date;
  final String cost;
  final String orderStatus;
  final GuestInfo guestInfo;

  HospitalityBooking({
    required this.id,
    required this.userId,
    required this.hospitalityId,
    required this.date,
    required this.cost,
    required this.orderStatus,
    required this.guestInfo,
  });
  factory HospitalityBooking.fromJson(Map<String, dynamic> json) {
    return HospitalityBooking(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      hospitalityId: json['hospitalityId'] ?? '',
      date: json['date'] ?? '',
      cost: json['cost'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      guestInfo: GuestInfo.fromJson(json['guestInfo'] ?? {}),
    );
  }
}

class HostUser {
  final HostProfile profile;

  HostUser({required this.profile});

  factory HostUser.fromJson(Map<String, dynamic> json) {
    return HostUser(
      // profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      profile: HostProfile.fromJson(json['profile'] ?? {}),
    );
  }
}
