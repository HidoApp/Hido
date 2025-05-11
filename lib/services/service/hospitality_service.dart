import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/model/payment.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/summary.dart';

class HospitalityService {
  static Future<List<Hospitality>?> getAllHospitality(
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
      Uri.parse('$baseUrl/hospitality')
          .replace(queryParameters: region != null ? {'region': region} : {}),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data.map((place) => Hospitality.fromJson(place)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log(errorMessage);
      return null;
    }
  }

  static Future<Hospitality?> getHospitalityById({
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
      Uri.parse('$baseUrl/hospitality/$id')
          .replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Hospitality.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool> checkAndBookHospitality({
    required BuildContext context,
    String? paymentId,
    String? couponId,
    required String hospitalityId,
    required String date,
    required String dayId,
    required int numOfMale,
    required int numOfFemale,
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

    Map<String, dynamic> queryParameters = {
      'hospitalityId': hospitalityId,
      if (paymentId != null) 'paymentId': paymentId,
      if (couponId != '') 'codeId': couponId
    };

    Map<String, dynamic> body = {
      'date': date.toString().substring(0, 10),
      'guestInfo': {
        'dayId': dayId.toString(),
        'male': numOfMale,
        'female': numOfFemale
      },
      // 'cost': cost,
    };

    final response = await http.post(
        Uri.parse('$baseUrl/hospitality/booking/$hospitalityId')
            .replace(queryParameters: queryParameters),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));
    log(response.statusCode.toString());
    log(response.body.toString());
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

  static Future<Payment?> hospitalityPayment({
    required BuildContext context,
    required String hospitalityId,
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

    Map<String, dynamic> queryParameters = {
      'id': hospitalityId,
    };
    final response = await http.get(
      Uri.parse('$baseUrl/payment/$hospitalityId')
          .replace(queryParameters: (queryParameters)),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return Payment.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<PaymentResult?> payWithCreditCard({
    required BuildContext context,
    required int amount,
    required String name,
    required String number,
    required String cvc,
    required String month,
    required String year,
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

    final response = await http.post(Uri.parse('$baseUrl/payment/credit-card'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "amount": amount,
          "name": name.trim(),
          "number": number.trim(),
          "cvc": cvc.trim(),
          "month": month.trim(),
          "year": year.trim(),
        }));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return PaymentResult.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool> createHospitality({
    required String titleAr,
    required String titleEn,
    required String bioAr,
    required String bioEn,
    required String mealTypeAr,
    required String mealTypeEn,
    required String longitude,
    required String latitude,
    required String touristsGender,
    required int price,
    required List<String> images,
    required String regionAr,
    required String location,
    required String regionEn,
    // required String start,
    // required String end,
    // required int seat,
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
      "titleAr": titleAr,
      "titleEn": titleEn,
      "bioAr": bioAr,
      "bioEn": titleEn,
      "mealTypeAr": mealTypeAr,
      "mealTypeEn": mealTypeEn,
      "coordinates": {"longitude": longitude, "latitude": latitude},
      // "daysInfo": [
      //   {"startTime": start, "endTime": end, "seats": seat}
      // ],
      "daysInfo": daysInfo,
      "touristsGender": touristsGender,
      "location": location,
      "price": price,
      "image": images,
      "regionAr": regionAr,
      "regionEn": regionEn,
    };

    final response = await http.post(Uri.parse('$baseUrl/hospitality'),
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
      String errorMessage = jsonDecode(response.body)['message'];
      log(errorMessage);

      if (context.mounted) {
        // AppUtil.errorToast(context, errorMessage);
      }
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

  static Future<bool> editHospitality({
    required String id,
    String? titleAr,
    String? titleEn,
    String? bioAr,
    String? bioEn,
    String? mealTypeAr,
    String? mealTypeEn,
    String? longitude,
    String? latitude,
    String? touristsGender,
    double? price,
    List<String>? images,
    String? regionAr,
    String? location,
    String? regionEn,
    required List<Map<String, dynamic>> daysInfo,

    // String? start,
    // String? end,
    // int? seat,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(
      Uri.parse('$baseUrl/hospitality/$id')
          .replace(queryParameters: ({'id': id})),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        if (titleAr != null) "titleAr": titleAr.trim(),
        if (titleEn != null) "titleEn": titleEn.trim(),
        if (bioAr != null) "bioAr": bioAr,
        if (bioEn != null) "bioEn": bioEn,
        if (mealTypeAr != null) "mealTypeAr": mealTypeAr,
        if (mealTypeEn != null) "mealTypeEn": mealTypeEn,
        if (longitude != null && latitude != null)
          "coordinates": {
            "longitude": longitude,
            "latitude": latitude,
          },
        "daysInfo": daysInfo,
        // if (start != null && end != null && seat != null)
        //   "daysInfo": [
        //     {
        //       "startTime": start,
        //       "endTime": end,
        //       "seats": seat,
        //     }
        //   ],
        if (touristsGender != null) "touristsGender": touristsGender,
        if (location != null) "location": location,
        if (price != null) "price": price,
        if (images != null && images.isNotEmpty) "image": images,
        if (regionAr != null) "regionAr": regionAr,
        if (regionEn != null) "regionEn": regionEn,
      }),
    );
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      try {
        // var hospitalityData = jsonDecode(response.body);

        return true;
      } catch (e) {
        return false;
      }
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<List<Hospitality>?> getUserTicket({
    required String hostType,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/hospitality/local').replace(queryParameters: {
        'hostType': hostType,
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

      return data
          .map((hospitality) => Hospitality.fromJson(hospitality))
          .toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Summary?> getHospitalitySummaryById({
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
      Uri.parse('$baseUrl/hospitality/$id/summary')
          .replace(queryParameters: ({'date': date, 'id': id})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Summary.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool?> hospitalityDelete(
      {required BuildContext context, required String hospitalityId}) async {
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
      Uri.parse('$baseUrl/hospitality/$hospitalityId'),
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
//     static Future<bool> createHospitality({
//   required String titleAr,
//   required String titleEn,
//   required String bioAr,
//   required String bioEn,
//   required String mealTypeAr,
//   required String mealTypeEn,
//   required String longitude,
//   required String latitude,
//   required String touristsGender,
//   required double price,
//   required List<String> images,
//   required String regionAr,
//   required String location,
//   required String regionEn,
//   required String start,
//   required String end,
//   required int seat,
//   required BuildContext context,
// }) async {
//   final getStorage = GetStorage();
//   String token = getStorage.read('accessToken') ?? "";

//   if (JwtDecoder.isExpired(token)) {
//     final _authController = Get.put(AuthController());
//     String refreshToken = getStorage.read('refreshToken') ?? "";
//     var user = await _authController.refreshToken(
//       refreshToken: refreshToken,
//       context: context,
//     );
//     token = getStorage.read('accessToken') ?? "";
//   }

//   Map<String, dynamic> body = {
//     "titleAr": titleAr,
//     "titleEn": titleEn,
//     "bioAr": bioAr,
//     "bioEn": bioEn,
//     "mealTypeAr": mealTypeAr,
//     "mealTypeEn": mealTypeEn,
//     "coordinates": {"longitude": longitude, "latitude": latitude},
//     "daysInfo": [
//       {
//         "startTime": start,
//         "endTime": end,
//         "seats": seat
//       }
//     ],
//     "touristsGender": touristsGender,
//     "location": location,
//     "price": price,
//     "image": images,
//     "regionAr": "Riyadh",
//     "regionEn": "الرياض",
//   };

//   try {
//     final response = await http.post(
//       Uri.parse('$baseUrl/hospitality'),
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(body),
//     );

//
//

//     if (response.statusCode == 200) {
//       if (response.body.isNotEmpty) {
//         var data = jsonDecode(response.body);
//
//         if (data['message'] == 'checked') {
//           return true;
//         } else {
//           return false; // Check why this condition fails
//         }
//       } else {
//
//         return false;
//       }
//     } else {
//       String errorMessage = jsonDecode(response.body)['message'];
//
//       if (context.mounted) {
//         AppUtil.errorToast(context, errorMessage);
//       }
//       return false;
//     }
//   } catch (e) {
//
//     return false;
//   }
// }
  static Future<UploadImage?> uploadProfileImages(
      {required File file,
      required String uploadOrUpdate,
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
        'POST', Uri.parse('$baseUrl/asset/$uploadOrUpdate/hospitality'));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    http.StreamedResponse response = await request.send();

    late String id, filePath, publicId;
    if (response.statusCode == 200) {
      UploadImage imageIbject;
      var jsonImage;

      response.stream.transform(utf8.decoder).listen((value) {
        id = UploadImage.fromJson(jsonDecode(value)).id;
        filePath = UploadImage.fromJson(jsonDecode(value)).filePath;
        if (UploadImage.fromJson(jsonDecode(value)).publicId != null) {
          publicId = UploadImage.fromJson(jsonDecode(value)).publicId!;
        } else {
          publicId = '';
        }
      });

      return UploadImage(id: id, filePath: filePath, publicId: publicId);
    } else {
      response.stream.transform(utf8.decoder).listen((value) {});
    }
    return null;
  }
}
