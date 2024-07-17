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
      print('this from adventure');
      return adventureList;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
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
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
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
      String? invoiceId,
      required int personNumber}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    Map<String, dynamic> queryParameters = {
      'paymentId': invoiceId,
      'adventureId': adventureID,
    };
    final response = await http.post(
        Uri.parse('$baseUrl/adventure/booking/$adventureID')
            .replace(queryParameters: queryParameters),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'guestNumber': personNumber}));
    log('status book adv');
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('adventure data');
      print(response.body);
      print(data['orderStatus']);
      if (data['orderStatus'] == 'checked') {
        return true;
      } else {
        print('adventure data');
        print(response.body);
        print(data['orderStatus']);
        return false;
      }
    } else {
      String errorMessage = jsonDecode(response.body)['orderStatus'];
      print(errorMessage);
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<bool> createAdventure({
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
    required String start,
    required String end,
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
      "times": [
        {
          "startTime": start,
          "endTime": end,
        }
      ],
      "locationUrl": locationUrl,
      "regionAr": regionAr,
      "regionEn": regionEn,
      "adventureGenre": "string",
      "seats": seat
    };
    print(body);
    final response = await http.post(Uri.parse('$baseUrl/adventure'),
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
    } else {
      return false;
    }
    //   } else {
    //     String errorMessage = jsonDecode(response.body)['message'];
    //     print(errorMessage);
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
    required String date,
    required int price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    String?Genre,
    // required List<Map<String, dynamic>> times,
    required String start,
    required String end,
    required int seat,
    required BuildContext context,
  }) async {
    print(" Update adventure ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(  Uri.parse('$baseUrl/adventure/$id')
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
      "date": date,
      "coordinates": {
        "longitude": longitude,
        "latitude": latitude
      },
      "times": [
        {
          "startTime": start,
          "endTime": end
        }
      ],
      "locationUrl": locationUrl,
      "regionAr": regionAr,
      "regionEn": regionEn,
      "seats": seat,
      "adventureGenre": Genre,
    }),
  );
  

print("Response status code: ${response.statusCode}");

  if (response.statusCode == 200) {
    try {
      var adventureData = jsonDecode(response.body);
      print('Hospitality updated: $adventureData');
      return Adventure.fromJson(adventureData);
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

static Future<bool?>  AdventureDelete(
      {required BuildContext context, required String adventureId}) async {
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
      Uri.parse('$baseUrl/adventure/$adventureId'),
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




   static Future<List<Adventure>?> getUserTicket({
    required String adventureType,
    required BuildContext context,

  }) async {
    print(" getUpcomingTicket ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');
    print(token);

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

    print("response.statusCode  ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      log('data: $data');
      print(data.length);
      print(data.isEmpty);
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
      Uri.parse('$baseUrl/adventure/$id/summary')
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
