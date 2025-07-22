class AjwadiInfo {
  final String? accountType;
  final bool? vehicle;
  final bool? drivingLicense;
  final List<String>? transportationMethod;
  // final String? transportationMethod;

  AjwadiInfo(
      {this.vehicle,
      this.drivingLicense,
      this.accountType,
      this.transportationMethod});

  factory AjwadiInfo.fromJson(Map<String, dynamic> json) {
    return AjwadiInfo(
      drivingLicense: json['drivingLicense'],
      vehicle: json['vehicle'],
      accountType: json['accountType'] ?? "",
      transportationMethod: json['transportationMethod'] != null
          ? (json['transportationMethod'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'drivingLicense': drivingLicense, 'vehicle': vehicle};
  }
}
