class Token {
  final String id; 
  final String email;
  final String provided;
  final String userRole;
  final dynamic iat;
  final dynamic exp;


  Token( {required this.id, required this.email, required this.provided, required this.userRole,required this.iat,required this.exp});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'],
      email: json['email'],
      provided: json['provided'],
      userRole: json['role'],
      iat: json['iat'],
      exp: json['exp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'provided': provided,
      'userRole': userRole,
      'iat': iat,
      'exp': exp,
    };
  }
}
