import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';

class Hospitality {
  final String id;
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
  final List<Booking>? booking;

  final String familyName;
  final List<String> images;
  final String familyImage;
  final String iban;
  final String location;
  final int price;
  final String region;
  final List< DayInfo> daysInfo;


  Hospitality({required this.id, required this.bioAr, this.booking, required this.bioEn, required this.mealTypeAr, required this.mealTypeEn, required this.categoryAr, required this.categoryEn, required this.titleAr, required this.titleEn, required this.email,required this.familyName , required this.images, required this.familyImage, required this.iban, required this.location, required this.price, required this.region,required this.coordinate,required this.daysInfo});
  factory Hospitality.fromJson(Map<String, dynamic> json){
   return Hospitality(
    id: json['id'], 
    bioAr: json['bioAr'], 
    bioEn: json['bioEn'], 
    mealTypeAr: json['mealTypeAr'], 
    mealTypeEn: json['mealTypeEn'], 
    categoryAr: json['categoryAr'], 
    categoryEn: json['categoryEn'], 
    titleAr: json['titleAr'], 
    titleEn: json['titleEn'], 
    email: json['email'], 
    coordinate: Coordinate.fromJson(json['coordinates']), 
    booking:json['booking'] != null ?  (json['booking'] as List).map((e) => Booking.fromJson(e)).toList() : null, 
    familyName: json['familyName'], 
    familyImage: json['familyImage'], 
    images:  List<String>.from(json["image"]),
    iban: json['iban'], 
    location: json['location'], 
    price: json['price'], 
    region: json['region'],
        daysInfo: ( json['daysInfo'] as List ).map((e) => DayInfo.fromJson(e) ).toList(),
    
    );

  }

}