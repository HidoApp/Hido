import 'dart:developer';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/credit_card.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/widget/credit_form.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
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

class PaymentType extends StatefulWidget {
  const PaymentType(
      {super.key,
      required this.price,
      this.adventure,
      required this.type,
      this.hospitality,
      this.personNumber});
  final int price;
  final String type;
  final int? personNumber;
  final Adventure? adventure;
  final Hospitality? hospitality;
  @override
  State<PaymentType> createState() => _PaymentTypeState();
}

class _PaymentTypeState extends State<PaymentType> {
  PaymentMethod? _selectedPaymentMethod;
  Invoice? invoice;
  final adventureController = Get.put(AdventureController());
  final _paymentController = Get.put(PaymentController());
  final _cardHolder = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardDate = TextEditingController();
  final _cardCvv = TextEditingController();

  Future<void> selectPaymentType(PaymentMethod paymentMethod) async {
    if (paymentMethod == PaymentMethod.appelpay) {
      invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'APPLE_PAY',
          price: widget.price);
      if (invoice != null) {
        Get.to(
          () => PaymentWebView(url: invoice!.url!, title: 'payment'.tr),
        );
        adventureBookingWebView();
      } else {
        print('invoice nulll');
      }
    } else if (paymentMethod == PaymentMethod.stcpay) {
      invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'STC_PAY',
          price: widget.price);
      adventureBookingWebView();
    } else if (paymentMethod == PaymentMethod.creditCard) {
      creditValidaiotn();
      _paymentController.isNameValid(true);
      _paymentController.isCardNumberValid(true);
      _paymentController.isDateValid(true);
      _paymentController.isCvvValid(true);

      var month = '';
      var year = '';
      month = _cardDate.text.substring(0, 2);
      year = _cardDate.text.substring(3, 5);
      invoice = await _paymentController.creditCardPayment(
          context: context,
          creditCard: CreditCard(
              name: _cardHolder.text,
              number: _cardNumber.text,
              cvc: _cardCvv.text,
              month: month,
              year: year),
          invoiceValue: widget.price);
      adventureBooking();
    } else {
      AppUtil.errorToast(context, 'Must pick methoed');
    }
  }

  void creditValidaiotn() {
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

//TODO : must fix error of item not found

  void adventureBookingWebView() async {
    // invoice = await _paymentController.paymentInvoice(
    //     context: context, InvoiceValue: widget.price);
    if (invoice != null) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentWebView(url: invoice!.url!, title: 'Payment')))
          .then((value) async {
        final checkInvoice = await _paymentController.paymentInvoiceById(
            context: context, id: invoice!.id);

        print("this state");
        print(checkInvoice!.invoiceStatus);

        if (checkInvoice.invoiceStatus != 'Paid') {
          // await _adventureController
          //     .checkAdventureBooking(
          //         adventureID: widget.adventure.id,
          //         context: context,
          //         personNumber: widget.person,
          //         invoiceId: invoice!.id);

          print('No');
          // if (checkInvoice.invoiceStatus == 'failed' ||
          //     checkInvoice.invoiceStatus ==
          //         'initiated') {
          // Get.back();
          await navigateToPayment(context, invoice!.url!);

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
                      CustomText(text: "paymentFaild"),
                    ],
                  ),
                );
              });
        } else {
          print('YES');
          print(invoice?.invoiceStatus);

          //Get.back();
          // Get.back();
          await adventureController.checkAdventureBooking(
            adventureID: widget.adventure!.id,
            context: context,
            personNumber: widget.personNumber!,
            invoiceId: checkInvoice.id,
          );

          final updatedAdventure = await adventureController.getAdvdentureById(
              context: context, id: widget.adventure!.id);

          print('check');
          print(updatedAdventure);

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
                    CustomText(text: "paymentSuccess"),
                  ],
                ),
              );
            },
          ).then((_) {
            Get.back();
            Get.back();
            Get.back();
            print("inside notifi");

            Get.to(() => TicketDetailsScreen(
                  adventure: updatedAdventure,
                  icon: SvgPicture.asset('assets/icons/adventure.svg'),
                  bookTypeText: 'adventure',
                ));
            LocalNotification().showAdventureNotification(
                context,
                updatedAdventure!.booking?.last.id,
                widget.adventure!.date,
                widget.adventure!.nameEn,
                widget.adventure!.nameAr);
          });
        }
      });
    }
  }

  void adventureBooking() async {
    if (invoice == null) {
      // await navigateToPayment(context, invoice!.url!);

      print("invoice nulllllll");
    } else {
      setState(() {});
      // final checkInvoice = await _paymentController.paymentInvoiceById(
      //     context: context, id: invoice!.id);
      log('YES');
      log(widget.personNumber!.toString());
      log(widget.adventure!.id.toString());
      log("${invoice?.id}");

      var book = await adventureController.checkAdventureBooking(
        adventureID: widget.adventure!.id,
        context: context,
        personNumber: widget.personNumber!,
        invoiceId: invoice?.id,
      );
      log("book.toString(");
      log(book.toString());

      final updatedAdventure = await adventureController.getAdvdentureById(
          context: context, id: widget.adventure!.id);

      // print('check');
      // print(updatedAdventure!.nameEn);

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
                CustomText(text: "paymentSuccess"),
              ],
            ),
          );
        },
      ).then((_) {
        Get.back();
        Get.back();
        Get.back();
        print("inside notifi");

        Get.to(() => TicketDetailsScreen(
              adventure: updatedAdventure,
              icon: SvgPicture.asset('assets/icons/adventure.svg'),
              bookTypeText: 'adventure',
            ));
        LocalNotification().showAdventureNotification(
            context,
            updatedAdventure!.booking?.last.id,
            widget.adventure!.date,
            widget.adventure!.nameEn,
            widget.adventure!.nameAr);
      });

      //Get.back();
      // Get.back();
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
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DottedSeparator(
              color: almostGrey,
              height: width * 0.002,
            ),
            SizedBox(
              height: 28,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'total'.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                CustomText(
                  // text: 'SAR ${widget.adventure.price.toString()}',
                  text: '${"sar".tr} ${widget.price}',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'promocode'.tr,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: almostGrey,
                ),
                const Spacer(),
                CustomText(
                  // text: 'SAR ${widget.adventure.price.toString()}',
                  text: '- ${"sar".tr} ${widget.price}',
                  fontWeight: FontWeight.w500,
                  fontSize: 15, color: almostGrey,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => _paymentController.isPaymentGatewayLoading.value ||
                      _paymentController.isCreditCardPaymentLoading.value ||
                      adventureController.ischeckBookingLoading.value
                  ? const CircularProgressIndicator.adaptive()
                  : CustomButton(
                      onPressed: () async {
                        if (_selectedPaymentMethod != null) {
                          await selectPaymentType(_selectedPaymentMethod!);

                          // switch (widget.type) {
                          //   case 'adventure':
                          //     adventurePayment();
                          //     break;
                          //   case 'tour':
                          //     break;
                          //   default:
                          // }
                        } else {
                          AppUtil.errorToast(context, "msg");
                        }
                      },
                      title: 'pay'.tr,
                      icon: const Icon(Icons.keyboard_arrow_right,
                          color: Colors.white),
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
            left: 16,
            right: 16,
            top: 12,
            bottom: 32,
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
                    value: PaymentMethod.creditCard,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  SvgPicture.asset('assets/icons/logos_mastercard.svg'),
                  const SizedBox(
                    width: 2,
                  ),
                  SvgPicture.asset('assets/icons/logos_visa.svg'),
                  SizedBox(
                    width: 6,
                  ),
                  CustomText(
                    text: 'creditCard'.tr,
                    color: Color(0xFF070708),
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
                    color: Color.fromARGB(255, 0, 0, 0),
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

              // SizedBox(
              //   height: width * 0.25,
              // ),
              if (_selectedPaymentMethod == PaymentMethod.creditCard)
                CreditForm(
                    paymentController: _paymentController,
                    cardHolder: _cardHolder,
                    cardDate: _cardDate,
                    cardNumber: _cardNumber,
                    cardCvv: _cardCvv),

              // SizedBox(
              //   height: width * 0.25,
              // ),

              //discount widget
              // const PromocodeField(),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
