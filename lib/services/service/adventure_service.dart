import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/adventure_summary.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class AdventureService {
  static Future<List<Adventure>?> getAdvdentureList(
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
      Uri.parse('$baseUrl/adventure')
          .replace(queryParameters: region != null ? {'region': region} : {}),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      final adventureList =
          data.map((adventure) => Adventure.fromJson(adventure)).toList();

      return adventureList;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log(errorMessage);

      return null;
    }
  }

  static Future<Adventure?> getAdvdentureById({
    required BuildContext context,
    required String id,
  }) async {
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
      Uri.parse('$baseUrl/adventure/$id')
          .replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Adventure.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool> checkAdventureBooking(
      {required BuildContext context,
      required String adventureID,
      required String dayId,
      required String date,
      String? invoiceId,
      String? couponId,
      required int personNumber}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    Map<String, dynamic> queryParameters = {
      if (invoiceId != '') 'paymentId': invoiceId,
      'adventureId': adventureID,
      if (couponId != '') 'codeId': couponId
    };
    log('COupon id');
    log(couponId ?? "No Coupon");
    final response = await http.post(
        Uri.parse('$baseUrl/adventure/booking/$adventureID')
            .replace(queryParameters: queryParameters),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'date': date.toString().substring(0, 10),
          'guestInfo': {
            'dayId': dayId.toString(),
            "guestNumber": personNumber,
          },
        }));
    log('status book adv');
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['orderStatus'];

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<bool> createAdventure({
    required String nameAr,
    required String nameEn,
    required String nameZh,
    required String descriptionAr,
    required String descriptionEn,
    required String descriptionZh,
    required String longitude,
    required String latitude,
    //required String date,
    required int price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    // required List<Map<String, dynamic>> times,
    // required String start,
    // required String end,
    required int seat,
    required List<Map<String, dynamic>> daysInfo,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    Map<String, dynamic> body = {
      "nameAr": nameAr,
      "nameEn": nameEn,
      "nameZh": nameZh,
      "descriptionAr": descriptionAr,
      "descriptionEn": descriptionEn,
      "descriptionZh": descriptionZh,
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
      "adventureGenre": "string",
    };
    log("before Create");
    final response = await http.post(Uri.parse('$baseUrl/adventure'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));

    //
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      //  var data = jsonDecode(response.body);
      //
      //  if (data['message'] == 'checked') {
      return true;
    } else {
      return false;
    }
    //   } else {
    //     String errorMessage = jsonDecode(response.body)['message'];
    //
    //     if (context.mounted) {
    //       AppUtil.errorToast(context, errorMessage);
    //   }
    //     return false;
    //  }
  }

  static Future<Adventure?> editAdventure({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String longitude,
    required String latitude,
    required int price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    String? Genre,
    required List<Map<String, dynamic>> daysInfo,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(
      Uri.parse('$baseUrl/adventure/$id')
          .replace(queryParameters: ({'id': id})),
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
        "daysInfo": daysInfo,
        "coordinates": {"longitude": longitude, "latitude": latitude},
        "locationUrl": locationUrl,
        "regionAr": regionAr,
        "regionEn": regionEn,
        "adventureGenre": Genre,
      }),
    );
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      try {
        var adventureData = jsonDecode(response.body);

        return Adventure.fromJson(adventureData);
      } catch (e) {
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

  static Future<bool?> AdventureDelete(
      {required BuildContext context, required String adventureId}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/adventure/$adventureId'),
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

  static Future<List<Adventure>?> getUserTicket({
    required String adventureType,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/adventure/local').replace(queryParameters: {
        'adventureType': adventureType,
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

      return data.map((adventure) => Adventure.fromJson(adventure)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<AdventureSummary?> getAdventureSummaryById({
    required BuildContext context,
    required String id,
    required String date,
  }) async {
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
      Uri.parse('$baseUrl/adventure/$id/summary')
          .replace(queryParameters: ({'date': date, 'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return AdventureSummary.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
