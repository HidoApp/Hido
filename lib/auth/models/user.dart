import '../../profile/models/profile.dart';

class User {
  final String accessToken;
  final String expiresIn;
  final String refreshToken;
  final String refreshExpiresIn;
  //final Profile profile;


  User({required this.accessToken, required this.expiresIn, required this.refreshToken,required this.refreshExpiresIn,
  //required this.profile
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
      refreshToken: json['refreshToken'],
      refreshExpiresIn: json['refreshExpiresIn'],
      //profile: Profile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'refreshToken': refreshToken,
      'refreshExpiresIn': refreshExpiresIn,
      //'profile': profile.toJson(),

    };
  }
}
