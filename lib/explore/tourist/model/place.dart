import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';

class Place {
  final String? place;
  final String? id;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? nameAr;
  final String? nameEn;
  final List<String>? image;
  final String? regionAr;
  final String? regionEn;
  final String? locationUrl;
  final int? visitors;
  final Coordinate? coordinates;
  final double? rating;
  final int? price;
  final List<Booking>? booking;

  Place(
      {this.id,
      this.descriptionAr,
      this.descriptionEn,
      this.nameAr,
      this.nameEn,
      this.regionAr,
      this.regionEn,
      this.image,
      this.price,
      this.locationUrl,
      this.visitors,
      this.rating,
      this.coordinates,
      this.booking,
      this.place});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      place: json['place'],
      descriptionAr: json['descriptionAr'],
      descriptionEn: json['descriptionEn'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      regionAr: json['regionAr'],
      regionEn: json['regionEn'],
      image: List<String>.from(json["image"]),
      price: json['price'] ?? 0,
      locationUrl: json['locationUrl'],
      visitors: json['visitors'] ?? 0,
      // rating: json['rating'] ?? 0,
      rating: json['rating'] != null
          ? double.parse((json['rating'] as num).toStringAsFixed(1))
          : 0.0,

      coordinates: Coordinate.fromJson(json['coordinates']),
      booking: json['booking'] == null
          ? null
          : (json['booking'] as List).map((e) => Booking.fromJson(e)).toList(),
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
      'rating': rating,
      'coordinates': coordinates,
    };
  }

  toLowerCase() {}
}
