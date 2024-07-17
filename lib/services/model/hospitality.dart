import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
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

  Hospitality({
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
    // required this.familyName,
    required this.images,
    // required this.familyImage,
    required this.iban,
    required this.location,
    required this.price,
    this.regionAr,
    required this.regionEn,
    required this.coordinate,
    required this.daysInfo,
    required this.user,
    required this.status,
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
      //familyName: json['familyName'] ?? '',
      //familyImage: json['familyImage'] ?? '',

      images: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      iban: json['iban'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      regionAr: json['regionAr'] ?? '',
      regionEn: json['regionEn'] ?? '',
      //: HostUser.fromJson(json['user'])
      user: HostUser.fromJson(
          json['user'] ?? {}), // Ensure user is initialized from json['user']
      status: json['status'] ?? '',
      touristsGender: json['touristsGender'] ?? '',

      // daysInfo: (json['daysInfo'] as List)
      //     .map((e) => DayInfo.fromJson(e))
      //     .toList(),
      daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List).map((e) => DayInfo.fromJson(e)).toList()
          : [],
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
