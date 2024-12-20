import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/accepted_offer.dart';
import '../models/offer.dart';
import '../models/schedule.dart';

class OfferService {
  static Future<List<Offer>?> getOffers({
    required BuildContext context,
    required String placeId,
    required String bookingId,
  }) async {
    //
    // final getStorage = GetStorage();
    // String token = getStorage.read('accessToken');
    //
    //
    // if (JwtDecoder.isExpired(token)) {
    //   final authController = Get.put(AuthController());

    //   String refreshToken = getStorage.read('refreshToken');
    //   await authController.refreshToken(
    //       refreshToken: refreshToken, context: context);
    //   token = getStorage.read('accessToken');
    //   // jwtToken = await AuthService.jwtForToken(refreshToken)!;
    // }
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
      Uri.parse('$baseUrl/offer/$placeId/$bookingId'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> offers = jsonDecode(response.body);

      return offers.map((offer) => Offer.fromJson(offer)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<OfferDetails?> getOfferById({
    required BuildContext context,
    required String offerId,
  }) async {
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
      Uri.parse('$baseUrl/offer/$offerId'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var offerDetails = jsonDecode(response.body);

      return OfferDetails.fromJson(offerDetails);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<AcceptedOffer?> acceptOffer({
    required BuildContext context,
    required String offerId,
    String? invoiceId,
    String? couponId,
    required List<Schedule> schedules,
  }) async {
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
      Uri.parse('$baseUrl/offer/$offerId/accept').replace(
        queryParameters: {
          if (invoiceId != "") 'paymentId': invoiceId,
          'offerId': offerId,
          if (couponId != '') 'codeId': couponId
        },
      ),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'schedule': schedules,
      }),
    );

    if (response.statusCode == 200) {
      var acceptedOfferData = jsonDecode(response.body);

      AcceptedOffer acceptedOffer = AcceptedOffer.fromJson(acceptedOfferData);
      String? userId = acceptedOffer.userId;
      final getStorage = GetStorage();
      await getStorage.remove('userId');
      await getStorage.write('userId', userId);
      log("userId ${getStorage.read('userId')}");
      return acceptedOffer;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* 
  ? bookingCancel
   */

  static Future<bool?> bookingCancel(
      {required BuildContext context,
      required String bookingId,
      required String type,
      required String reason}) async {
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
    log(reason);
    log(type);

    Map<String, dynamic> body = {"reason": reason};

    log(reason);
    log(type);

    //
    final response = await http.post(
        Uri.parse('$baseUrl/booking/cancel/$bookingId')
            .replace(queryParameters: {
          'type': type,
        }),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('inter 200');
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      // if (context.mounted) {
      //   AppUtil.errorToast(context, errorMessage);
      // }
      return false;
    }
  }
}
