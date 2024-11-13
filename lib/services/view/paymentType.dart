import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../explore/tourist/model/place.dart';
import '../../request/ajwadi/controllers/request_controller.dart';
import '../../request/tourist/controllers/offer_controller.dart';
import '../../widgets/total_widget.dart';

enum PaymentMethod { appelpay, stcpay, creditCard }

class PaymentTypeScreen extends StatefulWidget {
  const PaymentTypeScreen({
    super.key,
    required this.booking,
    this.offerController,
    this.place,
  });
  final Booking? booking;
  final OfferController? offerController;
  final Place? place;

  @override
  State<PaymentTypeScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends State<PaymentTypeScreen> {
  Invoice? invoice;
  bool isCheckingForPayment = false;
  int finalCost = 0;
  final RequestController _RequestController = Get.put(RequestController());
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final _offerController = Get.put(OfferController());
  Place? thePlace;
  PaymentMethod? _selectedPaymentMethod;
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

  void _navigateToPaymentPage() {
    if (_selectedPaymentMethod == null) {
      Get.snackbar("Error", "Please select a payment method");
      return;
    }

    switch (_selectedPaymentMethod) {
      case PaymentMethod.creditCard:
        // Get.to(() =>);
        break;
      case PaymentMethod.appelpay:
        // Get.to(() => );
        break;
      case PaymentMethod.stcpay:
        // Get.to(() => );
        break;
      case null:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => _RequestController.isBookingLoading.value
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()))
          : Scaffold(
              extendBodyBehindAppBar: false,
              appBar: CustomAppBar(
                "Checkout".tr,
              ),
              body: Container(
                // padding: EdgeInsets.only(
                //     top: width * 0.01,
                //     left: width * 0.043,
                //     right: width * 0.043),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: width * 0.01,
                              left: width * 0.043,
                              right: width * 0.043),
                          child: CustomText(
                            text: 'paymentMethod'.tr,
                            fontSize: width * 0.047,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: width * 0.04,
                        ),
                        Row(
                          children: [
                            Radio<PaymentMethod>(
                              value: PaymentMethod.creditCard,
                              groupValue: _selectedPaymentMethod,
                              onChanged: (PaymentMethod? value) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                });
                              },
                            ),
                            SvgPicture.asset(
                                'assets/icons/logos_mastercard.svg'),
                            const SizedBox(
                              width: 2,
                            ),
                            SvgPicture.asset('assets/icons/logos_visa.svg'),
                            const SizedBox(
                              width: 6,
                            ),
                            CustomText(
                              text: 'creditCard'.tr,
                              color: const Color(0xFF070708),
                              fontSize: 16,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                            // Text(
                            //   'Credit/Debit card',
                            //   style: TextStyle(
                            //     color: Color(0xFF070708),
                            //     fontSize: 15,
                            //     fontFamily: 'SF Pro',
                            //     fontWeight: FontWeight.w500,
                            //     height: 0,
                            //   ),
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<PaymentMethod>(
                              value: PaymentMethod.appelpay,
                              groupValue: _selectedPaymentMethod,
                              onChanged: (PaymentMethod? value) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                });
                              },
                            ),
                            // Text('pay'),

                            SvgPicture.asset(
                              "assets/icons/applePay_icon.svg",
                              color: const Color.fromARGB(255, 0, 0, 0),
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<PaymentMethod>(
                              value: PaymentMethod.stcpay,
                              groupValue: _selectedPaymentMethod,
                              onChanged: (PaymentMethod? value) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                });
                              },
                            ),
                            SvgPicture.asset(
                              "assets/icons/stc.svg",
                              height: 20,
                            ),
                          ],
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
                          height: width * 0.5,
                        ),
                        DottedSeparator(
                          color: almostGrey,
                          height: width * 0.002,
                        ),
                        SizedBox(
                          height: width * 0.09,
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: width * 0.01,
                              left: width * 0.043,
                              right: width * 0.043),
                          child: TotalWidget(
                            offerController: widget.offerController,
                            place: widget.place!,
                          ),
                        ),

                        SizedBox(
                          height: width * 0.02,
                        ),
                        paymentController.isPaymenInvoiceLoading.value
                            ? const CircularProgressIndicator.adaptive()
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: width * 0.01,
                                    left: width * 0.043,
                                    right: width * 0.043),
                                child: CustomButton(
                                    title: 'pay'.tr,
                                    icon: const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white),
                                    onPressed: () async {
                                      //   invoice ??=
                                      //       await paymentController.paymentInvoice(
                                      //           context: context,
                                      //           // description: 'Book place',
                                      //           InvoiceValue: (widget.offerController!
                                      //                   .totalPrice.value *
                                      //               widget
                                      //                   .offerController!
                                      //                   .offerDetails
                                      //                   .value
                                      //                   .booking!
                                      //                   .guestNumber!));

                                      //
                                      //   print(
                                      //       widget.offerController!.totalPrice.value *
                                      //           widget.offerController!.offerDetails
                                      //               .value.booking!.guestNumber!);

                                      //   if (invoice != null) {
                                      //     Get.to(() => PaymentWebView(
                                      //         url: invoice!.url!,
                                      //         title: AppUtil.rtlDirection2(context)
                                      //             ? 'الدفع'
                                      //             : 'Payment'))?.then((value) async {
                                      //
                                      //
                                      //       setState(() {
                                      //         isCheckingForPayment = true;
                                      //       });

                                      //       final checkInvoice =
                                      //           await paymentController
                                      //               .paymentInvoiceById(
                                      //                   context: context,
                                      //                   id: invoice!.id);

                                      //
                                      //

                                      //       if (checkInvoice.invoiceStatus ==
                                      //           'Pending') {
                                      //         setState(() {
                                      //           isCheckingForPayment = false;
                                      //         });
                                      //

                                      //         // if (
                                      //         //     checkInvoice
                                      //         //             .invoiceStatus ==
                                      //         //         'Pending') {
                                      //         Get.to(() => PaymentWebView(
                                      //               url: invoice!.url!,
                                      //               title:
                                      //                   AppUtil.rtlDirection2(context)
                                      //                       ? 'الدفع'
                                      //                       : 'Payment',
                                      //             ));
                                      //         //Get.until((route) => Get.currentRoute == '/PaymentWebView');
                                      //         showDialog(
                                      //             context: context,
                                      //             builder: (ctx) {
                                      //               return AlertDialog(
                                      //                 backgroundColor: Colors.white,
                                      //                 content: Column(
                                      //                   mainAxisSize:
                                      //                       MainAxisSize.min,
                                      //                   children: [
                                      //                     Image.asset(
                                      //                         'assets/images/paymentFaild.gif'),
                                      //                     CustomText(
                                      //                         text:
                                      //                             "paymentFaild".tr),
                                      //                   ],
                                      //                 ),
                                      //               );
                                      //             });
                                      //       } else {
                                      //
                                      //         // Get.back();
                                      //         // Get.back();

                                      //         final acceptedOffer = await widget
                                      //             .offerController!
                                      //             .acceptOffer(
                                      //           context: context,
                                      //           offerId: widget.offerController!
                                      //               .offerDetails.value.id!,
                                      //           invoiceId: checkInvoice.id,
                                      //           schedules: widget.offerController!
                                      //               .offerDetails.value.schedule!,
                                      //         );
                                      //
                                      //         //Get.back();
                                      //         final book.Booking? fetchedBooking =
                                      //             await _RequestController
                                      //                 .getBookingById(
                                      //                     context: context,
                                      //                     bookingId:
                                      //                         widget.booking!.id!);
                                      //         showDialog(
                                      //             context: context,
                                      //             builder: (ctx) {
                                      //               return AlertDialog(
                                      //                 backgroundColor: Colors.white,
                                      //                 content: Column(
                                      //                   mainAxisSize:
                                      //                       MainAxisSize.min,
                                      //                   children: [
                                      //                     Image.asset(
                                      //                         'assets/images/paymentSuccess.gif'),
                                      //                     CustomText(
                                      //                         text: "paymentSuccess"
                                      //                             .tr),
                                      //                   ],
                                      //                 ),
                                      //               );
                                      //             }).then((_) {
                                      //
                                      //           LocalNotification().showNotification(
                                      //               context,
                                      //               widget.booking?.id,
                                      //               widget.booking?.timeToGo,
                                      //               widget.booking?.date,
                                      //               _offerController.offers.last.name,
                                      //               thePlace?.nameAr,
                                      //               thePlace?.nameEn);

                                      //           Get.to(() => TicketDetailsScreen(
                                      //               booking: fetchedBooking,
                                      //               icon: SvgPicture.asset(
                                      //                   'assets/icons/place.svg'),
                                      //               bookTypeText: getBookingTypeText(
                                      //                   context, 'place')));
                                      //         });
                                      //       }
                                      //     });
                                      //   }
                                    }),
                              ),
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
      if (bookingType == 'place') {
        return "Tour";
      } else {
        return bookingType;
      }
    }
  }
}
