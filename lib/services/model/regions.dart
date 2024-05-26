class Regions {
  Regions({
    this.regionAr,
    this.regionEn,
  });

  final List<String>? regionAr;
  final List<String>? regionEn;

  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(
      regionAr: json["regionAr"] == null
          ? []
          : List<String>.from(json["regionAr"]!.map((x) => x)),
      regionEn: json["regionEn"] == null
          ? []
          : List<String>.from(json["regionEn"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "regionAr": regionAr!.map((x) => x).toList(),
        "regionEn": regionEn!.map((x) => x).toList(),
      };
}
