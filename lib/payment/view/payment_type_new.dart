import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/controller/timer_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/credit_card.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/widget/credit_form.dart';
import 'package:ajwad_v4/payment/widget/webview_sheet.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/paymentType.dart';
import 'package:ajwad_v4/services/view/review_adventure_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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
  final int price;
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
  final _cardHolder = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardDate = TextEditingController();
  final _cardCvv = TextEditingController();
  Future<bool> checkHospitality(bool check) async {
    return await widget.servicesController!.checkAndBookHospitality(
        context: context,
        check: check,
        hospitalityId: widget.hospitality!.id,
        date: widget.servicesController!.selectedDate.value,
        dayId: widget.hospitality!
            .daysInfo[widget.servicesController!.selectedDateIndex.value].id,
        numOfMale: widget.male!,
        numOfFemale: widget.female!,
        cost: widget.price);
  }

  Future<void> selectPaymentType(PaymentMethod paymentMethod) async {
    bool check = false;
    switch (paymentMethod) {
      case PaymentMethod.appelpay:
        invoice = await _paymentController.applePayEmbedded(
            context: context, invoiceValue: widget.price);
        if (widget.type == "hospitality") {
          check = await checkHospitality(false);
        }
        log('before success');
        log(check.toString());
        if (check) {
          applePayWebView();
        }

        log('after success');

        break;
      case PaymentMethod.stcpay:
        invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'STC_PAY',
          price: widget.price,
        );
        if (widget.type == "hospitality") {
          check = await checkHospitality(false);
        }
        log('before success');
        log(check.toString());
        if (widget.type == 'hospitality') {
          if (check) {
            paymentWebView();
          }
        } else {
          paymentWebView();
        }
        log('after success');

        break;
      case PaymentMethod.creditCard:
        creditValidaiotn();
        _paymentController.isNameValid(true);
        _paymentController.isCardNumberValid(true);
        _paymentController.isDateValid(true);
        _paymentController.isCvvValid(true);
        var month = '';
        var year = '';
        month = _cardDate.text.substring(0, 2);
        year = _cardDate.text.substring(3, 5);
        // if (widget.type == "hospitality") {
        //   checkHospitality(false);
        // }
        invoice = await _paymentController.creditCardPayment(
            context: context,
            creditCard: CreditCard(
                name: _cardHolder.text,
                number: _cardNumber.text,
                cvc: _cardCvv.text,
                month: month,
                year: year),
            invoiceValue: widget.price);
        if (invoice != null) {
          switch (widget.type) {
            case 'adventure':
              adventureBooking(invoice!);
              break;
            case 'tour':
              tourBooking(invoice!);
              break;
            case 'hospitality':
              hospitalityBooking(invoice!);

              break;
            case 'event':
              eventBooking(invoice!);
              break;
            default:
          }
        }
        break;
      default:
        AppUtil.errorToast(context, 'Must pick methoed');
    }
  }

  void creditValidaiotn() {
    //for fileds validation
    if (_cardHolder.text.isEmpty) {
      _paymentController.isNameValid(false);
    }
    if (_cardNumber.text.isEmpty) {
      _paymentController.isCardNumberValid(false);
    }
    if (_cardDate.text.isEmpty) {
      _paymentController.isDateValid(false);
    }
    if (_cardCvv.text.isEmpty) {
      _paymentController.isCvvValid(false);
    }
    if (_cardCvv.text.isEmpty ||
        _cardHolder.text.isEmpty ||
        _cardDate.text.isEmpty ||
        _cardNumber.text.isEmpty) {
      AppUtil.errorToast(context, 'must fill all fields');
      return;
    }
  }

  void applePayWebView() async {
    if (invoice != null) {
      Get.bottomSheet(WebViewSheet(url: invoice!.url!, title: ""))
          .then((value) async {
        Invoice? checkInvoice;

        checkInvoice = await _paymentController.applePayEmbeddedExecute(
            context: context,
            invoiceValue: widget.price,
            sessionId: invoice!.sessionId);
        if (checkInvoice == null) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/paymentFaild.gif'),
                      CustomText(
                        text: "paymentFaild".tr,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              }).then((value) async {
            await navigateToPayment(context, invoice!.url!, 'apple');
          });
        }
        if (checkInvoice == null) {
          return;
        }
        if (checkInvoice.payStatus == 'Paid') {
          //if the invoice paid then will booking depend on the type of booking
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
          log('No');

          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/paymentFaild.gif'),
                      CustomText(
                        text: "paymentFaild".tr,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              }).then((value) async {
            await navigateToPayment(context, invoice!.url!, 'apple');
          });
        }
      });
    } else {
      log('No');
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/paymentFaild.gif'),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentWebView(url: invoice!.url!, title: 'payment'.tr),
        ),
      ).then((value) async {
        Invoice? checkInvoice;

        checkInvoice = await _paymentController.getPaymentId(
            context: context, id: invoice!.id);

        if (checkInvoice!.payStatus == 'Paid') {
          //if the invoice paid then will booking depend on the type of booking
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
          log('No');

          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/paymentFaild.gif'),
                      CustomText(
                        text: "paymentFaild".tr,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              }).then((value) async {
            await navigateToPayment(context, invoice!.url!, 'else');
          });
        }
      });
    } else {
      log('No');
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/paymentFaild.gif'),
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
    final acceptedOffer = await widget.offerController!.acceptOffer(
      context: context,
      offerId: widget.offerController!.offerDetails.value.id!,
      invoiceId: checkInvoice.id,
      schedules: widget.offerController!.offerDetails.value.schedule!,
    );
    print(acceptedOffer?.orderStatus);
    //Get.back();
    final book.Booking? fetchedBooking =
        await _RequestController.getBookingById(
            context: context, bookingId: widget.booking!.id!);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/paymentSuccess.gif'),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      print("inside");
      Get.offAll(() => const TouristBottomBar());
      Get.delete<TimerController>(force: true);
      LocalNotification().showNotification(
          context,
          widget.booking?.id,
          widget.booking?.timeToGo,
          widget.booking?.date,
          widget.offerController!.offers.last.name,
          widget.thePlace?.nameEn,
          widget.thePlace?.nameAr);

      Get.to(() => TicketDetailsScreen(
          booking: fetchedBooking,
          icon: SvgPicture.asset('assets/icons/place.svg'),
          bookTypeText: 'place'));
    });
  }

  void hospitalityBooking(Invoice checkInvoice) async {
    // if paid the check flag will change to true
    isSuccess = await widget.servicesController!.checkAndBookHospitality(
        context: context,
        check: true,
        paymentId: checkInvoice.id,
        hospitalityId: widget.hospitality!.id,
        date: widget.servicesController!.selectedDate.value,
        dayId: widget.hospitality!
            .daysInfo[widget.servicesController!.selectedDateIndex.value].id,
        numOfMale: widget.male!,
        numOfFemale: widget.female!,
        cost: widget.price);

    final updatedHospitality = await widget.servicesController!
        .getHospitalityById(context: context, id: widget.hospitality!.id);
    log(updatedHospitality!.booking!.first!.guestInfo.male.toString());
    log(updatedHospitality!.booking!.first!.guestInfo.female.toString());
    log(updatedHospitality!.booking!.first!.guestInfo.dayId.toString());
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/paymentSuccess.gif'),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      Get.back();
      Get.back();
      Get.back();
      print("inter notif");

      Get.to(() => TicketDetailsScreen(
            hospitality: updatedHospitality,
            icon: SvgPicture.asset('assets/icons/hospitality.svg'),
            bookTypeText: "hospitality",
          ));
    });
    LocalNotification().showHospitalityNotification(
        context,
        updatedHospitality?.booking?.first.id,
        widget.servicesController!.selectedDate.value,
        widget.hospitality!.mealTypeEn,
        widget.hospitality!.mealTypeAr,
        widget.hospitality!.titleEn,
        widget.hospitality!.titleAr);
  }

  void eventBooking(Invoice checkInvoice) async {
    await widget.eventController!.checkAndBookEvent(
        context: context,
        paymentId: checkInvoice.id,
        eventId: widget.event!.id,
        cost: widget.price,
        dayId: widget.event!
            .daysInfo![widget.eventController!.selectedDateIndex.value].id,
        person: widget.personNumber!,
        date: widget.eventController!.selectedDate.value);

    final updatedEvent = await widget.eventController!
        .getEventById(context: context, id: widget.event!.id);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/paymentSuccess.gif'),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Get.back();
      Get.back();
      Get.back();
      log("inside adventure");
      log("${updatedEvent!.booking?.last.id}");
      LocalNotification().showAdventureNotification(
          context,
          updatedEvent!.booking?.last.id,
          widget.eventController!.selectedDate.value,
          updatedEvent.nameEn,
          updatedEvent.nameAr);
      Get.to(() => TicketDetailsScreen(
            event: updatedEvent,
            icon: SvgPicture.asset('assets/icons/event.svg'),
            bookTypeText: "event",
          ));
    });
  }

  void adventureBooking(Invoice checkInvoice) async {
    await adventureController.checkAdventureBooking(
      adventureID: widget.adventure!.id,
      context: context,
      personNumber: widget.personNumber!,
      invoiceId: checkInvoice.id,
    );
    final updatedAdventure = await adventureController.getAdvdentureById(
        context: context, id: widget.adventure!.id);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/paymentSuccess.gif'),
              CustomText(
                text: "paymentSuccess".tr,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Get.back();
      Get.back();
      Get.back();
      log("inside adventure");
      log("${updatedAdventure!.booking?.last.id}");
      log(widget.adventure!.date!);
      log(widget.adventure!.nameEn!);
      log(widget.adventure!.nameAr!);

      LocalNotification().showAdventureNotification(
          context,
          updatedAdventure!.booking?.last.id,
          updatedAdventure.date,
          updatedAdventure.nameEn,
          updatedAdventure.nameAr);
      Get.to(() => TicketDetailsScreen(
            adventure: updatedAdventure,
            icon: SvgPicture.asset('assets/icons/adventure.svg'),
            bookTypeText: "adventure",
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
          widget.servicesController!.isCheckAndBookLoading.value;
    } else if (widget.type == 'adventure') {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          adventureController.ischeckBookingLoading.value;
    } else if (widget.type == 'tour') {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          widget.offerController!.isAcceptOfferLoading.value;
    } else {
      return _paymentController.isPaymentGatewayLoading.value ||
          _paymentController.isPaymenInvoiceByIdLoading.value ||
          _paymentController.isCreditCardPaymentLoading.value ||
          _paymentController.isApplePayEmbeddedLoading.value ||
          _paymentController.isApplePayExecuteLoading.value ||
          widget.eventController!.ischeckBookingLoading.value;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cardHolder.dispose();
    _cardNumber.dispose();
    _cardDate.dispose();
    _cardCvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                        TextSpan(text: '  '),
                        TextSpan(
                          text: 'sar'.tr,
                          style: TextStyle(
                            color: black,
                            fontSize: 20,
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
                          } else {
                            AppUtil.errorToast(context, "Must pick methoed");
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
                  SvgPicture.asset(
                    "assets/icons/stc.svg",
                    height: width * 0.051,
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
                    // Text('pay'),

                    SvgPicture.asset(
                      "assets/icons/applePay_icon.svg",
                      color: const Color.fromARGB(255, 0, 0, 0),
                      height: width * 0.051,
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
                  SvgPicture.asset('assets/icons/logos_mastercard.svg'),
                  SizedBox(
                    width: width * 0.005,
                  ),
                  SvgPicture.asset('assets/icons/logos_visa.svg'),
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
              SizedBox(
                height: width * 0.030,
              ),
              if (_selectedPaymentMethod == PaymentMethod.creditCard)
                CreditForm(
                    paymentController: _paymentController,
                    cardHolder: _cardHolder,
                    cardDate: _cardDate,
                    cardNumber: _cardNumber,
                    cardCvv: _cardCvv),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateToPayment(
      BuildContext context, String url, String type) async {
    if (type == 'apple') {
      await Get.bottomSheet(WebViewSheet(url: url, title: ""));
    } else {
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
  }
}
