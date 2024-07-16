import 'package:ajwad_v4/constants/experience_level.dart';
import 'package:ajwad_v4/constants/user_roles.dart';

class Profile {
  final String? id;
  String? name;
  final String? email;
  final int? rating;
  //final String? image;

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
  final List<String>? spokenLanguage;
  final String? nationality;
  final UserRole? userRole;
  final String? accountType;
  final String? iban;
  final String? drivingLicenseExpiryDate;
  final String? vehicleIdNumber;
  Profile(
      {this.spokenLanguage,
      this.id,
      this.name,
      this.rating,
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
      this.email,
      this.tourNumber,
      this.accountType,
      this.iban,
      this.drivingLicenseExpiryDate,
      this.vehicleIdNumber

      //this.image,
      });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      drivingLicenseExpiryDate: json["drivingLicenseExpiryDate"] ?? '',
      vehicleIdNumber: json["vehicleIdNumber"] ?? '',
      accountType: json['accountType'] ?? '',
      iban: json['iban'] ?? "",
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // image: json['image']??'',
      rating: json['rating'] ?? 0,
      tourNumber: json['tourNumber'] ?? 0,
      tourRating: json['tourRating'] ?? 0,
      hostNumber: json['hostNumber'] ?? 0,
      hostRating: json['hostRating'] ?? 0,
      adventureNumber: json['adventureNumber'] ?? 0,
      adventureRating: json['adventureRating'] ?? 0,
      eventNumber: json['eventNumber'] ?? 0,
      eventRating: json['eventRating'] ?? 0,
      //tripNumber: json['tripNumber'],
      profileImage: json['image'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      descriptionAboutMe: json['descriptionAboutMe'] ?? '',

      nationality: json['nationality'] ?? '',
      spokenLanguage: json["spokenLanguage"] == null
          ? []
          : List<String>.from(json["spokenLanguage"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'user_id': userId,
      'name': name,
      'rating': rating,
      // 'image': image,
      'tourNumber': tourNumber,
      //'tripNumber': tripNumber,
      'image': profileImage,
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
      "spokenLanguage": spokenLanguage!.map((x) => x).toList(),
      //'userRole': userRole,
    };
  }
}
