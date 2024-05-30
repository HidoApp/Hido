import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';

import 'package:ajwad_v4/payment/service/payment_service.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var isCreditCardPaymentLoading = false.obs;
  var isPaymenInvoiceLoading = false.obs;
  var isPaymenInvoiceByIdLoading = false.obs;
  // var PaymentResult = false.obs;

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
      final data = PaymentService.paymentInvoice(
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


  Future<Invoice?> paymentInvoiceById({
    required BuildContext context,
    required String id,
  }) async {
        try {
      isPaymenInvoiceByIdLoading(true);
      final data = PaymentService.paymentInvoiceById(
        context: context,
        id: id
      );
      print("this is pay from controller");
      return data;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isPaymenInvoiceByIdLoading(false);
    }
  }
}
