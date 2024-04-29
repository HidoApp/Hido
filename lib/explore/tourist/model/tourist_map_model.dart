import 'package:ajwad_v4/adventure/model/adventure.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';

class TouristMapModel {
   List<Place>? places;
   List<Event>? events;
   List<Adventure>? adventures;

  TouristMapModel({this.places, this.adventures, this.events});

  factory TouristMapModel.fromJson(Map<String, dynamic> json) {
    return TouristMapModel(
      places: json['place'] == null
          ? null
          : (json['place'] as List).map((e) => Place.fromJson(e)).toList(),
      adventures: json['adventure'] == null
          ? null
          : (json['adventure'] as List)
              .map((e) => Adventure.fromJson(e))
              .toList(),
      events: json['event'] == null
          ? null
          : (json['event'] as List).map((e) => Event.fromJson(e)).toList(),
    );
  }
}
