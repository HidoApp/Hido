import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';

import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';

class Experience {
  final String id;
  final String mealTypeAr;
  final String mealTypeEn;
  final String titleAr;
  final String titleEn;
  final String titleZh;
  final String nameAr;
  final String nameEn;
  final String nameZh;
  final String regionAr;
  final String regionEn;
  final List<DayInfo> times;
  final List<DayInfo> daysInfo;
  final String status;
  final String experiencesType;
  final String date;
  final Coordinate coordinates;
  final List<String> image;
  final String created;
  final bool isHasBooking;
  final double rating; // Added rating field

  Experience({
    required this.id,
    required this.mealTypeAr,
    required this.mealTypeEn,
    required this.titleAr,
    required this.titleEn,
    required this.titleZh,
    required this.regionAr,
    required this.regionEn,
    required this.times,
    required this.daysInfo,
    required this.status,
    required this.experiencesType,
    required this.date,
    required this.coordinates,
    required this.image,
    required this.created,
    required this.nameAr,
    required this.nameEn,
    required this.nameZh,
    required this.isHasBooking,
    required this.rating, // Initialize in constructor
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? '',
      isHasBooking: json['isHasBooking'] ?? false,
      mealTypeAr: json['mealTypeAr'] ?? '',
      mealTypeEn: json['mealTypeEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameZh: json['nameZh'] ?? '',
      coordinates: Coordinate.fromJson(json['coordinates'] ?? {}),
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      regionAr: json['regionAr'] ?? '',
      regionEn: json['regionEn'] ?? '',
      status: json['status'] ?? '',
      created: json['created'] ?? '',
      daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List).map((e) => DayInfo.fromJson(e)).toList()
          : [],
      times: json['times'] != null
          ? (json['times'] as List).map((e) => DayInfo.fromJson(e)).toList()
          : [],
      date: json['date'] ?? '',
      experiencesType: json['experiencesType'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(), // Parse rating
    );
  }
}
