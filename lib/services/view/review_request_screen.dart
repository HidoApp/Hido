import 'dart:math';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart' as book;
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/explore/widget/floating_timer.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/view/payment_type_new.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
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
import 'package:floating_draggable_advn/floating_draggable_advn_bk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../explore/tourist/model/place.dart';
import '../../profile/view/ticket_details_screen.dart';
import '../../request/ajwadi/controllers/request_controller.dart';
import '../../request/local_notification.dart';
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
    print("1");

    // book.Booking? fetchedBooking = await _RequestController.getBookingById(
    //     context: context,
    //     bookingId: widget.booking!.id!,
    //   );
    //   print(fetchedBooking?.id);
    //   fetchedBooking2=fetchedBooking;
    //   print(fetchedBooking2?.id);

    // print(fetchedBooking2!.offers!.length);
    // if(fetchedBooking2!.offers!!=[]){
    // await widget.offerController?.getOfferById(context: context, offerId:fetchedBooking!.offers!.last.id);
    // }
    await _offerController.getOffers(
        context: context,
        placeId: widget.place!.id!,
        bookingId: widget.booking!.id!);
    print('First Offer ID: ${_offerController.offers.length}');
    print(_offerController.offers.last.offerId);
    thePlace = await _touristExploreController.getPlaceById(
        id: widget.place!.id!, context: context);
  }

  PaymentController paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    print("this is total final invoice price11");
    print(widget.offerController!.totalPrice.value *
        widget.offerController!.offerDetails.value.booking!.guestNumber!);

    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => _RequestController.isBookingLoading.value
          ? Scaffold(
              body: Center(
                  child: CircularProgressIndicator(color: Colors.green[800])))
          : FloatingDraggableADVN(
              floatingWidget: const FloatingTimer(),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'RequestedTourDetails'.tr,
                            fontSize: width * 0.043,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          ReviewDetailsTile(
                              title:
                                  '${AppUtil.formatBookingDate(context, widget.booking!.date!)}',
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
                            widthh: 26,
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
                            text: "ItineraryDetails".tr,
                            fontSize: width * 0.043,
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
                            height: width * 0.25,
                          ),

                          // SizedBox(
                          //   height: width * 0.25,
                          // ),

                          //discount widget
                          // const PromocodeField(),
                          SizedBox(
                            height: width * 0.071,
                          ),
                          DottedSeparator(
                            color: almostGrey,
                            height: width * 0.002,
                          ),
                          SizedBox(
                            height: width * 0.09,
                          ),

                          TotalWidget(
                            offerController: widget.offerController,
                            place: widget.place!,
                          ),

                          SizedBox(
                            height: width * 0.02,
                          ),
                          paymentController.isPaymenInvoiceLoading.value
                              ? const CircularProgressIndicator(
                                  color: colorGreen,
                                )
                              : CustomButton(
                                  title: 'checkout'.tr,
                                  icon: const Icon(Icons.keyboard_arrow_right,
                                      color: Colors.white),
                                  onPressed: () async {
                                    Get.to(
                                      () => PaymentType(
                                        price: (widget.offerController!
                                                .totalPrice.value *
                                            widget.offerController!.offerDetails
                                                .value.booking!.guestNumber!),
                                        type: 'tour',
                                        offerController: widget.offerController,
                                        booking: widget.booking,
                                      ),
                                    );
                                  }),
                        ],
                      ),
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
          return 'مغامرة';
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
