import 'package:ajwad_v4/constants/experience_level.dart';
import 'package:ajwad_v4/constants/user_roles.dart';

class Profile {
  final String? id;
  // final String? userId;
  final String? name;
  final int? rating;
  final int? tripNumber;
   String? profileImage;
  final String? phoneNumber;
  // final String? governmentIssuedId;
  // final String? carColor;
  //final String? carPlate;
  //final String? carModel;
  //final CarType? carType;
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
    this.tripNumber,
     this.profileImage,
    this.phoneNumber,
    // this.governmentIssuedId,
    // this.carColor,
    // this.carPlate,
    // this.carModel,
    // this.carType,
    this.experienceLevel,
    this.descriptionAboutMe,
    this.userInterests,
    this.nationality,
    this.userRole,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      //   userId: json['user_id'],
      name: json['name'],
      rating: json['rating'],
      tripNumber: json['tripNumber'],
     profileImage: json['image'],
      phoneNumber: json['phoneNumber'],
      // governmentIssuedId: json['governmentIssuedId'],
      // carColor: json['car_color'],
      // carPlate: json['car_plate'],
      // carModel: json['car_model'],
      // carType: json['car_type'],
//   experienceLevel: json['experienceLevel'],
      descriptionAboutMe: json['descriptionAboutMe'],

      /// userInterests: json['userInterest'],
      nationality: json['nationality'],
      // userRole: json['userRole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'user_id': userId,
      'name': name,
      'rating': rating,
      'tripNumber': tripNumber,
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
