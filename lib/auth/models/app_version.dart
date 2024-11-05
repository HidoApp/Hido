class AppVersion {
  AppVersion({
    this.id,
    this.versionNumber,
    this.releaseDate,
    this.isMandatory,
    this.created,
    this.description,
  });

  final String? id;
  final String? versionNumber;
  final DateTime? releaseDate;
  final bool? isMandatory;
  final DateTime? created;
  final String? description;

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      id: json["id"],
      versionNumber: json["versionNumber"],
      releaseDate: DateTime.tryParse(json["releaseDate"] ?? ""),
      isMandatory: json["isMandatory"],
      created: DateTime.tryParse(json["created"] ?? ""),
      description: json["description"],
    );
  }
}
