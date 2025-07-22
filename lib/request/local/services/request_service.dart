import 'dart:convert';
import 'dart:developer';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/request/local/models/request_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../auth/models/user.dart';

class RequestService {
  /* ?
            ? getRequestList 
  */

  static Future<List<RequestModel>?> getRequestList(
      {required BuildContext context}) async {
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
      Uri.parse('$baseUrl/request'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log("Data$data");

      List requestListData = data;
      List<RequestModel>? requestList;
      if (requestListData.isNotEmpty) {
        requestList = [];
        for (var request in requestListData) {
          requestList.add(RequestModel.fromJson(request));
        }
      }

      return requestList;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log("errorMessage $errorMessage");
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Booking?> getBookingById(
      {required BuildContext context, required String bookingId}) async {
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
      Uri.parse('$baseUrl/booking/$bookingId'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    log("response.statusCode");
    log(response.statusCode.toString());
    log(response.body.toString());

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Booking.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log("errorMessage $errorMessage");
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* ?
            ? requestAccept 
  */

  static Future<bool?> requestAccept({
    required String id,
    required List<RequestSchedule> requestScheduleList,
    required BuildContext context,
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
    List scheduleTemp = [];
    log("requestScheduleList ON Service$requestScheduleList");

    Map<String, dynamic> bodyData = {"schedule": []};
    for (var schedule in requestScheduleList) {
      scheduleTemp.add({
        "scheduleName": schedule.scheduleName,
        "scheduleTime": {
          "from": schedule.scheduleTime!.from!,
          "to": schedule.scheduleTime!.to!
        },
        "price": schedule.price,
        "userAgreed": schedule.userAgreed ?? true
      });
    }
    log("scheduleTemp $scheduleTemp");
    bodyData['schedule'] = scheduleTemp;
    log("bodyData $bodyData");
    final response = await http.post(Uri.parse('$baseUrl/request/$id/accept'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(bodyData));

    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log("errorMessage $errorMessage");
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* ?
            ? requestReject 
  */

  static Future<bool?> requestReject({
    required String id,
    required BuildContext context,
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
      Uri.parse('$baseUrl/request/$id/reject'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* ?
            ? getRequestById 
  */

  static Future<RequestModel?> getRequestById({
    required String requestId,
    required BuildContext context,
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
      Uri.parse('$baseUrl/request/$requestId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      log("Get Request By Id");
      log(data.toString());
      RequestModel requestModel = RequestModel.fromJson(data);
      log(requestModel.name.toString());
      return requestModel;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* ?
            ? requestEnd
  */

  static Future<bool?> requestEnd({
    required String id,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
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
      Uri.parse('$baseUrl/request/end/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("enter");
      // if (context.mounted) {
      //   AppUtil.successToast(context, 'EndRound'.tr);
      // }
      // await Future.delayed(const Duration(seconds: 1));
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
