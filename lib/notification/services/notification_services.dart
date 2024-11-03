import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  static Future<String> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();
    log(token ?? "EMpty Token");
    return token ?? "";
  }
// create Device
  static Future<bool> sendDeviceToken({required BuildContext context}) async {
    var deviceToken = await getDeviceToken();
    final response = await http.post(Uri.parse('$baseUrl/device'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'device_token': deviceToken,
          'device_type': Platform.operatingSystem.toUpperCase()
        }));
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
}
