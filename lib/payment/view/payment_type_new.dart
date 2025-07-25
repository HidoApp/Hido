import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/widget/webview_sheet.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local/controllers/request_controller.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/paymentType.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart' as book;

class PaymentType extends StatefulWidget {
  const PaymentType(
      {super.key,
      required this.price,
      this.adventure,
      required this.type,
      this.hospitality,
      this.personNumber,
      this.offerController,
      this.booking,
      this.thePlace,
      this.servicesController,
      this.male,
      this.event,
      this.eventController,
      this.female});
  final double price;
  final String type;
  final int? personNumber;
  final int? male;
  final int? female;
  final Place? thePlace;
  final Booking? booking;
  final Event? event;
  final Adventure? adventure;
  final Hospitality? hospitality;
  final OfferController? offerController;
  final HospitalityController? servicesController;
  final EventController? eventController;
  @override
  State<PaymentType> createState() => _PaymentTypeState();
}

class _PaymentTypeState extends State<PaymentType> {
  PaymentMethod? _selectedPaymentMethod;
  Invoice? invoice;
  bool? isSuccess;
  final adventureController = Get.put(AdventureController());
  final hospitalityController = Get.put(HospitalityController());
  final _paymentController = Get.put(PaymentController());
  final _RequestController = Get.put(RequestController());

  Future<void> selectPaymentType(PaymentMethod paymentMethod) async {
    if (widget.type == 'hospitality') {
      final isValid = hospitalityController.checkForOneHour(context: context);
      if (!isValid) {
        return;
      }
    }
    if (widget.type == 'event') {
      final isValid = widget.eventController!.checkForOneHour(context: context);
      if (!isValid) {
        return;
      }
    }
    if (widget.type == 'adventure') {
      final isValid = adventureController.checkForOneHour(
        context: context,
      );
      if (!isValid) {
        return;
      }
    }

    switch (paymentMethod) {
      case PaymentMethod.appelpay:
        AmplitudeService.amplitude.track(BaseEvent(
          'Select Appelpay ',
        ));

        invoice = await _paymentController.applePayEmbedded(
            context: context, invoiceValue: widget.price);

        applePayWebView();

        break;
      case PaymentMethod.stcpay:
        AmplitudeService.amplitude.track(BaseEvent(
          'Select Stcpay ',
        ));

        invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'STC_PAY',
          price: widget.price,
        );
        paymentWebViewStcPay();
        break;
      case PaymentMethod.creditCard:
        AmplitudeService.amplitude.track(BaseEvent(
          'Select CreditCard',
        ));

        invoice = await _paymentController.creditCardEmbedded(
          context: context,
          price: widget.price,
        );

        paymentWebView();

        break;
      default:
        AppUtil.errorToast(context, 'PickMethod'.tr);
    }
  }

  void applePayWebView() async {
    if (invoice != null) {
      Get.bottomSheet(WebViewSheet(
        url: invoice!.url!,
        title: "",
        height: 120,
      )).then((value) async {
        Invoice? checkInvoice;
        if (!mounted) return;

        checkInvoice = await _paymentController.getPaymentId(
            context: context, id: invoice!.payId!);
        if (checkInvoice?.payStatus == 'Paid') {
          //if the invoice paid then will booking depend on the type of booking
          AmplitudeService.amplitude.track(BaseEvent(
            'Payment via ApplePay is successful',
          ));

          switch (widget.type) {
            case 'adventure':
              adventureBooking(checkInvoice!);
              break;
            case 'tour':
              tourBooking(checkInvoice!);
              break;
            case 'hospitality':
              hospitalityBooking(checkInvoice!);
              break;
            case 'event':
              eventBooking(checkInvoice!);
              break;
            default:
          }
        } else {
          AmplitudeService.amplitude.track(BaseEvent(
            'Payment via ApplePay is faild',
          ));
          if (!mounted) return;

          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/paymentFaild.gif', width: 38),
                      CustomText(
                        text: "paymentFaild".tr,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              });
        }
      });
    } else {
      if (!mounted) return;

      AmplitudeService.amplitude.track(BaseEvent(
        'Payment via ApplePay is faild',
      ));

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/paymentFaild.gif', width: 38),
                CustomText(
                  text: "paymentFaild".tr,
                  fontSize: 15,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void paymentWebView() async {
    // webview for Stc pay
    if (invoice != null) {
      Get.bottomSheet(WebViewSheet(
        url: invoice!.url!,
        title: 'payment'.tr,
      )).then((value) async {
        Invoice? checkInvoice;
        if (!mounted) return;
        checkInvoice = await _paymentController.getPaymentId(
            context: context, id: invoice!.payId!);

        if (checkInvoice != null && checkInvoice.payStatus == 'Paid') {
          //if the invoice paid then will booking depend on the type of booking
          AmplitudeService.amplitude.track(BaseEvent(
            'Payment via CreditCard is successful',
          ));

          switch (widget.type) {
            case 'adventure':
              adventureBooking(checkInvoice);
              break;
            case 'tour':
              tourBooking(checkInvoice);
              break;
            case 'hospitality':
              hospitalityBooking(checkInvoice);
              break;
            case 'event':
              eventBooking(checkInvoice);
              break;
            default:
          }
        } else {
          AmplitudeService.amplitude.track(BaseEvent(
            'Payment via CreditCard is faild',
          ));
          if (!mounted) return;

          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/paymentFaild.gif', width: 38),
                      CustomText(
                        text: "paymentFaild".tr,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              });
        }
      });
    } else {
      AmplitudeService.amplitude.track(BaseEvent(
        'Payment via CreditCard is faild',
      ));

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/paymentFaild.gif', width: 38),
                CustomText(
                  text: "paymentFaild".tr,
                  fontSize: 15,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void paymentWebViewStcPay() async {
    // webview for Stc pay
    if (invoice != null) {
      Get.to(() => PaymentWebView(
            url: invoice!.url!,
            title: 'payment'.tr,
          ))?.then((value) async {
        Invoice? checkInvoice;
        if (!mounted) return;

        checkInvoice = await _paymentController.getPaymentId(
            context: context, id: invoice!.id);

        if (checkInvoice != null && checkInvoice.payStatus == 'Paid') {
          //if the invoice paid then will booking depend on the type of booking
          AmplitudeService.amplitude.track(BaseEvent(
            'Payment via StcPay is successful',
          ));
          switch (widget.type) {
            case 'adventure':
              adventureBooking(checkInvoice);
              break;
            case 'tour':
              tourBooking(checkInvoice);
              break;
            case 'hospitality':
              hospitalityBooking(checkInvoice);
              break;
            case 'event':
              eventBooking(checkInvoice);
              break;
            default:
          }
        } else {
          AmplitudeService.amplitude.track(BaseEvent(
            'Payment via StcPay is faild',
          ));
          if (!mounted) return;

          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/paymentFaild.gif', width: 38),
                      CustomText(
                        text: "paymentFaild".tr,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              });
        }
      });
    } else {
      if (!mounted) return;

      AmplitudeService.amplitude.track(BaseEvent(
        'Payment via StcPay is faild',
      ));

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/paymentFaild.gif', width: 38),
                CustomText(
                  text: "paymentFaild".tr,
                  fontSize: 15,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void tourBooking(Invoice checkInvoice) async {
    await widget.offerController!.acceptOffer(
      context: context,
      couponId: _paymentController.couponId.value,
      offerId: widget.offerController!.offerDetails.value.id!,
      invoiceId: checkInvoice.id,
      schedules: widget.offerController!.updateScheduleList,
    );
    if (!mounted) return;
    final book.Booking? fetchedBooking =
        await _RequestController.getBookingById(
            context: context, bookingId: widget.booking!.id!);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/paymentSuccess.gif',
                width: 38,
              ),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      Get.offAll(() => const TouristBottomBar());

      // LocalNotification().showNotification(
      //   context,
      //   fetchedBooking?.id,
      //   fetchedBooking?.timeToGo,
      //   fetchedBooking?.date,
      //   fetchedBooking?.user?.profile.name,
      //   fetchedBooking?.requestName?.nameEn,
      //   fetchedBooking?.requestName?.nameAr,
      // );
      log(fetchedBooking?.requestName?.nameEn ?? '');
      log(fetchedBooking?.requestName?.nameAr ?? '');

      Get.to(() => TicketDetailsScreen(
            booking: fetchedBooking,
            icon: SvgPicture.asset('assets/icons/place.svg'),
            bookTypeText: 'place',
            isTour: true,
          ));

      AmplitudeService.amplitude.track(BaseEvent(
        'Get Tour Ticket',
      ));
    });
  }

  void hospitalityBooking(Invoice checkInvoice) async {
    // if paid the check flag will change to true
    isSuccess = await widget.servicesController!.checkAndBookHospitality(
      context: context,
      paymentId: checkInvoice.id,
      hospitalityId: widget.hospitality!.id,
      date: widget.servicesController!.selectedDate.value,
      dayId: widget.hospitality!
          .daysInfo[widget.servicesController!.selectedDateIndex.value].id,
      numOfMale: widget.male!,
      numOfFemale: widget.female!,
      couponId: _paymentController.couponId.value,
    );
    if (!mounted) return;

    final updatedHospitality = await widget.servicesController!
        .getHospitalityById(context: context, id: widget.hospitality!.id);
    log(updatedHospitality!.booking!.last.guestInfo.male.toString());
    log(updatedHospitality.booking!.last.guestInfo.female.toString());
    log(updatedHospitality.booking!.last.guestInfo.dayId.toString());
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/paymentSuccess.gif',
                width: 38,
              ),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      Get.offAll(() => const TouristBottomBar());

      Get.to(() => TicketDetailsScreen(
            hospitality: updatedHospitality,
            icon: SvgPicture.asset('assets/icons/hospitality.svg'),
            bookTypeText: "hospitality",
          ));

      AmplitudeService.amplitude.track(BaseEvent(
        'Get Hospitality Ticket',
      ));
    });
    // LocalNotification().showHospitalityNotification(
    //     context,
    //     updatedHospitality.booking?.last.id,
    //     widget.servicesController!.selectedDate.value,
    //     updatedHospitality.mealTypeEn,
    //     updatedHospitality.mealTypeAr,
    //     updatedHospitality.titleEn,
    //     updatedHospitality.titleAr);
  }

  void eventBooking(Invoice checkInvoice) async {
    await widget.eventController!.checkAndBookEvent(
        context: context,
        paymentId: checkInvoice.id,
        eventId: widget.event!.id,
        cost: widget.price,
        couponId: _paymentController.couponId.value,
        dayId: widget.event!
            .daysInfo![widget.eventController!.selectedDateIndex.value].id,
        person: widget.personNumber!,
        date: widget.eventController!.selectedDate.value);
    if (!mounted) return;

    final updatedEvent = await widget.eventController!
        .getEventById(context: context, id: widget.event!.id);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/paymentSuccess.gif',
                width: 38,
              ),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      Get.offAll(() => const TouristBottomBar());
      log("inside adventure");
      log("${updatedEvent!.booking?.last.id}");
      // LocalNotification().showEventNotification(
      //     context,
      //     updatedEvent.booking?.last.id,
      //     widget.eventController!.selectedDate.value,
      //     updatedEvent.nameEn,
      //     updatedEvent.nameAr);
      Get.to(() => TicketDetailsScreen(
            event: updatedEvent,
            icon: SvgPicture.asset('assets/icons/event.svg'),
            bookTypeText: "event",
          ));

      AmplitudeService.amplitude.track(BaseEvent(
        'Get Event Ticket',
      ));
    });
  }

  void adventureBooking(Invoice checkInvoice) async {
    await adventureController.checkAdventureBooking(
      adventureID: widget.adventure!.id,
      context: context,
      date: adventureController.selectedDate.value,
      dayId: widget
          .adventure!.daysInfo![adventureController.selectedDateIndex.value].id,
      personNumber: widget.personNumber!,
      couponId: _paymentController.couponId.value,
      invoiceId: checkInvoice.id,
    );
    if (!mounted) return;

    final updatedAdventure = await adventureController.getAdvdentureById(
        context: context, id: widget.adventure!.id);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/paymentSuccess.gif',
                width: 38,
              ),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      Get.offAll(() => const TouristBottomBar());

      //     updatedAdventure.nameAr);
      Get.to(() => TicketDetailsScreen(
            adventure: updatedAdventure,
            icon: SvgPicture.asset('assets/icons/adventure.svg'),
            bookTypeText: "adventure",
          ));

      AmplitudeService.amplitude.track(BaseEvent(
        'Get Adventure Ticket',
      ));
    });
  }

  bool loadingButton() {
    if (widget.type == 'hospitality') {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          adventureController.ischeckBookingLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          widget.servicesController!.isHospitalityByIdLoading.value ||
          widget.servicesController!.isCheckAndBookLoading.value;
    } else if (widget.type == 'adventure') {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          adventureController.isAdventureByIdLoading.value |
              adventureController.ischeckBookingLoading.value;
    } else if (widget.type == 'tour') {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          _RequestController.isBookingLoading.value ||
          widget.offerController!.isAcceptOfferLoading.value;
    } else {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          widget.eventController!.isEventByIdLoading.value ||
          widget.eventController!.ischeckBookingLoading.value;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * .04, vertical: width * 0.051),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DottedSeparator(
                color: almostGrey,
                height: width * 0.002,
              ),
              SizedBox(
                height: width * 0.071,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'total'.tr,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: black,
                        fontSize: 20,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.price}',
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                              fontFamily: 'HT Rakik',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: 'sar'.tr,
                            style: TextStyle(
                              color: black,
                              fontSize: width * 0.051,
                              fontFamily: 'HT Rakik',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.010,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     CustomText(
              //       text: 'promocode'.tr,
              //       fontSize: width * 0.038,
              //       fontWeight: FontWeight.w500,
              //       color: almostGrey,
              //     ),
              //     const Spacer(),
              //     CustomText(
              //       // text: 'SAR ${widget.adventure.price.toString()}',
              //       text: '- ${"sar".tr} ${widget.price}',
              //       fontWeight: FontWeight.w500,
              //       fontSize: width * 0.038, color: almostGrey,
              //     ),
              //   ],
              // ),
              SizedBox(
                height: width * 0.05,
              ),
              Obx(
                () => loadingButton()
                    ? const CircularProgressIndicator.adaptive()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: CustomButton(
                          onPressed: () async {
                            if (_selectedPaymentMethod != null) {
                              await selectPaymentType(_selectedPaymentMethod!);
                              AmplitudeService.amplitude.track(BaseEvent(
                                'Go to payment screen',
                              ));
                            } else {
                              AppUtil.errorToast(
                                  context,
                                  AppUtil.rtlDirection2(context)
                                      ? "يجب إختيار طريقة الدفع"
                                      : "You need to pick payment methoed");
                            }
                          },
                          title: 'pay'.tr,
                          icon: const Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
        appBar: CustomAppBar(
          'checkout'.tr,
          isBack: loadingButton(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: width * 0.041,
              right: width * 0.041,
              top: width * 0.030,
              bottom: width * 0.082,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'paymentMethod'.tr,
                  fontSize: width * 0.047,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: width * 0.04,
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
                    RepaintBoundary(
                      child: SvgPicture.asset(
                        "assets/icons/stc.svg",
                        height: width * 0.051,
                      ),
                    ),
                  ],
                ),
                if (Platform.isIOS)
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
                      RepaintBoundary(
                        child: SvgPicture.asset(
                          "assets/icons/applePay_icon.svg",
                          color: const Color.fromARGB(255, 0, 0, 0),
                          height: width * 0.051,
                        ),
                      ),
                    ],
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
                    RepaintBoundary(
                        child: SvgPicture.asset(
                            'assets/icons/logos_mastercard.svg')),
                    SizedBox(
                      width: width * 0.005,
                    ),
                    RepaintBoundary(
                        child: SvgPicture.asset('assets/icons/logos_visa.svg')),
                    SizedBox(
                      width: width * 0.015,
                    ),
                    CustomText(
                      text: 'creditCard'.tr,
                      color: const Color(0xFF070708),
                      fontSize: width * 0.041,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
