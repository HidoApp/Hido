import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';

class Experience {
  final String id;
  final String mealTypeAr;
  final String mealTypeEn;
 final  String titleAr;
 final  String titleEn;
  final  String nameAr;
 final  String nameEn;
 final  String regionAr;
  final String regionEn;
  final List<DayInfo> times;
  final List<DayInfo> daysInfo;
  final String status;
  final String experiencesType;
  final String date;
   final Coordinate coordinates;
  final  List<String> image;
 final  String created;

 Experience({
   required this.id,
        required this.mealTypeAr,
        required this.mealTypeEn,
        required this.titleAr,
        required this.titleEn,
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
        required this.nameEn
  });
  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? '',
    
      mealTypeAr: json['mealTypeAr'] ?? '',
      mealTypeEn: json['mealTypeEn'] ?? '',
     
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',

       nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
    
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
      experiencesType:json['experiencesType'] ?? '',
    );
  }
}

