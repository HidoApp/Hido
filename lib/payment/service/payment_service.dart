import 'dart:convert';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
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
    required List<Schedule>? schedule,
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

  static Future<Invoice?> paymentInvoice({
    required BuildContext context,
    // required String description,
    // required int amount,
    required int InvoiceValue,
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

    final response = await http.post(
        // Uri.parse('$baseUrl/payment/invoice'),
        Uri.parse('$baseUrl/payment/myfatoorah/invoice'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: json.encode({
        //   "amount": amount,
        //   "description": description.trim(),
        // })

        body: json.encode({
          "InvoiceValue": InvoiceValue,
        }));
    print("this is invo from serv");
    print(InvoiceValue);
    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print(jsonDecode(response.body).length);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print("this is invo from serv2");

      print(data.isEmpty);
      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Invoice?> paymentGateway(
      {required BuildContext context,
      required String language,
      required String paymentMethod}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());
      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
  }

  static Future<Invoice?> paymentInvoiceById({
    required BuildContext context,
    required String id,
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

    final response = await http.get(
      Uri.parse('$baseUrl/payment/invoice/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print("this is pay from serv");
    print(jsonDecode(response.body).length);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print("this is pay from serv");
      print(data.isEmpty);
      print(Invoice.fromJson(data).invoiceStatus);
      print(Invoice.fromJson(data).message);
      print(Invoice.fromJson(data));

      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
