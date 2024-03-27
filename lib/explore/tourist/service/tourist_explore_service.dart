import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/model/tourist_map_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class TouristExploreService {
  static Future<List<Place>?> getAllPlaces({
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
      // jwtToken = await AuthService.jwtForToken(refreshToken)!;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/place'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("response.statusCode");
    print(response.statusCode);
    print(jsonDecode(response.body).length);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((place) => Place.fromJson(place)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Place?> getPlaceById({
    required String id,
    required BuildContext context,
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
      Uri.parse('$baseUrl/place/$id'),
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Place.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool> bookPlace({
    required String placeId,
    required String timeToGo,
    required String timeToReturn,
    required String date,
    required int guestNumber,
    required int cost,
    required String lng,
    required String lat,
    required String vehicle,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    print(token);
    print("jwtToken");

    print('isExpired');
    print(JwtDecoder.isExpired(token));
    if (JwtDecoder.isExpired(token)) {
      String refreshToken = getStorage.read('refreshToken');
      final Token jwtToken = await AuthService.jwtForToken(refreshToken)!;
      print(jwtToken.id);
      token = jwtToken.id;
    }
    final response =
        await http.post(Uri.parse('$baseUrl/place/booking/$placeId'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              "timeToGo": timeToGo,
              "timeToReturn": timeToReturn,
              "date": date,
              "guestNumber": guestNumber,
              "coordinates": {"longitude": lng, "latitude": lat},
              "cost": cost,
              "vehicleType": vehicle,
            }));
    print("response.statusCode");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<List<Booking>?> getTouristBooking({
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

    final queryParameters = {
      'bookingType': 'UPCOMING',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/booking').replace(queryParameters: queryParameters),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(inspect(data));
      return data.map((booking) => Booking.fromJson(booking)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Booking?> getTouristBookingById({
    required BuildContext context,
    required String bookingId,
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

    final response = await http.get(
      Uri.parse('$baseUrl/booking/$bookingId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(inspect(data));
      return Booking.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<TouristMapModel?> touristMap({
    required BuildContext context,
    required String tourType,
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

    final queryParameters = {
      'tourType': tourType,
    };
    final response = await http.get(
      Uri.parse('$baseUrl/homepage/tourist')
          .replace(queryParameters: queryParameters),
      headers: {
        'Accept': 'application/json',
        //  if(token != '') 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return TouristMapModel.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
