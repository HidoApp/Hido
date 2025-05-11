import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/notification/notification.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class NotificationServices {
  static Future<String> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();
    log('token ${token ?? "EMpty Token"}');
    return token ?? "";
  }

// create Device
  static Future<bool> sendDeviceToken({required BuildContext context}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    var deviceToken = await getDeviceToken();
    final response = await http.post(Uri.parse('$baseUrl/device'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'deviceToken': deviceToken,
          'deviceType': Platform.operatingSystem.toUpperCase()
        }));
    log('deviceToken');

    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  static Future<List<Notifications>?> getNotifications(
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
      Uri.parse('$baseUrl/notification'),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );
    log("Noty");
    log(response.body.toString());
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      List<dynamic> data = jsonDecode(response.body);
      return data.map((noty) => Notifications.fromJson(noty)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<void> updateNotifications(
      {required BuildContext context,
      List<String>? unreadNotificationIds}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    if (unreadNotificationIds!.isNotEmpty) {
      // Log the exact JSON payload being sent to confirm it's correct
      final requestBody = {
        "ids": unreadNotificationIds, // Ensure this is a List<String>
      };
      log("Request Body: ${json.encode(requestBody)}");

      final response = await http.put(
        Uri.parse('$baseUrl/notification'),
        body: json.encode(requestBody),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        log("Status Code: ${response.statusCode}");
      } else {
        String errorMessage = jsonDecode(response.body)['message'];
        if (context.mounted) {
          AppUtil.errorToast(context, errorMessage);
        }
      }
    } else {
      log("No unread notifications to update.");
    }
  }
}
