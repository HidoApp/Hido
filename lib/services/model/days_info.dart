

class DayInfo{
  final String id;
  final String startTime;
  final String endTime;
  final int seats;

  DayInfo({required this.id,required this.startTime,required this.endTime,required this.seats, });

  factory DayInfo.fromJson(Map<String , dynamic> json) {
    return DayInfo(
      id: json['id']??'',
      startTime: json['startTime']??'',
      seats: json['seats']??0,
      endTime: json['endTime']??'',
    );
  }
}