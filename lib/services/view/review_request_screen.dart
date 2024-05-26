import 'dart:math';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart' as book;
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
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
  const ReviewRequest(
      {super.key,
      required this.booking,
       this.offerController,
       this.place,
      required this.scheduleList,
    });
    final Booking ?booking;
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
  final RequestController _RequestController= Get.put(RequestController());
    final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final _offerController = Get.put(OfferController());
    Place? thePlace;

  late book.Booking? fetchedBooking2;
  @override
   initState() {
    // TODO: implement initState
    super.initState();
    getBokking();

  }

 void getBokking()async{
 
  book.Booking? fetchedBooking = await _RequestController.getBookingById(
      context: context,
      bookingId: widget.booking!.id!,
    );
    print("this book");
    print(fetchedBooking?.id);
    fetchedBooking2=fetchedBooking;
    print(fetchedBooking2?.id);

    print("lingth");
    // print(fetchedBooking2!.offers!.length);
    // if(fetchedBooking2!.offers!!=[]){
    // await widget.offerController?.getOfferById(context: context, offerId:fetchedBooking!.offers!.last.id);
    // }
    await _offerController.getOffers(context: context, placeId:widget.place!.id! , bookingId:  widget.booking!.id!);
    print('First Offer ID: ${_offerController.offers.length}');
    print(_offerController.offers.last.offerId);
      thePlace = await _touristExploreController.getPlaceById(
        id: widget.place!.id!, context: context);



  
 }
  PaymentController paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
   return Obx(
      ()=> _RequestController.isBookingLoading.value? 
      
      Scaffold(
       body: Center(
              child: CircularProgressIndicator(
        color: Colors.green[800]))

      ):Scaffold(
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        "ReviewRequest".tr,
      ),
      body: Container(
        padding: EdgeInsets.only(top:width * 0.01,left:width * 0.043,right:width * 0.043),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:'RequestedTourDetails'.tr,
                  fontSize: width * 0.047,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: width * 0.04,
                ),
                ReviewDetailsTile(
                    title:'${DateFormat('EEE, dd MMMM yyyy').format(DateTime.parse(widget.booking!.date!))}',
                    image: 'assets/icons/date.svg'),
                 SizedBox(
                   height: 7,
                     ),
                // Details
                ReviewDetailsTile(
                    title:AppUtil.rtlDirection2(context)?' ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToGo}'))} إلى ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToReturn}'))} ':'Pick up:  ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToGo}'))},  Drop off:  ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToReturn}'))}',
                    image: 'assets/icons/time3.svg'),
                 SizedBox(
                   height: 7,
                     ),
                ReviewDetailsTile(
                    title:'${widget.booking?.guestNumber} ${'guests'.tr}',
                    image: 'assets/icons/guests.svg'),
                   SizedBox(
                   height: 7,
                     ),
                 ReviewDetailsTile(
                    title: widget.booking!.vehicleType!,
                    image: 'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg'),
                SizedBox(
                   height: 13,
                     ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: width * 0.03,
                ),
                CustomText(
                  text: "ItineraryDetails".tr,
                   fontSize: width * 0.047,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
                ScheduleContainerWidget(
                              scheduleList: widget.scheduleList,
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
                              ? CircularProgressIndicator(
                                  color: colorGreen,
                                )
                              : CustomButton(
                                
                                title: 'checkout'.tr,

                                icon: Icon(Icons.keyboard_arrow_right,color: Colors.white),
                                  onPressed: () async {
                                    invoice ??=
                                        await paymentController.paymentInvoice(
                                            context: context,
                                            description: 'Book place',
                                              amount: (widget.offerController!
                                                        .totalPrice.value *
                                                    widget
                                                        .offerController!
                                                        .offerDetails
                                                        .value
                                                        .booking!
                                                        .guestNumber!));

                                            // amount: (widget.place!.price! *
                                            //         widget
                                            //             .offerController!
                                            //             .offerDetails
                                            //             .value
                                            //             .booking!
                                            //             .guestNumber!) +
                                            //     (widget.offerController!
                                            //             .totalPrice.value *
                                            //         widget
                                            //             .offerController!
                                            //             .offerDetails
                                            //             .value
                                            //             .booking!
                                            //             .guestNumber!));

                                    Get.to(() => PaymentWebView(
                                        url: invoice!.url!,
                                        title: AppUtil.rtlDirection2(context)?'الدفع':'Payment'))?.then((value) async {
                                    
                                       setState(() {
                                                  isCheckingForPayment = true;
                                                });

                                                        final checkInvoice =
                                                    await paymentController
                                                        .paymentInvoiceById(
                                                            context: context,
                                                            id: invoice!.id);

                                                            print("checkInvoice!.invoiceStatus");
                                                            print(checkInvoice!.invoiceStatus);

                                                                         if (checkInvoice
                                                        .invoiceStatus !=
                                                    'faild') {
                                                
                                                  setState(() {
                                                    isCheckingForPayment =
                                                        false;
                                                  });

                                                  if (checkInvoice
                                                              .invoiceStatus ==
                                                          'failed' ||
                                                      checkInvoice
                                                              .invoiceStatus ==
                                                          'initiated') {
                                                    //  Get.back();

                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/paymentFaild.gif'),
                                                                CustomText(
                                                                    text:
                                                                        "paymentFaild"
                                                                            .tr),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    print('YES');
                                                    // Get.back();
                                                    // Get.back();

                                                        final acceptedOffer = await widget
                                        .offerController!
                                        .acceptOffer(
                                      context: context,
                                      offerId: widget.offerController!.offerDetails.value.id!,
                                      invoiceId: checkInvoice.id,
                                      schedules: widget.offerController!
                                          .offerDetails.value.schedule!,
                                    );
                                 //Get.back();
                                //    Get.back();

                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/paymentSuccess.gif'),
                                                                CustomText(
                                                                    text:
                                                                        "paymentSuccess"
                                                                            .tr),
                                                              ],
                                                            ),
                                                          );
                                                        }).then((_) {
                                                  LocalNotification().showNotification(context,widget.booking?.id, widget.booking?.timeToGo, widget.booking?.date ,_offerController.offers.last.name, thePlace?.nameAr,thePlace?.nameEn);

                                                  Get.to(() =>  TicketDetailsScreen(
                                                            booking: fetchedBooking2,
                                                             icon: SvgPicture.asset(
                                                            'assets/icons/place.svg'),
                                                             bookTypeText:getBookingTypeText(context, 'place')
                                                  ));
                                                          });
                                                  
                                                  

                                                  }
                                                }
                                    });
                                    // Get.to(
                                    //   () => CheckOutScreen(
                                    //     total: (widget.place!.price! *
                                    //             widget
                                    //                 .offerController!
                                    //                 .offerDetails
                                    //                 .value
                                    //                 .booking!
                                    //                 .guestNumber!) +
                                    //         (widget.offerController!.totalPrice
                                    //                 .value *
                                    //             widget
                                    //                 .offerController!
                                    //                 .offerDetails
                                    //                 .value
                                    //                 .booking!
                                    //                 .guestNumber!),
                                    //     offerDetails: widget.offerController!
                                    //         .offerDetails.value,
                                    //     offerController: widget.offerController,
                                    //   ),
                                    // )?.then((value) async {
                                    //   final offer = await widget
                                    //       .offerController!
                                    //       .getOfferById(
                                    //           context: context,
                                    //           offerId: widget.offerController!
                                    //               .offerDetails.value.id!);

                                    //   widget.chatId = widget.offerController!
                                    //       .offerDetails.value.booking!.chatId;

                                    //   //  Get.back();
                                    // });

                                //  LocalNotification().showNotification(context,widget.booking?.id, widget.booking?.timeToGo, widget.booking?.date ,_offerController.offers.last.name, thePlace?.nameAr,thePlace?.nameEn);
                                  },
                                )
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
        return 'مغامرة';
      case 'hospitality':
        return 'ضيافة';
      case 'event':
        return 'فعالية';
      default:
        return bookingType; 
    }
  } else {
    if(bookingType=='place'){
      return "Tour";
    }
    else{
    return bookingType; 
    }
}
}
}
