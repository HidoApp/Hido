import 'package:ajwad_v4/constants/experience_level.dart';
import 'package:ajwad_v4/constants/user_roles.dart';

class Profile {
  final String? id;
  final String? name;
  final int? rating;
  String? profileImage;
  final String? phoneNumber;
  final int? tourNumber;
  final int? eventNumber;
  final int? hostNumber;
  final int? adventureNumber;
  final int? tourRating;
  final int? eventRating;
  final int? hostRating;
  final int? adventureRating;
  final ExperienceLevel? experienceLevel;
  final String? descriptionAboutMe;
  final List<String>? userInterests;
  final String? nationality;
  final UserRole? userRole;

  Profile({
    this.id,
    //  this.userId,
    this.name,
    this.rating,
    //this.tripNumber,
    this.profileImage,
    this.phoneNumber,
    this.eventNumber,
    this.hostNumber,
    this.adventureNumber,
    this.tourRating,
    this.eventRating,
    this.hostRating,
    this.adventureRating,
    this.experienceLevel,
    this.descriptionAboutMe,
    this.userInterests,
    this.nationality,
    this.userRole,
    this.tourNumber,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      //   userId: json['user_id'],
      name: json['name'],
      rating: json['rating'],
      tourNumber: json['tourNumber'],
      tourRating: json['tourRating'],
      hostNumber: json['hostNumber'],
      hostRating: json['hostRating'],
      adventureNumber: json['adventureNumber'],
      adventureRating: json['adventureRating'],
      eventNumber: json['eventNumber'],
      eventRating: json['eventRating'],
      //tripNumber: json['tripNumber'],
      profileImage: json['image'],
      phoneNumber: json['phoneNumber'],

      descriptionAboutMe: json['descriptionAboutMe'],

      nationality: json['nationality'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'user_id': userId,
      'name': name,
      'rating': rating,
      //'image': image,
      'tourNumber': tourNumber,
      //'tripNumber': tripNumber,
      // 'image': profileImage,
      'phoneNumber': phoneNumber,
      // 'experienceLevel': governmentIssuedId,
      // 'car_color': carColor,
      // 'car_plate': carPlate,
      // 'car_model': carModel,
      // 'car_type': carType,
      'experienceLevel': experienceLevel,
      'descriptionAboutMe': descriptionAboutMe,
      'userInterest': userInterests,
      'nationality': nationality,
      //'userRole': userRole,
    };
  }
}
