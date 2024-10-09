import 'package:ajwad_v4/payment/model/coupon.dart';
import 'package:ajwad_v4/payment/model/credit_card.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/payment/service/coupon_service.dart';

import 'package:ajwad_v4/payment/service/payment_service.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var isCreditCardPaymentLoading = false.obs;
  var isPaymenInvoiceLoading = false.obs;
  var isPaymenInvoiceByIdLoading = false.obs;
  var isPaymentGatewayLoading = false.obs;
  var isApplePayEmbeddedLoading = false.obs;
  var isApplePayExecuteLoading = false.obs;
  var isCouponByCodeLoading = false.obs;

  var showCvv = false.obs;
  var isNameValid = true.obs;
  var isCardNumberValid = true.obs;
  var isCvvValid = true.obs;
  var isDateValid = true.obs;

  var isApplied = false.obs;
  var validateType = ''.obs;
  var finalPrice = 0.obs;
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

      return data;
    } catch (e) {
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

      return data;
    } catch (e) {
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

  Future<Invoice?> applePayEmbedded(
      {required BuildContext context, required int invoiceValue}) async {
    try {
      isApplePayEmbeddedLoading(true);

      final data = await PaymentService.applePayEmbedded(
          context: context, invoiceValue: invoiceValue);
      return data;
    } catch (e) {
      isApplePayEmbeddedLoading(false);
      return null;
    } finally {
      isApplePayEmbeddedLoading(false);
    }
  }

  Future<Invoice?> applePayEmbeddedExecute(
      {required BuildContext context,
      required int invoiceValue,
      required String sessionId}) async {
    try {
      isApplePayExecuteLoading(true);

      final data = await PaymentService.applePayEmbeddedExecute(
          context: context, invoiceValue: invoiceValue, sessionId: sessionId);
      return data;
    } catch (e) {
      isApplePayExecuteLoading(false);
      return null;
    } finally {
      isApplePayExecuteLoading(false);
    }
  }

  Future<Invoice?> creditCardEmbedded({
    required BuildContext context,
    required int price,
  }) async {
    try {
      isCreditCardPaymentLoading(true);
      final data = await PaymentService.creditCardEmbedded(
          context: context, price: price);
      return data;
    } catch (e) {
      isCreditCardPaymentLoading(false);
      return null;
    } finally {
      isCreditCardPaymentLoading(false);
    }
  }

  Future<Coupon?> getCouponByCode(
      {required BuildContext context,
      required String code,
      required String type}) async {
    try {
      isCouponByCodeLoading(true);
      final coupon = await CouponService.getCouponByCode(
          context: context, code: code, type: type);
      if (coupon != null) {
        return coupon;
      }
    } catch (e) {
      isCouponByCodeLoading(false);
      return null;
    } finally {
      isCouponByCodeLoading(false);
    }
  }
}
