class AjwadiInfo {
  final String accountType;
  final bool vehicle;
  final bool drivingLicense;

  AjwadiInfo(
      {required this.vehicle,
      required this.drivingLicense,
      required this.accountType});

  factory AjwadiInfo.fromJson(Map<String, dynamic> json) {
    return AjwadiInfo(
        drivingLicense: json['drivingLicense'],
        vehicle: json['vehicle'],
        accountType: json['accountType']);
  }

  Map<String, dynamic> toJson() {
    return {'drivingLicense': drivingLicense, 'vehicle': vehicle};
  }
}
