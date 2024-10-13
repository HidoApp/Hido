import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/event/model/event.dart';
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

      return eventList;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log(errorMessage);

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
      Uri.parse('$baseUrl/event/$id').replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );
    log(response.statusCode.toString());
    log(response.body.toString());
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

  //
  //
  //
  //     if (data['orderStatus'] == 'checked') {
  //       return true;
  //     } else {
  //
  //
  //
  //       return false;
  //     }
  //   } else {
  //     String errorMessage = jsonDecode(response.body)['orderStatus'];
  //
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

    try {
      final response = await http.post(Uri.parse('$baseUrl/event'),
          headers: {
            'Accept': 'application/json',
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        //  var data = jsonDecode(response.body);
        //
        //  if (data['message'] == 'checked') {
        return true;
        // } else {
        //   return false;
        // }
      } else {
        String errorMessage = jsonDecode(response.body)['message'];

        if (context.mounted) {
          AppUtil.errorToast(context, errorMessage);
        }
        return false;
      }
    } catch (e) {
      // Handle network errors or exceptions

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

    if (response.statusCode == 200) {
      try {
        var eventData = jsonDecode(response.body);

        return Event.fromJson(eventData);
      } catch (e) {
        return null;
      }
    } else {
      try {
        String errorMessage = jsonDecode(response.body)['message'];
        if (context.mounted) {
          AppUtil.errorToast(context, errorMessage);
        }
      } catch (e) {}
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
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

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

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      log('data: $data');

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
    required String date,
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
      Uri.parse('$baseUrl/event/$id/summary')
          .replace(queryParameters: ({'date': date, 'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return EventSummary.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool> checkAndBookEvent(
      {required BuildContext context,
      required String paymentId,
      required String eventId,
      required double cost,
      required String dayId,
      required int person,
      required String date}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.post(
        Uri.parse("$baseUrl/event/booking/$eventId").replace(
          queryParameters: {'paymentId': paymentId, 'eventId': eventId},
        ),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'date': date.toString().substring(0, 10),
          'guestInfo': {
            'dayId': dayId.toString(),
            "guestNumber": person,
          },
          'cost': cost,
        }));
    log(response.statusCode.toString());
    log(response.body);
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

  static Future<UploadImage?> uploadImages(
      {required File file,
      required String fileType,
      required BuildContext context}) async {
    final getStorage = GetStorage();
    String? token = getStorage.read('accessToken');

    if (JwtDecoder.isExpired(token!)) {
      final String refreshToken = getStorage.read('refreshToken');
      var user = await AuthService.refreshToken(
          refreshToken: refreshToken, context: context);
      token = user!.accessToken;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/asset/upload/$fileType').replace(queryParameters: {
          'fileType': fileType,
        }));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    http.StreamedResponse response = await request.send();

    late String id, filePath, publicId;

    if (response.statusCode == 200) {
      // Read the full response as a string
      String responseBody = await response.stream.bytesToString();
      try {
        // Decode the JSON response
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        // Create an instance of UploadImage from the JSON data
        return UploadImage.fromJson(jsonResponse);
      } catch (e) {
        log('Error decoding JSON: $e');
        return null;
      }
    } else {
      log('Image upload failed with status: ${response.statusCode}');
    }

    return null;
  }
}
