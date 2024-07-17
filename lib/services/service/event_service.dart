import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/event_summary.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class EventService {
  static Future<List<Event>?> getEventList(
      {required BuildContext context, String? region}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/event')
          .replace(queryParameters: region != null ? {'region': region} : {}),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      final eventList =
          data.map((adventure) => Event.fromJson(adventure)).toList();
      print('this from event');
      return eventList;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }


  static Future<Event?> getEventById({
    required BuildContext context,
    required String id,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (token != '' && JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/event/$id')
          .replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Event.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  // static Future<bool> checkAdventureBooking(
  //     {required BuildContext context,
  //     required String adventureID,
  //     String? invoiceId,
  //     required int personNumber}) async {
  //   final getStorage = GetStorage();
  //   String token = getStorage.read('accessToken') ?? "";

  //   if (JwtDecoder.isExpired(token)) {
  //     final _authController = Get.put(AuthController());

  //     String refreshToken = getStorage.read('refreshToken');
  //     var user = await _authController.refreshToken(
  //         refreshToken: refreshToken, context: context);
  //     token = getStorage.read('accessToken');
  //   }
  //   Map<String, dynamic> queryParameters = {
  //     'paymentId': invoiceId,
  //     'adventureId': adventureID,
  //   };
  //   final response = await http.post(
  //       Uri.parse('$baseUrl/adventure/booking/$adventureID')
  //           .replace(queryParameters: queryParameters),
  //       headers: {
  //         'Accept': 'application/json',
  //         "Content-Type": "application/json",
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'guestNumber': personNumber}));
  //   log('status book adv');
  //   log(response.statusCode.toString());
  //   log(response.body);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);

  //     print('adventure data');
  //     print(response.body);
  //     print(data['orderStatus']);
  //     if (data['orderStatus'] == 'checked') {
  //       return true;
  //     } else {
  //       print('adventure data');
  //       print(response.body);
  //       print(data['orderStatus']);
  //       return false;
  //     }
  //   } else {
  //     String errorMessage = jsonDecode(response.body)['orderStatus'];
  //     print(errorMessage);
  //     if (context.mounted) {
  //       AppUtil.errorToast(context, errorMessage);
  //     }
  //     return false;
  //   }
  // }

  static Future<bool> createEvent({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String longitude,
    required String latitude,
    required double price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    required List<Map<String, dynamic>> daysInfo,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    Map<String, dynamic> body = {
      "nameAr": nameAr,
      "nameEn": nameEn,
      "descriptionAr": descriptionAr,
      "descriptionEn": descriptionEn,
      "price": price,
      "image": image,
      "coordinates": {
        "longitude": longitude,
        "latitude": latitude,
      },
      "daysInfo": daysInfo,
      "locationUrl": locationUrl,
      "regionAr": regionAr,
      "regionEn": regionEn,
    };
   print(body);
  print(1);
  try{
    final response = await http.post(Uri.parse('$baseUrl/event'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));

    print(response.statusCode);

    print("from services equall to ");
    if (response.statusCode == 200) {
      //  var data = jsonDecode(response.body);
      //  print(data['message']);
      //  if (data['message'] == 'checked') {
      return true;
    // } else {
    //   return false;
    // }
      } else {
        String errorMessage = jsonDecode(response.body)['message'];
        print(errorMessage);
        if (context.mounted) {
          AppUtil.errorToast(context, errorMessage);
      }
        return false;
     }
     } catch (e) {
    // Handle network errors or exceptions
    print('Error creating event: $e');
    return false;
  }
  }
   static Future<Event?> editEvent({
  required String id,
  required String nameAr,
  required String nameEn,
  required String descriptionAr,
  required String descriptionEn,
  required String longitude,
  required String latitude,
  required double price,
  required List<String> image,
  required String regionAr,
  required String locationUrl,
  required String regionEn,
  required List<Map<String, dynamic>> daysInfo,
  required BuildContext context,
}) async {
  print("Update adventure");
  final getStorage = GetStorage();
  final String? token = getStorage.read('accessToken');

  Map<String, dynamic> body = {
    "nameAr": nameAr,
    "nameEn": nameEn,
    "descriptionAr": descriptionAr,
    "descriptionEn": descriptionEn,
    "price": price,
    "image": image,
    "coordinates": {
      "longitude": longitude,
      "latitude": latitude,
    },
    "daysInfo": daysInfo,
    "locationUrl": locationUrl,
    "regionAr": regionAr,
    "regionEn": regionEn,
  };

  final response = await http.put(
    Uri.parse('$baseUrl/event/$id').replace(queryParameters: {'id': id}),
    headers: {
      'Accept': 'application/json',
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );

  print("Response status code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    try {
      var eventData = jsonDecode(response.body);
      print('Event updated: $eventData');
      return Event.fromJson(eventData);
    } catch (e) {
      print('Error parsing JSON response: $e');
      print('Response body: ${response.body}');
      return null;
    }
  } else {
    try {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
    } catch (e) {
      print('Error decoding error message: $e');
      print('Response body: ${response.body}');
    }
    return null;
  }
}


static Future<bool?>  EventDelete(
      {required BuildContext context, required String eventId}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (token != '' && JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/event/$eventId'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({}),
    );
    print("response.statusCode");
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }
   static Future<List<Event>?> getUserTicket({
    required String eventType,
    required BuildContext context,

  }) async {
    print(" getUpcomingTicket ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');
    print(token);

    final response = await http.get(
      Uri.parse('$baseUrl/event/local').replace(queryParameters: {
        'eventType': eventType,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode  ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      log('data: $data');
      print(data.length);
      print(data.isEmpty);
      return data.map((event) => Event.fromJson(event)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

static Future<EventSummary?> getEventSummaryById({
    required BuildContext context,
    required String id,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (token != '' && JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    print("TRUE $id");
    final response = await http.get(
      Uri.parse('$baseUrl/event/$id/summary')
          .replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );
    print("TRUE $id");
    print(response.statusCode);

    print(jsonDecode(response.body).length);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(inspect(data));
      return EventSummary.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

}
