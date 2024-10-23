import 'package:ajwad_v4/constants/experience_level.dart';
import 'package:ajwad_v4/constants/user_roles.dart';

class Profile {
  final String? id;
  String? name;
  final String? email;
  final double? rating;
  //final String? image;

  String? profileImage;
  final String? phoneNumber;
  final int? tourNumber;
  final int? eventNumber;
  final int? hostNumber;
  final int? adventureNumber;
  final double? tourRating;
  final double? eventRating;
  final double? hostRating;
  final double? adventureRating;
  final ExperienceLevel? experienceLevel;
  final String? descriptionAboutMe;
  final List<String>? userInterests;
  final List<String>? spokenLanguage;
  final Vehicle? vehicle;
  final String? nationality;
  final String? accountType;
  final String? tourGuideLicense;
  final UserRole? userRole;
  final String? iban;
  final String? drivingLicenseExpiryDate;
  final String? vehicleIdNumber;
  Profile(
      {this.spokenLanguage,
      this.id,
      this.name,
      this.rating,
      this.tourGuideLicense,
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
      this.vehicleIdNumber,
      this.vehicle

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
      rating: json['rating'] != null ?double.parse((json['rating'] as num).toStringAsFixed(1)): 0.0,
      tourNumber: json['tourNumber'] ??0,
      tourRating: json['tourRating'] != null ? double.parse((json['tourRating'] as num).toStringAsFixed(1)): 0.0,
      
      hostNumber: json['hostNumber'] ?? 0,
      hostRating: json['hostRating']  != null ? double.parse((json['hostRating'] as num).toStringAsFixed(1)): 0.0,
      adventureNumber: json['adventureNumber'] ?? 0,
      adventureRating: json['adventureRating'] != null ?double.parse((json['adventureRating'] as num).toStringAsFixed(1)): 0.0,
      eventNumber: json['eventNumber'] ?? 0,
      eventRating: json['eventRating'] != null ? double.parse((json['eventRating'] as num).toStringAsFixed(1)): 0.0,
      //tripNumber: json['tripNumber'],
      tourGuideLicense: json['tourGuideLicense'] ?? "",
      profileImage: json['image'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      descriptionAboutMe: json['descriptionAboutMe'] ?? '',

      nationality: json['nationality'] ?? '',
      spokenLanguage: json["spokenLanguage"] == null
          ? []
          : List<String>.from(json["spokenLanguage"]!.map((x) => x)),
       vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle']),
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
      "accountType": accountType,
      "vehicle":  vehicle
    };
  }
}
class Vehicle {
  final String plateText1;
  final String plateText2;
  final String plateText3;
  final int plateNumber;
  final String vehicleClassDescEn;
  final String vehicleSequenceNumber;

  Vehicle({
    required this.plateText1,
    required this.plateText2,
    required this.plateText3,
    required this.plateNumber,
    required this.vehicleClassDescEn,
    required this.vehicleSequenceNumber,
  });

  // Factory constructor to create a Vehicle instance from JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      plateText1: json['plateText1'] ?? '',
      plateText2: json['plateText2'] ?? '',
      plateText3: json['plateText3'] ?? '',
      plateNumber: json['plateNumber'] ?? 0,
      vehicleClassDescEn: json['vehicleClassDescEn'] ?? '',
      vehicleSequenceNumber: json['vehicleSequenceNumber'] ?? '',
    );
  }

  // Method to convert Vehicle instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'plateText1': plateText1,
      'plateText2': plateText2,
      'plateText3': plateText3,
      'plateNumber': plateNumber,
      'vehicleClassDescEn': vehicleClassDescEn,
      'vehicleSequenceNumber': vehicleSequenceNumber,
    };
  }
}
