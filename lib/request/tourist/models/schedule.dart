class Schedule {
  final String? id;
  final String? scheduleName;
  final Map<String, dynamic>? scheduleTime;
  int? price;
  bool? userAgreed;

  Schedule({
    this.id,
    this.scheduleName,
    this.scheduleTime,
    this.price,
    this.userAgreed,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      scheduleName: json['scheduleName'],
      scheduleTime: json['scheduleTime'],
      price: json['price'],
      userAgreed: json['userAgreed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleName': scheduleName,
      'scheduleTime': scheduleTime,
      'price': price,
      'userAgreed': userAgreed,
    };
  }
}
