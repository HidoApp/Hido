import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewHospitalty extends StatefulWidget {
  const ReviewHospitalty(
      {super.key,
      required this.hospitality,
      required this.maleGuestNum,
      required this.femaleGuestNum,
      required this.servicesController});
  final Hospitality hospitality;
  final int maleGuestNum;
  final int femaleGuestNum;
  final HospitalityController servicesController;

  @override
  State<ReviewHospitalty> createState() => _ReviewHospitaltyState();
}

class _ReviewHospitaltyState extends State<ReviewHospitalty> {
  Invoice? invoice;
  bool isCheckingForPayment = false;

  PaymentController paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: null);
  }
}
             









// Obx(
//           () => widget.servicesController.isCheckAndBookLoading.value ||
//                   paymentController.isPaymenInvoiceLoading.value
//               ? const Center(child: CircularProgressIndicator())
//               : CustomButton(
//                   onPressed: (() async {
//                     final isSuccess = await widget.servicesController
//                         .checkAndBookHospitality(
//                             context: context,
//                             check: false,
//                             hospitalityId: widget.hospitality!.id,
//                             date: widget.servicesController.selectedDate.value,

//                             //   '${widget.hospitality!.daysInfo[widget.serviceController.selectedDateIndex.value].startTime.substring(11)}',
//                             dayId: widget
//                                 .hospitality!
//                                 .daysInfo[widget
//                                     .servicesController.selectedDateIndex.value]
//                                 .id,
//                             numOfMale: widget.maleGuestNum,
//                             numOfFemale: widget.femaleGuestNum,
//                             cost: (widget.hospitality!.price *
//                                 (widget.maleGuestNum + widget.maleGuestNum)));

//                     print("isSuccess : $isSuccess");

//                     if (isSuccess) {
//                       print("invoice != null");
//                       print(invoice != null);

//                       invoice ??= await paymentController.paymentInvoice(
//                           context: context,
//                           description: 'DESCRIPTION',
//                           amount: (widget.hospitality!.price *
//                               (widget.maleGuestNum + widget.maleGuestNum)));
//                       if (invoice != null) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => PaymentWebView(
//                                     url: invoice!.url!,
//                                     title: 'Payment'))).then((value) async {
//                           setState(() {
//                             isCheckingForPayment = true;
//                           });

//                           final checkInvoice =
//                               await paymentController.paymentInvoiceById(
//                                   context: context, id: invoice!.id);

//                           if (checkInvoice!.invoiceStatus != 'faild') {
//                             final isSuccess = await widget.servicesController
//                                 .checkAndBookHospitality(
//                                     context: context,
//                                     check: true,
//                                     cost: (widget.hospitality!.price *
//                                         (widget.maleGuestNum +
//                                             widget.maleGuestNum)),
//                                     date: widget
//                                         .servicesController.selectedDate.value,
//                                     hospitalityId: widget.hospitality!.id,
//                                     dayId: widget
//                                         .hospitality!
//                                         .daysInfo[widget.servicesController
//                                             .selectedDateIndex.value]
//                                         .id,
//                                     numOfMale: widget.maleGuestNum,
//                                     numOfFemale: widget.femaleGuestNum,
//                                     paymentId: invoice!.id);
//                             setState(() {
//                               isCheckingForPayment = false;
//                             });

//                             if (checkInvoice.invoiceStatus == 'failed' ||
//                                 checkInvoice.invoiceStatus == 'initiated') {
//                               //  Get.back();

//                               showDialog(
//                                   context: context,
//                                   builder: (ctx) {
//                                     return AlertDialog(
//                                       backgroundColor: Colors.white,
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Image.asset(
//                                               'assets/images/paymentFaild.gif'),
//                                           CustomText(text: "paymentFaild".tr),
//                                         ],
//                                       ),
//                                     );
//                                   });
//                             } else {
//                               print('YES');
//                               Get.back();
//                               Get.back();

//                               showDialog(
//                                   context: context,
//                                   builder: (ctx) {
//                                     return AlertDialog(
//                                       backgroundColor: Colors.white,
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Image.asset(
//                                               'assets/images/paymentSuccess.gif'),
//                                           CustomText(text: "paymentSuccess".tr),
//                                         ],
//                                       ),
//                                     );
//                                   });
//                             }
//                           } else {}
//                         });
//                       }
//                     }
//                   }),
//                   title: 'confirm'.tr),
//         ),

                  // if (isCheckingForPayment)
                  //   Center(
                  //       child: Container(
                  //           height: 150,
                  //           width: 180,
                  //           padding: EdgeInsets.all(10),
                  //           decoration: BoxDecoration(color: Colors.white),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               const CircularProgressIndicator.adaptive(),
                  //               const SizedBox(
                  //                 height: 10,
                  //               ),
                  //               CustomText(
                  //                 text: 'checkingForPayment'.tr,
                  //                 color: colorGreen,
                  //                 fontWeight: FontWeight.w600,
                  //               )
                  //             ],
                  //           )))