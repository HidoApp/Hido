import 'dart:convert';
import 'dart:io';
import 'dart:developer'; //(auto import will do this even)

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/explore/tourist/model/activity_progress.dart';

import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileService {
  static Future<Profile?> getProfile(
      {required BuildContext context, String profileId = ""}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
    late Token jwtToken;
    late String id;

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      refreshToken = getStorage.read('refreshToken');
      token = getStorage.read('accessToken');
      jwtToken = AuthService.jwtForToken(refreshToken)!;
      //
      id = jwtToken.id;
    } else {
      jwtToken = AuthService.jwtForToken(token)!;
      //

      id = jwtToken.id;
    }
    log("ID :$id");
    log("Profile :$profileId");
    if (profileId != "") {
      id = profileId;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile/$id'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log(response.body.toString());
      var profile = jsonDecode(response.body);

      return Profile.fromJson(profile);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

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
        'POST', Uri.parse('$baseUrl/asset/$uploadOrUpdate/profile'));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    http.StreamedResponse response = await request.send();
    log(response.statusCode.toString());

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

  static Future<Profile?> editProfile({
    String? name,
    String? profileImage,
    String? descripttion,
    String? iban,
    String? nationality,
    List<String>? spokenLanguage,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(Uri.parse('$baseUrl/profile'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          if (nationality != null) "nationality": nationality,
          if (name != null) "name": name.trim(),
          if (profileImage != null && profileImage.isNotEmpty)
            "image": profileImage,
          if (descripttion != null) "descriptionAboutMe": descripttion.trim(),
          "userInterest": ["string"],
          if (spokenLanguage != null) "spokenLanguage": spokenLanguage,
          if (iban != null) "iban": iban.trim(),
          "gender": "MALE",
        }));

    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      var profile = jsonDecode(response.body);

      return Profile.fromJson(profile);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<List<Booking>?> getUserTicket({
    required String bookingType,
    required BuildContext context,
  }) async {
    log(" getUpcomingTicket ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/booking').replace(queryParameters: {
        'bookingType': bookingType,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      //log(response.body);
      List<dynamic> data = jsonDecode(response.body);
      log('upcomong');
      return data.map((booking) => Booking.fromJson(booking)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<List<ChatModel>?> getUserChats({
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/chat'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data.map((chat) => ChatModel.fromJson(chat)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

// otp for update phone number
  static Future<bool> otpForMobile({
    required BuildContext context,
    required String mobile,
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
    final response = await http.post(Uri.parse("$baseUrl/otp/mobile"),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "mobile": mobile.substring(1),
        }));
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      if (errorMessage == "Replace the used number with another one.") {
        AppUtil.errorToast(context, 'ReplaceError'.tr);
      } else if (errorMessage == 'Forbidden') {
        AppUtil.errorToast(context, 'otpForbidden'.tr);
      } else {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<Profile?> updateMobile({
    required BuildContext context,
    required String otp,
    required String mobile,
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
    final response = await http.put(
      Uri.parse("$baseUrl/profile/mobile"),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          'otp': otp,
          'mobile': mobile.substring(1),
        },
      ),
    );
    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 200) {
      var profile = jsonDecode(response.body);
      return Profile.fromJson(profile);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        if (errorMessage == 'this otp for this user is wrong') {
          AppUtil.errorToast(context, 'phoneOtpWrong'.tr);
        } else {
          AppUtil.errorToast(context, errorMessage);
        }
      }
      return null;
    }
  }

  static Future<List<ActivityProgress>?> getAllActions(
      {required BuildContext context}) async {
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
      Uri.parse('$baseUrl/user/actions'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    log('actions');
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      final actionsList =
          data.map((action) => ActivityProgress.fromJson(action)).toList();
      return actionsList;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log(errorMessage);
      return null;
    }
  }

  static Future<bool> updateUserAction(
      {required BuildContext context, required String id}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/user/action/$id'),
      headers: {
        'Accept': 'application/json',
        // "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    log('actions update');
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log(errorMessage);
      return false;
    }
  }
}
