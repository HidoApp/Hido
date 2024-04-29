class User {
  final String accessToken;
  final String expiresIn;
  final String refreshToken;
  final String refreshExpiresIn;


  User({required this.accessToken, required this.expiresIn, required this.refreshToken,required this.refreshExpiresIn});

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
    };
  }
}
