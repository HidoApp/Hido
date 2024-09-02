import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';

class OfferDetails {
  String? id;
  String? userId;
  String? orderStatus;
  String? name;
  String? image;
  String? created;
  String? requestId;
  List<Schedule>? schedule;
  Booking? booking;
  Map? payment;
  Place? place;

  OfferDetails({
    this.id,
    this.orderStatus,
    this.name,
    this.image,
    this.created,
    this.requestId,
    this.schedule,
    this.booking,
    this.userId,
    this.payment,
    this.place,
  });

  OfferDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    orderStatus = json['orderStatus'];
    name = json['name'];
    image = json['image'];
    created = json['created'];
    requestId = json['requestId'];
    if (json['schedule'] != null) {
      schedule = <Schedule>[];
      json['schedule'].forEach((v) {
        schedule!.add(Schedule.fromJson(v));
      });
    }
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
    payment = json['payment'];
    place = json['place'] == null ? null : Place.fromJson(json['place']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderStatus'] = orderStatus;
    data['name'] = name;
    data['image'] = image;
    data['created'] = created;
    data['requestId'] = requestId;
    if (schedule != null) {
      data['schedule'] = schedule!.map((v) => v.toJson()).toList();
    }
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    data['payment'] = payment;

    return data;
  }
}

// class Schedule {
//   String? id;
//   String? scheduleName;
//   ScheduleTime? scheduleTime;
//   int? price;
//   bool? userAgreed;

//   Schedule(
//       {this.id,
//       this.scheduleName,
//       this.scheduleTime,
//       this.price,
//       this.userAgreed});

//   Schedule.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     scheduleName = json['scheduleName'];
//     scheduleTime = json['scheduleTime'] != null
//         ? ScheduleTime.fromJson(json['scheduleTime'])
//         : null;
//     price = json['price'];
//     userAgreed = json['userAgreed'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['scheduleName'] = scheduleName;
//     if (scheduleTime != null) {
//       data['scheduleTime'] = scheduleTime!.toJson();
//     }
//     data['price'] = price;
//     data['userAgreed'] = userAgreed;
//     return data;
//   }
// }

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

class Booking {
  String? id;
  String? chatId;
  String? date;
  String? timeToGo;
  String? timeToReturn;
  int? guestNumber;
  Coordinates? coordinates;
  int? cost;
  String? vehicleType;
  String? status;
  String? orderStatus;
  String? created;
  PlaceInChat? place;
  //  String? bookingType;
  Hospitality? hospitality;
// Adventure? adventure;
  // Event? event;

  Booking({
    this.id,
    this.chatId,
    this.date,
    this.timeToGo,
    this.timeToReturn,
    this.guestNumber,
    this.coordinates,
    this.cost,
    this.vehicleType,
    this.status,
    this.orderStatus,
    this.created,
    this.place,
    // this.bookingType,
    this.hospitality,
    // this.adventure,
    // this.event,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    date = json['date'];
    timeToGo = json['timeToGo'];
    timeToReturn = json['timeToReturn'];
    guestNumber = json['guestNumber'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    cost = json['cost'];
    vehicleType = json['vehicleType'];
    status = json['status'];
    orderStatus = json['orderStatus'];
    created = json['created'];
    //  bookingType:json['bookingType'];

    place = json['place'] == null ? null : PlaceInChat.fromJson(json['place']);
    hospitality:
    json['hospitality'] == null
        ? null
        : Hospitality.fromJson(json['hospitality']);
    // adventure: json['adventure'] == null? null :Adventure.fromJson(json['adventure']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chatId'] = chatId;
    data['date'] = date;
    data['timeToGo'] = timeToGo;
    data['timeToReturn'] = timeToReturn;
    data['guestNumber'] = guestNumber;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    data['cost'] = cost;
    data['vehicleType'] = vehicleType;
    data['status'] = status;
    data['orderStatus'] = orderStatus;
    data['created'] = created;
    // data['bookingType']=bookingType ;

    return data;
  }
}

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
