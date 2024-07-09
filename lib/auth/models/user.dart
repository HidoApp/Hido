import '../../profile/models/profile.dart';

class User {
  final String accessToken;
  final String expiresIn;
  final String refreshToken;
  final String refreshExpiresIn;


  User({required this.accessToken, required this.expiresIn, required this.refreshToken,required this.refreshExpiresIn,
  
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
      refreshToken: json['refreshToken'],
      refreshExpiresIn: json['refreshExpiresIn'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'refreshToken': refreshToken,
      'refreshExpiresIn': refreshExpiresIn,
      //'profile': profile?.toJson(),

    };
  }
}
// Profile class
class HostProfile {
  final String name;
  final String image;

  HostProfile({required this.name, required this.image});

  factory HostProfile.fromJson(Map<String, dynamic> json) {
    return HostProfile(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}



