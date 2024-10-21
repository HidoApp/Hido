import 'package:ajwad_v4/services/model/days_info.dart';

class Summary {
  final String id;
  final String titleAr;
  final String titleEn;
  final List<DayInfo> daysInfo;
  final double cost;
  final int guestNumber;
  final List<GuestList> guestList;

  Summary({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.daysInfo,
    required this.cost,
    required this.guestNumber,
    required this.guestList,
  });
  factory  Summary.fromJson(Map<String, dynamic> json) {
    
  return Summary (
      id: json['id'] ?? '',
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      cost: (json['cost'] is int)
          ? double.parse(
              (json['cost'] as int).toDouble().toStringAsFixed(1))
          : double.parse(
              (json['cost'] as double? ?? 0.0).toStringAsFixed(1)),
      // cost: (json['cost'] ?? 0).toDouble(),
      guestNumber: json['guestNumber'] ?? 0,
          daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List)
              .map((e) => DayInfo.fromJson(e))
              .toList()
          : [],
      guestList: json['guestList'] != null
          ? (json['guestList'] as List)
              .map((e) => GuestList.fromJson(e))
              .toList()
          : [],
    );
  
  }
}



class GuestList {
 final String name;
  final int male;
  final int female;

  GuestList({
    required this.name,
    required this.male,
    required this.female,
  });

  factory GuestList.fromJson(Map<String, dynamic> json) {
    return GuestList(
  
      name: json['name'] ?? '',
      male: json['male'] ?? 0,
      female: json['female'] ?? 0,
     

    );
  }
}
