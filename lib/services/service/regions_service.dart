import 'dart:convert';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/services/model/regions.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class RegionsServices {
  static Future<Regions?> getRegions(
      {required BuildContext context, required String regionType}) async {
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
      Uri.parse('$baseUrl/regions')
          .replace(queryParameters: ({'regionType': regionType})),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );
    // log("response.statusCode REGIONS");
    // log("${response.statusCode}");
    // log('${response.body}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Regions.fromJson(data);
    } else {
      AppUtil.errorToast(context, "Cannot get regions");
      return null;
    }
  }
}
