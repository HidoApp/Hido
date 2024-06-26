// ignore_for_file: use_build_context_synchronously

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/view/payment_type_new.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/services/view/widgets/review_guests.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:ajwad_v4/widgets/promocode_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../profile/view/ticket_details_screen.dart';
import '../../request/ajwadi/controllers/request_controller.dart';
import '../../request/local_notification.dart';

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
  int finalCost = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalCost = widget.hospitality.price *
        (widget.maleGuestNum + widget.femaleGuestNum);
  }

  final RequestController _RequestController = Get.put(RequestController());

  PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    print('hospitalityDate');
    print(widget.hospitality.id);

    // print(fetchedBooking?.bookingType);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        "reviewbooking".tr,
      ),
      body: Container(
        padding: EdgeInsets.all(width * 0.041),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "hospitalitydetails".tr,
                  fontSize: width * 0.046,
                ),
                SizedBox(
                  height: width * 0.010,
                ),
                ReviewDetailsTile(
                    title: AppUtil.rtlDirection2(context)
                        ? widget.hospitality.regionAr ?? ""
                        : widget.hospitality.regionEn,
                    image: "assets/icons/locationHos.svg"),
                SizedBox(
                  height: width * 0.010,
                ),
                // Details
                ReviewDetailsTile(
                    title: AppUtil.rtlDirection2(context)
                        ? '${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(widget.hospitality.daysInfo.first.startTime))} -  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(widget.hospitality.daysInfo.first.endTime))}'
                        : ' ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(widget.hospitality.daysInfo.first.startTime))} -  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(widget.hospitality.daysInfo.first.endTime))}',
                    image: "assets/icons/timeGrey.svg"),
                ReviewDetailsTile(
                    title: AppUtil.rtlDirection2(context)
                        ? widget.hospitality.mealTypeAr
                        : widget.hospitality.mealTypeEn,
                    image: 'assets/icons/meal.svg'),
                SizedBox(
                  height: width * 0.051,
                ),
                const Divider(
                  color: almostGrey,
                ),
                SizedBox(
                  height: width * 0.051,
                ),
                CustomText(
                  text: "numberofpeople".tr,
                  fontSize: width * 0.046,
                ),
                if (widget.maleGuestNum != 0)
                  ReviewGuestsTile(
                    guest: widget.maleGuestNum,
                    title: 'male'.tr,
                  ),
                if (widget.femaleGuestNum != 0)
                  ReviewGuestsTile(
                    guest: widget.femaleGuestNum,
                    title: 'female'.tr,
                  ),
                const Divider(
                  color: almostGrey,
                ),
                SizedBox(
                  height: width * 0.051,
                ),
                CustomText(
                  text: "bookingdate".tr,
                  fontSize: width * 0.046,
                ),
                SizedBox(
                  height: width * 0.0205,
                ),
                CustomText(
                  color: almostGrey,
                  text: DateFormat('d MMMM y').format(
                    DateTime.parse(
                      widget.servicesController.selectedDate.value,
                    ),
                  ),
                  // text: DateFormat('d MMMM y').format(
                  //   DateTime.parse(
                  //     widget.servicesController.selectedDate.value,
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: width * .041,
                ),
                const Divider(
                  color: almostGrey,
                ),

                SizedBox(
                  height: width * 0.25,
                ), //discount widget
                const PromocodeField(),
                SizedBox(
                  height: width * 0.051,
                ),
                DottedSeparator(
                  color: almostGrey,
                  height: width * 0.002,
                ),
                SizedBox(
                  height: width * 0.07,
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'total'.tr,
                      fontSize: width * 0.051,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        CustomText(
                          // text: ' ${widget.hospitality.price.toString()} ',
                          text: ' ${finalCost.toString()} ',

                          fontSize: width * 0.051,
                        ),
                        CustomText(
                          text: 'sar'.tr,
                          fontSize: width * 0.051,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: width * 0.051,
                ),
                Obx(
                  () => widget.servicesController.isCheckAndBookLoading.value ||
                          paymentController.isPaymenInvoiceLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          onPressed: (() async {
                            Get.to(
                              () => PaymentType(
                                price: finalCost,
                                type: "hospitality",
                                hospitality: widget.hospitality,
                                servicesController: widget.servicesController,
                                male: widget.maleGuestNum,
                                female: widget.femaleGuestNum,
                              ),
                            );

                            final isSuccess = await widget.servicesController
                                .checkAndBookHospitality(
                                    context: context,
                                    check: false,
                                    hospitalityId: widget.hospitality.id,
                                    date: widget
                                        .servicesController.selectedDate.value,
                                    dayId: widget
                                        .hospitality
                                        .daysInfo[widget.servicesController
                                            .selectedDateIndex.value]
                                        .id,
                                    numOfMale: widget.maleGuestNum,
                                    numOfFemale: widget.femaleGuestNum,
                                    cost: finalCost);

                            if (isSuccess) {
                              print("isSuccess : $isSuccess");

                              invoice ??=
                                  await paymentController.paymentInvoice(
                                      context: context,
                                      InvoiceValue: finalCost);
                              if (invoice != null) {
                                await navigateToPayment(context, invoice!.url!)
                                    .then((value) async {
                                  final checkInvoice = await paymentController
                                      .paymentInvoiceById(
                                    context: context,
                                    id: invoice!.id,
                                  );

                                  if (checkInvoice!.payStatus ==
                                      'Pending') {
                                    print('no');
                                    final isSuccess = await widget
                                        .servicesController
                                        .checkAndBookHospitality(
                                            context: context,
                                            check: false,
                                            cost: finalCost,
                                            date: widget.servicesController
                                                .selectedDate.value,
                                            hospitalityId:
                                                widget.hospitality.id,
                                            dayId: widget
                                                .hospitality
                                                .daysInfo[widget
                                                    .servicesController
                                                    .selectedDateIndex
                                                    .value]
                                                .id,
                                            numOfMale: widget.maleGuestNum,
                                            numOfFemale: widget.femaleGuestNum,
                                            paymentId: invoice!.id);
                                    if (!isSuccess) {
                                      print(!isSuccess);
                                      setState(() {
                                        isCheckingForPayment = false;
                                      });

                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              surfaceTintColor: Colors.white,
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/paymentFaild.gif'),
                                                  CustomText(
                                                      text: "paymentFaild".tr),
                                                ],
                                              ),
                                            );
                                          });

                                      await navigateToPayment(
                                          context, invoice!.url!);
                                    } else {
                                      print('no');
                                    }
                                  } else {
                                    print('YES');

                                    print(invoice?.invoiceStatus);
                                    final isSuccess = await widget
                                        .servicesController
                                        .checkAndBookHospitality(
                                            context: context,
                                            check: true,
                                            paymentId: invoice!.id,
                                            hospitalityId:
                                                widget.hospitality.id,
                                            date: widget.servicesController
                                                .selectedDate.value,
                                            dayId: widget
                                                .hospitality
                                                .daysInfo[widget
                                                    .servicesController
                                                    .selectedDateIndex
                                                    .value]
                                                .id,
                                            numOfMale: widget.maleGuestNum,
                                            numOfFemale: widget.femaleGuestNum,
                                            cost: finalCost);
                                    //   setState(() {
                                    //   isCheckingForPayment = true;
                                    // });

                                    // Refresh the hospitality object
                                    final updatedHospitality = await widget
                                        .servicesController
                                        .getHospitalityById(
                                            context: context,
                                            id: widget.hospitality.id);
                                    print('check');
                                    print(updatedHospitality);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                  'assets/images/paymentSuccess.gif'),
                                              CustomText(
                                                  text: "paymentSuccess".tr),
                                            ],
                                          ),
                                        );
                                      },
                                      // );
                                    ).then((_) {
                                      Get.back();
                                      // Get.back();
                                      // Get.back();
                                      print("inter notif");

                                      Get.to(() => TicketDetailsScreen(
                                            hospitality: updatedHospitality,
                                            icon: SvgPicture.asset(
                                                'assets/icons/hospitality.svg'),
                                            bookTypeText: 'hospitality',
                                          ));
                                    });
                                    LocalNotification()
                                        .showHospitalityNotification(
                                            context,
                                            updatedHospitality
                                                ?.booking?.first.id,
                                            widget.servicesController
                                                .selectedDate.value,
                                            widget.hospitality.mealTypeEn,
                                            widget.hospitality.mealTypeAr,
                                            widget.hospitality.titleEn,
                                            widget.hospitality.titleAr);
                                  }
                                });
                              } else {
                                print('Initial check failed');
                              }
                            } else {}
                          }),

                          // LocalNotification().showHospitalityNotification(context,widget.hospitality.id,  widget.hospitality.booking?.first.date ,widget.hospitality.mealTypeEn,widget.hospitality.mealTypeAr ,widget.hospitality.titleEn,widget.hospitality.titleAr);

                          title: 'checkout'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> navigateToPayment(BuildContext context, String url) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentWebView(
        url: url,
        title: 'Payment',
      ),
    ),
  );
}
