import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/explore/ajwadi/model/image.dart';

class Trip {
  final String? id;
  final String? tripOption;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final double? price;
  final int? visitors;
  final List<String>? date;
  final List<Images>? images;
  final Coordinate? coordinates;

  Trip({
    
    this.id, 
    this.tripOption, 
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.date,
    this.price,
    this.visitors,
    this.images,
    this.coordinates,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      tripOption: json['tripOption'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      descriptionAr: json['descriptionAr'],
      descriptionEn: json['descriptionEn'],
      date: json['date'],
      price: json['price'],
      visitors: json['visitors'],
      images: json['image'],
      coordinates: json['coordinates'] == null
          ? null
          : Coordinate.fromJson(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripOption': tripOption,
      'nameAr': nameAr,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'date': date,
      'price': price,
      'visitors': visitors,
      'image': images,
      'coordinates': coordinates == null ? null : coordinates!.toJson(),
    };
  }
}
