class User {
  final String accessToken;
  final String expiresIn;
  final String refreshToken;
  final String refreshExpiresIn;

  User({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.refreshExpiresIn,
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

class BookProfile {
  final String id;
  final String name;
  final String? image; // Optional to handle null or unknown types
  final int tourNumber;
  final int eventNumber;
  final int hostNumber;
  final int adventureNumber;
  final double tourRating;
  final double eventRating;
  final double hostRating;
  final double adventureRating;

  BookProfile({
    required this.id,
    required this.name,
    this.image,
    required this.tourNumber,
    required this.eventNumber,
    required this.hostNumber,
    required this.adventureNumber,
    required this.tourRating,
    required this.eventRating,
    required this.hostRating,
    required this.adventureRating,
  });

  factory BookProfile.fromJson(Map<String, dynamic> json) {
    return BookProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] is String ? json['image'] : null,
      tourNumber: json['tourNumber'] ?? 0,
      eventNumber: json['eventNumber'] ?? 0,
      hostNumber: json['hostNumber'] ?? 0,
      adventureNumber: json['adventureNumber'] ?? 0,
      tourRating: (json['tourRating'] is int)
          ? (json['tourRating'] as int).toDouble()
          : (json['tourRating'] as double? ?? 0.0),
      eventRating: (json['eventRating'] is int)
          ? (json['eventRating'] as int).toDouble()
          : (json['eventRating'] as double? ?? 0.0),
      hostRating: (json['hostRating'] is int)
          ? (json['hostRating'] as int).toDouble()
          : (json['hostRating'] as double? ?? 0.0),
      adventureRating: (json['adventureRating'] is int)
          ? (json['adventureRating'] as int).toDouble()
          : (json['adventureRating'] as double? ?? 0.0),
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'tourNumber': tourNumber,
      'eventNumber': eventNumber,
      'hostNumber': hostNumber,
      'adventureNumber': adventureNumber,
      'tourRating': tourRating,
      'eventRating': eventRating,
      'hostRating': hostRating,
      'adventureRating': adventureRating,
    };
  }
}
