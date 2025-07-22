import '../../tourist/models/offer_details.dart';

class RequestModel {
  String? id;
  String? date;
  String? requestType;
  String? senderName;
  String? senderImage;
  String? chatId;
  String? name;
  String? localImage;
  String? orderStatus;
  RequestName? requestName;
  Booking? booking;
  List<String>? placeImage;
  List<RequestOffer>? offer;

  RequestModel(
      {this.id,
      this.date,
      this.placeImage,
      this.requestType,
      this.senderName,
      this.senderImage,
      this.chatId,
      this.name,
      this.localImage,
      this.orderStatus,
      this.requestName,
      this.booking,
      this.offer});

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    requestType = json['requestType'];
    senderName = json['senderName'];
    senderImage = json['senderImage'];
    chatId = json['chatId'];
    name = json['name'];
    localImage = json['localImage'];
    orderStatus = json['orderStatus'];
    placeImage = json["placeImage"] == null
        ? []
        : List<String>.from(json["placeImage"]!.map((x) => x));
    requestName = json['requestName'] != null
        ? RequestName.fromJson(json['requestName'])
        : null;
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
    if (json['offer'] != null) {
      offer = <RequestOffer>[];
      json['offer'].forEach((v) {
        offer!.add(RequestOffer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['requestType'] = requestType;
    data['senderName'] = senderName;
    data['senderImage'] = senderImage;
    data['chatId'] = chatId;
    data['name'] = name;
    data['localImage'] = localImage;
    data['orderStatus'] = orderStatus;
    if (requestName != null) {
      data['requestName'] = requestName!.toJson();
    }
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    if (offer != null) {
      data['offer'] = offer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestName {
  String? nameEn;
  String? nameAr;

  RequestName({this.nameEn, this.nameAr});

  RequestName.fromJson(Map<String, dynamic> json) {
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    return data;
  }
}

// class RequestBooking {
//   String? id;
//   String? date;
//   String? time;
//   int? guestNumber;
//   Coordinates? coordinates;
//   int? cost;
//   String? vehicleType;
//   String? status;
//   String? orderStatus;
//   String? created;

//   RequestBooking(
//       {this.id,
//       this.date,
//       this.time,
//       this.guestNumber,
//       this.coordinates,
//       this.cost,
//       this.vehicleType,
//       this.status,
//       this.orderStatus,
//       this.created});

//   RequestBooking.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     time = json['time'];
//     guestNumber = json['guestNumber'];
//     coordinates = json['coordinates'] != null
//         ? Coordinates.fromJson(json['coordinates'])
//         : null;
//     cost = json['cost'];
//     vehicleType = json['vehicleType'];
//     status = json['status'];
//     orderStatus = json['orderStatus'];
//     created = json['created'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     data['time'] = time;
//     data['guestNumber'] = guestNumber;
//     if (coordinates != null) {
//       data['coordinates'] = coordinates!.toJson();
//     }
//     data['cost'] = cost;
//     data['vehicleType'] = vehicleType;
//     data['status'] = status;
//     data['orderStatus'] = orderStatus;
//     data['created'] = created;
//     return data;
//   }
// }

class Coordinates {
  String? longitude;
  String? latitude;

  Coordinates({this.longitude, this.latitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class RequestOffer {
  String? id;
  List<RequestSchedule>? schedule;
  String? orderStatus;

  RequestOffer({this.id, this.schedule, this.orderStatus});

  RequestOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['schedule'] != null) {
      schedule = <RequestSchedule>[];
      json['schedule'].forEach((v) {
        schedule!.add(RequestSchedule.fromJson(v));
      });
    }
    orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (schedule != null) {
      data['schedule'] = schedule!.map((v) => v.toJson()).toList();
    }
    data['orderStatus'] = orderStatus;
    return data;
  }
}

class RequestSchedule {
  String? id;
  String? scheduleName;
  ScheduleTime? scheduleTime;
  int? price;
  bool? userAgreed;

  RequestSchedule(
      {this.id,
      this.scheduleName,
      this.scheduleTime,
      this.price,
      this.userAgreed});

  RequestSchedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleName = json['scheduleName'];
    scheduleTime = json['scheduleTime'] != null
        ? ScheduleTime.fromJson(json['scheduleTime'])
        : null;
    price = json['price'];
    userAgreed = json['userAgreed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scheduleName'] = scheduleName;
    if (scheduleTime != null) {
      data['scheduleTime'] = scheduleTime!.toJson();
    }
    data['price'] = price;
    data['userAgreed'] = userAgreed;
    return data;
  }
}

class ScheduleTime {
  String? from;
  String? to;

  ScheduleTime({this.from, this.to});

  ScheduleTime.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
