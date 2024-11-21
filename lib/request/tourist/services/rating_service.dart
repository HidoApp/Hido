import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/request/tourist/models/rating.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class RatingService {
  static Future<List<Rating>?> getRtings(
      {required BuildContext context,
      required String profileId,
      String? ratingType}) async {
    //check token
    try {
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
        Uri.parse(
          "$baseUrl/rating/$profileId",
        ).replace(queryParameters: {
          'ratingType': ratingType,
        }),
        headers: {
          'Accept': 'application/json',
          if (token != '') 'Authorization': 'Bearer $token',
        },
      );
      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        List<dynamic> rating = jsonDecode(response.body);
        return rating.map((review) => Rating.fromJson(review)).toList();
      } else {
        String errorMessage = jsonDecode(response.body)['message'];
        log(errorMessage.toString());
        if (context.mounted) {
          AppUtil.errorToast(context, 'error');
        }
      }
    } catch (e) {
      // Handle exceptions
      log('Exception caught: $e');
      if (context.mounted) {
        AppUtil.errorToast(context, "An error occurred. Please try again.");
      }
      return null;
    }
  }

  static Future<bool> postRating({
    required BuildContext context,
    required String localId,
    required String bookingId,
    int? placeRate,
    int? localRate,
    String? placeReview,
    String? localReview,
  }) async {
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
    final response = await http.post(
        Uri.parse('$baseUrl/rating').replace(
          queryParameters: {
            "bookingId": bookingId,
            'localId': localId,
          },
        ),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rating': placeRate,
          "description": placeReview,
          "userRating": localRate,
          "userDescription": localReview
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
}
