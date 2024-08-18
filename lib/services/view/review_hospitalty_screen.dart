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
    final height= MediaQuery.of(context).size.height;

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
                  fontSize: width * 0.043,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: width * 0.0205,
                ),
                ReviewDetailsTile(
                    title: widget.servicesController.address.value.isNotEmpty
                    ?widget.servicesController.address.value
                    : AppUtil.rtlDirection2(context)
                        ? widget.hospitality  .regionAr ?? ""
                        : widget.hospitality .regionEn ?? "",
                    image: "assets/icons/map_pin.svg"),
                SizedBox(
                  height: width * 0.010,
                ),
                // Details
                ReviewDetailsTile(
                    title:
                        '${AppUtil.formatTimeOnly(context, widget.hospitality.daysInfo.first.startTime)} - ${AppUtil.formatTimeOnly(context, widget.hospitality.daysInfo.first.endTime)} ',
                    image: "assets/icons/Clock.svg"),
                 SizedBox(
                  height: width * 0.010,
                ),
                ReviewDetailsTile(
                    title: AppUtil.rtlDirection2(context)
                        ? widget.hospitality.mealTypeAr
                        : AppUtil.capitalizeFirstLetter(
                            widget.hospitality.mealTypeEn),
                    image: 'assets/icons/meal.svg'),
                SizedBox(
                  height: width * 0.041,
                ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: width * 0.03,
                ),
                CustomText(
                  text: "numberofpeople".tr,
                  fontSize: width * 0.043,
                  fontWeight: FontWeight.w500,
                ),
                  SizedBox(
                  height: width * 0.0205,
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
                   SizedBox(
                  height: width * 0.041,
                ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: width * 0.03,
                ),
                CustomText(
                  text: "bookingdate".tr,
                  fontSize: width * 0.043,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: width * 0.0205,
                ),
                CustomText(
                  color: almostGrey,
                  text: AppUtil.formatBookingDate(
                      context, widget.servicesController.selectedDate.value),
         fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

              
                ),
                  SizedBox(
                  height: width * 0.041,
                ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: height * 0.110,
                ),
                //discount widget
                const PromocodeField(),
                 SizedBox(
                          height: width * 0.061,
                        ),
                        DottedSeparator(
                          color: almostGrey,
                          height: width * 0.002,
                        ),
                        SizedBox(
                          height: width * 0.09,
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
                            return;
                          }),
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
