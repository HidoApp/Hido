import 'dart:developer';

import 'package:ajwad_v4/payment/model/credit_card.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';

import 'package:ajwad_v4/payment/service/payment_service.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';

class PaymentController extends GetxController {
  var isCreditCardPaymentLoading = false.obs;
  var isPaymenInvoiceLoading = false.obs;
  var isPaymenInvoiceByIdLoading = false.obs;
  var isPaymentGatewayLoading = false.obs;
  // var PaymentResult = false.obs;
  //credit card controllers
  var showCvv = false.obs;
  var isNameValid = true.obs;
  var isCardNumberValid = true.obs;
  var isCvvValid = true.obs;
  var isDateValid = true.obs;

  Future<PaymentResult?> payWithCreditCard({
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
    {
      try {
        isCreditCardPaymentLoading(true);
        final data = PaymentService.payWithCreditCard(
            context: context,
            requestId: requestId,
            offerId: offerId,
            amount: amount,
            name: name,
            number: number,
            cvc: cvc,
            month: month,
            year: year,
            schedule: schedule);
        return data;
      } catch (e) {
        print(e);
        return null;
      } finally {
        isCreditCardPaymentLoading(false);
      }
    }
  }

  Future<Invoice?> paymentInvoice({
    required BuildContext context,
    //required String description,
    // required int amount,
    required int InvoiceValue,
  }) async {
    try {
      isPaymenInvoiceLoading(true);
      final data = await PaymentService.paymentInvoice(
        context: context,
        //description: description,
        InvoiceValue: InvoiceValue,
      );
      print("this is invo from contr");
      print(InvoiceValue);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isPaymenInvoiceLoading(false);
    }
  }

  Future<Invoice?> paymentGateway({
    required BuildContext context,
    required String language,
    required String paymentMethod,
    required int price,
  }) async {
    try {
      isPaymentGatewayLoading(true);
      final data = await PaymentService.paymentGateway(
          context: context,
          language: language,
          paymentMethod: paymentMethod,
          price: price);
      print("this is invo from serv2");
      print(data);
      return data;
    } catch (e) {
      isPaymentGatewayLoading(false);
      AppUtil.errorToast(context, e.toString());
      return null;
    } finally {
      isPaymentGatewayLoading(false);
    }
  }

  Future<Invoice?> creditCardPayment(
      {required BuildContext context,
      required int invoiceValue,
      required CreditCard creditCard}) async {
    try {
      isCreditCardPaymentLoading(true);
      final data = await PaymentService.creditCardPayment(
          context: context, invoiceValue: invoiceValue, creditCard: creditCard);
      return data;
    } catch (e) {
      isCreditCardPaymentLoading(false);
      return null;
    } finally {
      isCreditCardPaymentLoading(false);
    }
  }

  Future<Invoice?> paymentInvoiceById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isPaymenInvoiceByIdLoading(true);
      final data =
          await PaymentService.paymentInvoiceById(context: context, id: id);
      print("this is pay from controller");
      print(data);
      return data;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isPaymenInvoiceByIdLoading(false);
    }
  }

  Future<Invoice?> getPaymentId(
      {required BuildContext context, required String id}) async {
    try {
      isPaymenInvoiceByIdLoading(true);
      final data = await PaymentService.getPaymentId(context: context, id: id);
      return data;
    } catch (e) {
      isPaymenInvoiceByIdLoading(false);
      return null;
    } finally {
      isPaymenInvoiceByIdLoading(false);
    }
  }
}
