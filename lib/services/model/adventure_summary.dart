import 'package:ajwad_v4/services/model/days_info.dart';

class AdventureSummary {
  final String id;
  final String nameAr;
  final String nameEn;
  final double cost;
  final List<DayInfo> daysInfo;
  final int guestNumber;
  final List<TouristList> touristList;
  final String date;

  AdventureSummary(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.cost,
      required this.daysInfo,
      required this.guestNumber,
      required this.touristList,
      required this.date});
  factory AdventureSummary.fromJson(Map<String, dynamic> json) {
    return AdventureSummary(
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      date: json['date'] ?? '',

      cost: (json['cost'] is int)
          ? double.parse((json['cost'] as int).toDouble().toStringAsFixed(1))
          : double.parse((json['cost'] as double? ?? 0.0).toStringAsFixed(1)),
      // cost: (json['cost'] ?? 0).toDouble(),
      guestNumber: json['guestNumber'] ?? 0,
      daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List).map((e) => DayInfo.fromJson(e)).toList()
          : [],

      touristList: json['touristList'] != null
          ? (json['touristList'] as List)
              .map((e) => TouristList.fromJson(e))
              .toList()
          : [],
    );
  }
}

class TouristList {
  final String name;
  final int guestNumber;

  TouristList({
    required this.name,
    required this.guestNumber,
  });

  factory TouristList.fromJson(Map<String, dynamic> json) {
    return TouristList(
      name: json['name'] ?? '',
      guestNumber: json['guestNumber'] ?? 0,
    );
  }
}
