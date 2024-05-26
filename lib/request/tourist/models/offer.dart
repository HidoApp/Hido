class Offer {
  final String? offerId;
  final String? profileId;
  final String? image;
  final int? rating;
  final String? name;
  final int? tourNumber;
  final int? price;
  final String? created;

  Offer({
    this.offerId,
    this.profileId,
    this.image,
    this.rating,
    this.name,
    this.tourNumber,
    this.price,
    this.created,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerId: json['offerId'],
      profileId: json['profileId'],
      image: json['image'],
      rating: json['rating'],
      name: json['name'],
      tourNumber: json['tourNumber'],
      price: json['price'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'profileId': profileId,
      'image': image,
      'rating': rating,
      'name': name,
      'tourNumber': tourNumber,
      'price': price,
      'created': created,
    };
  }
}
