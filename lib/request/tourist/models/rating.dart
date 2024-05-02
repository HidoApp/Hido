class Rating {
  final String? name;
  final String? id;
  final int? rating;
  final String? description;
  final String? image;
  final String? created;
  final String? status;

  Rating(
      {this.name,
      this.id,
      this.rating,
      this.description,
      this.image,
      this.created,
      this.status});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      name: json["name"],
      id: json["id"],
      rating: json["rating"],
      description: json["description"],
      image: json["image"],
      created: json["created"],
      status: json["status"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "rating": rating,
      "description": description,
      "image": image,
      "created": created,
      "status": status,
    };
  }
}
