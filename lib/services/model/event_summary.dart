
import 'package:ajwad_v4/services/model/days_info.dart';

class EventSummary {
  final String id;
  final String nameAr;
  final String nameEn;
  final double cost;
  final int guestNumber;
  final List<TouristList> touristList;
    final List<DayInfo> daysInfo;


  EventSummary({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.cost,
    required this.guestNumber,
    required this.touristList,
    required this.daysInfo,

  });
  factory  EventSummary.fromJson(Map<String, dynamic> json) {
    
  return EventSummary (
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
       daysInfo: json['daysInfo'] != null
          ? (json['daysInfo'] as List)
              .map((e) => DayInfo.fromJson(e))
              .toList()
          : [],
    
      // cost: (json['cost'] ?? 0).toDouble(),
      cost: (json['cost'] is int)
          ? double.parse(
              (json['cost'] as int).toDouble().toStringAsFixed(1))
          : double.parse(
              (json['cost'] as double? ?? 0.0).toStringAsFixed(1)),
      guestNumber: json['guestNumber'] ?? 0,
      
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
    required this. guestNumber,
  });

  factory TouristList.fromJson(Map<String, dynamic> json) {
    return TouristList(
  
      name: json['name'] ?? '',
     guestNumber: json['guestNumber'] ?? 0,
     

    );
  }

  
}
class Times{
  final String id;
  final String startTime;
  final String endTime;

  Times({required this.id,required this.startTime,required this.endTime });

  factory Times.fromJson(Map<String , dynamic> json) {
    return Times(
      id: json['id']??'',
      startTime: json['startTime']??'',
      endTime: json['endTime']??'',
    );
  }
}