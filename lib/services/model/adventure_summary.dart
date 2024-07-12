
class AdventureSummary {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<Times> times;
  final double cost;
  final int guestNumber;
  final List<TouristList> touristList;
  final String date;

  AdventureSummary({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.times,
    required this.cost,
    required this.guestNumber,
    required this.touristList,
    required this.date
  });
  factory  AdventureSummary.fromJson(Map<String, dynamic> json) {
    
  return AdventureSummary (
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      date: json['date'] ?? '',

    
      cost: (json['cost'] ?? 0).toDouble(),
      guestNumber: json['guestNumber'] ?? 0,
       times: json['times'] != null
          ? (json['times'] as List)
              .map((e) => Times.fromJson(e))
              .toList()
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