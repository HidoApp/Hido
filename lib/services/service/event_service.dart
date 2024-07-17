import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
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
      Uri.parse('$baseUrl/event/{id}').replace(queryParameters: ({'id': id})),
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

  static Future<bool> createEvent({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String longitude,
    required String latitude,
    required String date,
    required double price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    // required List<Map<String, dynamic>> times,
    // required String start,
    //required String end,
    required int seat,
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
      "date": date,
      "coordinates": {
        "longitude": longitude,
        "latitude": latitude,
      },
      "locationUrl": locationUrl,
      "regionAr": regionAr,
      "regionEn": regionEn,
      "seats": seat
    };
    print(body);
    final response = await http.post(Uri.parse('$baseUrl/event'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));
    print(response.statusCode);

    //print(jsonDecode(response.body).length);
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
  }

  static Future<Event?> editEvent({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String longitude,
    required String latitude,
    required String date,
    required int price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    // required List<Map<String, dynamic>> times,
    // required String start,
    // required String end,
    required int seat,
    required BuildContext context,
  }) async {
    print(" Update adventure ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(
      Uri.parse('$baseUrl/event/$id').replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "nameAr": nameAr.trim(),
        "nameEn": nameEn.trim(),
        "descriptionAr": descriptionAr,
        "descriptionEn": descriptionEn,
        "price": price,
        "image": image,
        "date": date,
        "coordinates": {"longitude": longitude, "latitude": latitude},
        "locationUrl": locationUrl,
        "regionAr": regionAr,
        "regionEn": regionEn,
        "seats": seat,
      }),
    );

    print("Response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      try {
        var eventData = jsonDecode(response.body);
        print('event updated: $eventData');
        return Event.fromJson(eventData);
      } catch (e) {
        print('Error parsing JSON response: $e');
        return null;
      }
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool?> EventDelete(
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
      return null;
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
}
