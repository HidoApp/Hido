import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/request/tourist/models/rating.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class RatingService {
  static Future<List<Rating>?> getRtings(
      {required BuildContext context, required String profileId}) async {
    //check token
    log("jwtToken");
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
    log('isExpired');
    log(JwtDecoder.isExpired(token).toString());
    if (JwtDecoder.isExpired(token)) {
      String refreshToken = getStorage.read('refreshToken');
      User? user = await AuthService.refreshToken(
          refreshToken: refreshToken, context: context);
      if (user != null) {
        final Token jwtToken = AuthService.jwtForToken(user.refreshToken)!;
        log(jwtToken.id);
        token = jwtToken.id;
      }
    }
    final response = await http.get(
      Uri.parse(
        "$baseUrl/rating/$profileId",
      ),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> rating = jsonDecode(response.body);
      return rating.map((review) => Rating.fromJson(review)).toList();
    } else {
      // String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, "errorMessage");
      }
      return null;
    }
  }
}
