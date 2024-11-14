import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/view/payment_type_new.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/promocode_field.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../explore/tourist/model/place.dart';
import '../../request/ajwadi/controllers/request_controller.dart';
import '../../request/tourist/controllers/offer_controller.dart';
import '../../request/tourist/models/schedule.dart';
import '../../widgets/schedule_container_widget.dart';
import '../../widgets/total_widget.dart';

class ReviewRequest extends StatefulWidget {
  const ReviewRequest({
    super.key,
    required this.booking,
    this.offerController,
    this.place,
    required this.scheduleList,
  });
  final Booking? booking;
  final List<Schedule>? scheduleList;
  final OfferController? offerController;
  final Place? place;

  @override
  State<ReviewRequest> createState() => _ReviewRequestState();
}

class _ReviewRequestState extends State<ReviewRequest> {
  Invoice? invoice;
  bool isCheckingForPayment = false;
  int finalCost = 0;
  final RequestController _RequestController = Get.put(RequestController());
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final _offerController = Get.put(OfferController());
  Place? thePlace;

  // late book.Booking? fetchedBooking2;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBooking();
    });
  }

  void getBooking() async {
    await _offerController.getOffers(
        context: context,
        placeId: widget.place!.id!,
        bookingId: widget.booking!.id!);

    thePlace = await _touristExploreController.getPlaceById(
        id: widget.place!.id!, context: context);
  }

  PaymentController paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    print(widget.offerController!.totalPrice.value *
        widget.offerController!.offerDetails.value.booking!.guestNumber!);

    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => _RequestController.isBookingLoading.value
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()))
          : GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                extendBodyBehindAppBar: false,
                appBar: CustomAppBar(
                  "ReviewRequest".tr,
                ),
                body: Container(
                  padding: EdgeInsets.only(
                      top: width * 0.01,
                      left: width * 0.043,
                      right: width * 0.043),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'RequestedTourDetails'.tr,
                                  fontSize: width * 0.044,
                                  fontFamily: 'HT Rakik',
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: width * 0.04,
                                ),
                                ReviewDetailsTile(
                                    title: AppUtil.formatBookingDate(
                                        context, widget.booking!.date!),
                                    image: 'assets/icons/date.svg'),
                                SizedBox(
                                  height: width * .010,
                                ),
                                // Details
                                ReviewDetailsTile(
                                    title: AppUtil.rtlDirection2(context)
                                        ? 'من ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)} إلى ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)} '
                                        : 'Pick up: ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)}, Drop off: ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)}',
                                    image: 'assets/icons/time3.svg'),
                                SizedBox(
                                  height: width * .010,
                                ),
                                ReviewDetailsTile(
                                    title:
                                        '${widget.booking?.guestNumber} ${'guests'.tr}',
                                    image: 'assets/icons/guests.svg'),
                                SizedBox(
                                  height: width * .010,
                                ),
                                ReviewDetailsTile(
                                  title: widget.booking!.vehicleType!,
                                  image:
                                      'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
                                  widthh: 20,
                                ),
                                SizedBox(
                                  height: width * 0.041,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.05,
                                ),
                                CustomText(
                                  text: "ItineraryDetails".tr,
                                  fontSize: width * 0.044,
                                  fontFamily: 'HT Rakik',
                                  fontWeight: FontWeight.w500,
                                ),
                                ScheduleContainerWidget(
                                    scheduleList: widget.scheduleList,
                                    offerController: widget.offerController,
                                    isReview: true),

                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.06,
                                ),

                                // discount widget
                                PromocodeField(
                                  price: (widget.offerController!.totalPrice
                                              .value *
                                          widget.offerController!.offerDetails
                                              .value.booking!.guestNumber!)
                                      .toDouble(),
                                  type: 'PLACE',
                                ),
                                if (paymentController.isUnderMinSpend.value)
                                  CustomText(
                                    text:
                                        '${'couponMiSpend'.tr}  ${paymentController.coupon.value.minSpend} ${'orAbove'.tr}',
                                    fontSize: width * 0.028,
                                    color: starGreyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                SizedBox(
                                  height: width * 0.071,
                                ),
                                DottedSeparator(
                                  color: almostGrey,
                                  height: width * 0.002,
                                ),
                                // SizedBox(
                                //   height: width * 0.09,
                                // ),
                                SizedBox(
                                  height: width * 0.07,
                                ),
                              ],
                            ),
                          ),
                        ),
                        TotalWidget(
                          offerController: widget.offerController,
                          place: widget.place!,
                        ),
                        if (paymentController.validateType.value ==
                            'applied') ...[
                          SizedBox(
                            height: width * 0.0102,
                          ),
                          Row(
                            children: [
                              CustomText(
                                text: 'discount'.tr,
                                fontSize: width * 0.038,
                                fontFamily: AppUtil.SfFontType(context),
                                color: starGreyColor,
                              ),
                              const Spacer(),
                              CustomText(
                                text:
                                    '${"sar".tr} ${paymentController.discountPrice.toString()}-',
                                fontSize: width * 0.038,
                                fontFamily: AppUtil.SfFontType(context),
                                color: starGreyColor,
                              )
                            ],
                          ),
                        ],
                        SizedBox(
                          height: width * 0.02,
                        ),
                        paymentController.isPaymenInvoiceLoading.value
                            ? const CircularProgressIndicator.adaptive()
                            : CustomButton(
                                title: 'checkout'.tr,
                                icon: const Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white),
                                onPressed: () async {
                                  for (var item in widget
                                      .offerController!.updateScheduleList) {}
                                  Get.to(
                                    () => PaymentType(
                                      price: paymentController
                                                  .validateType.value ==
                                              'applied'
                                          ? paymentController.finalPrice.value
                                          : (widget.offerController!.totalPrice
                                                      .value *
                                                  widget
                                                      .offerController!
                                                      .offerDetails
                                                      .value
                                                      .booking!
                                                      .guestNumber!)
                                              .toDouble(),
                                      type: 'tour',
                                      offerController: widget.offerController,
                                      booking: widget.booking,
                                    ),
                                  );
                                  AmplitudeService.amplitude.track(BaseEvent(
                                    'Go to payment screen',
                                  ));
                                }),
                        const SizedBox(height: 10),
                        CustomButton(
                            onPressed: () {
                              Get.until(
                                  (route) => Get.currentRoute == '/FindAjwady');
                            },
                            title: AppUtil.rtlDirection2(context)
                                ? 'عودة للعروض'
                                : 'Return to Offers'.tr,
                            buttonColor: Colors.white.withOpacity(0.3),
                            borderColor: Colors.white.withOpacity(0.3),
                            textColor: black),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String getBookingTypeText(BuildContext context, String bookingType) {
    if (AppUtil.rtlDirection2(context)) {
      switch (bookingType) {
        case 'place':
          return 'جولة';
        case 'adventure':
          return 'نشاط';
        case 'hospitality':
          return 'ضيافة';
        case 'event':
          return 'فعالية';
        default:
          return bookingType;
      }
    } else {
      if (bookingType == 'place') {
        return "Tour";
      } else {
        return bookingType;
      }
    }
  }
}
