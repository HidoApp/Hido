class AjwadiInfo {

  final bool vehicle;
  final bool drivingLicense;

  AjwadiInfo({required this.vehicle, required this.drivingLicense});

  factory AjwadiInfo.fromJson(Map <String, dynamic> json){
    return AjwadiInfo(drivingLicense: json['drivingLicense'],vehicle: json['vehicle']);
  }


  Map<String,dynamic> toJson(){
    return{
      'drivingLicense':drivingLicense,
      'vehicle'  : vehicle
    };
  }

}