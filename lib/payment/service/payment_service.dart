import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/payment/model/credit_card.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
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

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Invoice?> creditCardPayment(
      {required BuildContext context,
      required int invoiceValue,
      required CreditCard creditCard}) async {
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
      Uri.parse("$baseUrl/payment/myfatoorah/direct/credit-card"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          'InvoiceValue': invoiceValue,
          'card': {
            'name': creditCard.name,
            'number': creditCard.number,
            'cvc': creditCard.cvc,
            'month': creditCard.month,
            'year': creditCard.year,
          },
        },
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      log("Credit Response");
      log(response.statusCode.toString());
      log(response.body);
      return Invoice.fromJson(data);
    } else {
      log("Credit faild ");
      log(response.statusCode.toString());
      log(response.body);
      String errorMessage = jsonDecode(response.body)['Message'];

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Invoice?> paymentGateway({
    required BuildContext context,
    required String language,
    required String paymentMethod,
    required int price,
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
      Uri.parse(
        "$baseUrl/payment/myfatoorah/gateway",
      ).replace(queryParameters: {
        'language': language,
        'paymentMethod': paymentMethod
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "InvoiceValue": price,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Invoice?> creditCardEmbedded({
    required BuildContext context,
    required int price,
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
      Uri.parse(
        "$baseUrl/payment/myfatoorah/embedded/credit",
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "InvoiceValue": price,
      }),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
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
      Uri.parse('$baseUrl/payment/invoice/$id')
          .replace(queryParameters: {'id': id}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Invoice?> getPaymentId(
      {required BuildContext context, required String id}) async {
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
      Uri.parse(
        '$baseUrl/payment/$id',
      ).replace(
        queryParameters: {
          'id': id,
        },
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      // if (context.mounted) {
      //   AppUtil.errorToast(context, errorMessage);
      // }
      return null;
    }
  }

  static Future<Invoice?> applePayEmbedded(
      {required BuildContext context, required int invoiceValue}) async {
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
      Uri.parse('$baseUrl/payment/myfatoorah/embedded/apple'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "InvoiceValue": invoiceValue,
        },
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      log(response.body);
      return Invoice.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<Invoice?> applePayEmbeddedExecute(
      {required BuildContext context,
      required int invoiceValue,
      required String sessionId}) async {
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
      Uri.parse('$baseUrl/payment/myfatoorah/embedded/apple/execute'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "invoiceValue": invoiceValue,
          'sessionId': sessionId,
        },
      ),
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

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
