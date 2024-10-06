import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
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
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    finalCost = widget.adventure.price * widget.person;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                    fontSize: width * 0.043,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: width * 0.0205,
                  ),
                  ReviewDetailsTile(
                      title: _adventureController.address.value.isNotEmpty
                          ? _adventureController.address.value
                          : AppUtil.rtlDirection2(context)
                              ? widget.adventure.regionAr ?? ""
                              : widget.adventure.regionEn ?? "",
                      image: "assets/icons/map_pin.svg"),
                  SizedBox(
                    height: width * .010,
                  ),
                  // Details
      
                  ReviewDetailsTile(
                      title: AppUtil.formatBookingDate(
                          context, widget.adventure.date!),
                      image: 'assets/icons/calendar.svg'),
                  SizedBox(
                    height: width * .010,
                  ),
      
                  ReviewDetailsTile(
                      title: widget.adventure.times != null &&
                              widget.adventure.times!.isNotEmpty
                          ? '${widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime)).join(', ')} - ${widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.endTime)).join(', ')}'
                          : '5:00-8:00 AM',
                      image: "assets/icons/Clock.svg"),
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
                    text: "numberOfPeople".tr,
                    fontSize: width * 0.043,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: width * 0.0205,
                  ),
                  ReviewGuestsTile(
                    guest: widget.person,
                    title: "person".tr,
                  ),
                  SizedBox(
                    height: width * .041,
                  ),
                  const Divider(
                    color: lightGrey,
                  ),
                  SizedBox(
                    height: width * 0.5,
                  ),
      
                  ///discount widget
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
                      CustomText(
                        // text: 'SAR ${widget.adventure.price.toString()}',
                        text: '${"sar".tr} ${finalCost.toString()}',
      
                        fontSize: width * 0.051,
                      )
                    ],
                  ),
                  SizedBox(
                    height: width * 0.051,
                  ),
                  Obx(() => _adventureController.ischeckBookingLoading.value ||
                          paymentController.isPaymenInvoiceLoading.value
                      ? const Center(child: CircularProgressIndicator.adaptive())
                      : CustomButton(
                          onPressed: () async {
                            Get.to(
                              () => PaymentType(
                                adventure: widget.adventure,
                                type: 'adventure',
                                personNumber: widget.person,
                                price: widget.adventure.price * widget.person,
                              ),
                            );
      
                            AmplitudeService.amplitude.track(BaseEvent(
                              'Go to payment screen',
                            ));
                          },
                          title: 'checkout'.tr))
                ],
              ),
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
