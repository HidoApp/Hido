import 'dart:convert';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static Future<PaymentResult?> payWithCreditCard({
    required BuildContext context,
    required String requestId,
    required String offerId,
    required int amount,
    required String name,
    required String number,
    required String cvc,
    required String month,
    required String year,
        required  List<Schedule>? schedule,
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

    print(requestId);
    print(offerId);

    final response = await http.post(
        Uri.parse('$baseUrl/payment/credit-card/$requestId/$offerId'),
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
          "schedule": schedule,
        }));
    print("response.statusCode");
    print(response.statusCode);
    print(response.body);


    print(jsonDecode(response.body).length);
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
}
