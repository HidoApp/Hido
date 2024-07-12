import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/services/view/widgets/review_guests.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:ajwad_v4/widgets/promocode_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../payment/view/payment_type_new.dart';

class ReviewAdventure extends StatefulWidget {
  const ReviewAdventure({
    super.key,
    required this.person,
    required this.adventure,
  });
  final int person;
  final Adventure adventure;

  @override
  State<ReviewAdventure> createState() => _ReviewAdventureState();
}

class _ReviewAdventureState extends State<ReviewAdventure> {
  final _adventureController = Get.put(AdventureController());
  final paymentController = Get.put(PaymentController());
  Invoice? invoice;
  bool isCheckingForPayment = false;
  int finalCost = 0;
  
//   final String timeZoneName = 'Asia/Riyadh';
//   late tz.Location location;

//   bool isDateBeforeToday() {
//     DateTime adventureDate =
//         DateFormat('yyyy-MM-dd').parse(widget.adventure.date!);
// tz.initializeTimeZones();
//     location = tz.getLocation(timeZoneName);

//     DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
//     return adventureDate.isBefore(currentDateInRiyadh);
//   }

//   bool isSameDay() {
//     tz.initializeTimeZones();
//     location = tz.getLocation(timeZoneName);

//     DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
//     DateTime adventureDate =
//     DateFormat('yyyy-MM-dd').parse(widget.adventure.date!);

//      DateTime Date =
//     DateFormat('HH:mm').parse(widget.adventure.times!.last.startTime!);

//     DateTime AdventureStartDate = DateTime(adventureDate.year, adventureDate.month,adventureDate.day,Date.hour, Date.minute,Date.second);

//     DateTime bookingDeadline = AdventureStartDate.subtract(Duration(hours: 24));

//     print (AdventureStartDate);
//     print(currentDateInRiyadh);
//     print(bookingDeadline);

//     return bookingDeadline.isBefore(currentDateInRiyadh);
//   }

  void initState() {
    // TODO: implement initState
    super.initState();
    finalCost = widget.adventure.price * widget.person;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(widget.adventure.times?.last.startTime);

    return Scaffold(
      appBar: CustomAppBar(
        "reviewbooking".tr,
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        padding: EdgeInsets.all(width * 0.041),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "adventuredetails".tr,
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 4,
                ),
                ReviewDetailsTile(
                    title:_adventureController.address.value,
                    image: "assets/icons/locationHos.svg"),
                const SizedBox(
                  height: 4,
                ),
                // Details
                ReviewDetailsTile(
                    title: AppUtil.formatBookingDate(context,
                      widget.adventure.date!),
                    
                    image: 'assets/icons/grey_calender.svg'),
                const SizedBox(
                  height: 4,
                ),

                ReviewDetailsTile(
                    title: widget.adventure.times != null &&
                            widget.adventure.times!.isNotEmpty
                        ? widget.adventure.times!
                            .map((time) => AppUtil.formatStringTimeWithLocale(
                                context, time.startTime))
                            .join(', ')
                        : '5:00-8:00 AM',
                    image: "assets/icons/timeGrey.svg"),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: almostGrey,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                  text: "numberOfPeople".tr,
                  fontSize: 18,
                ),
                ReviewGuestsTile(
                  guest: widget.person,
                  title: "person".tr,
                ),
                SizedBox(
                  height: width * .041,
                ),
                const Divider(
                  color: almostGrey,
                ),
                SizedBox(
                  height: width * 0.5,
                ),

                ///discount widget
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
                      fontSize: 20,
                    ),
                    const Spacer(),
                    CustomText(
                      // text: 'SAR ${widget.adventure.price.toString()}',
                      text: '${"sar".tr} ${finalCost.toString()}',

                      fontSize: 20,
                    )
                  ],
                ),
                SizedBox(
                  height: width * 0.051,
                ),
                Obx(() => _adventureController.ischeckBookingLoading.value ||
                        paymentController.isPaymenInvoiceLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: () async {
                          if (widget.adventure.booking!.isNotEmpty) {
                            AppUtil.errorToast(
                                context,
                                AppUtil.rtlDirection2(context)
                                    ? "لقد قمت بالفعل بحجز هذه المغامره"
                                    : "You already booking this adventure");
                            return;
                          }
                          Get.to(
                            () => PaymentType(
                              adventure: widget.adventure,
                              type: 'adventure',
                              personNumber: widget.person,
                              price: widget.adventure.price * widget.person,
                            ),
                          );
                        },
                        title: 'checkout'.tr))
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
