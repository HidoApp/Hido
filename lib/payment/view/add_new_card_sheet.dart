import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddNewCreditCard extends StatefulWidget {
  const AddNewCreditCard({
    Key? key,
    required this.total,
    required this.offerDetails,
    required this.offerController,
  }) : super(key: key);

  final int total;
  final OfferDetails offerDetails;
  final OfferController offerController;

  @override
  State<AddNewCreditCard> createState() => _AddNewCreditCardState();
}

class _AddNewCreditCardState extends State<AddNewCreditCard> {
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardNumContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late bool showCVV;
  final _paymentController = Get.put(PaymentController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCVV = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: StatefulBuilder(builder: (context, onfunction) {
        return Obx(
          () => Container(
            height: height * 0.7,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        text: "addNewCard".tr,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        text: "cardNumber".tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      child: CustomTextField(
                        controller: cardNumContoller,
                        borderColor: tileGreyColor,
                        onChanged: (String value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumberInputFormatter()
                        ],
                        hintText: "enter12digitCardNumber".tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(
                                  text: "validThru".tr,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  width: width * 0.42,
                                  child: CustomTextField(
                                    controller: dateController,
                                    borderColor: tileGreyColor,
                                    // icon: SvgPicture.asset(
                                    //   "assets/icons/calendar.svg",
                                    //   color: tileGreyColor,
                                    //   height: 25,
                                    // ),
                                    maxLength: 5,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      CardMonthInputFormatter()
                                    ],
                                    keyboardType: TextInputType.number,
                                    onChanged: (String value) {},
                                    hintText: "MM/YY",
                                  )),
                            ],
                          ),
                          //  Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(
                                  text: "cvv".tr,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  width: width * 0.3,
                                  child: CustomTextField(
                                    controller: cvvController,
                                    borderColor: tileGreyColor,
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    obscureText: !showCVV,
                                    onChanged: (String value) {},
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    hintText: "CVV",
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showCVV = !showCVV;
                                          });
                                        },
                                        child: Icon(
                                          showCVV == true
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF969696),
                                        )),
                                  )),
                            ],
                          ),
                          SizedBox(
                            width: 60,
                          )
                        ],
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     Spacer(),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        text: "cardHolderName".tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: cardNameController,
                      borderColor: tileGreyColor,
                      onChanged: (String value) {},
                      hintText: "nameOnCard".tr,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Obx(
                    //   () =>

                    _paymentController.isCreditCardPaymentLoading.value
                        ? CircularProgressIndicator()
                        : CustomButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                AppUtil.errorToast(
                                    context, 'all feild are required'.tr);
                                return;
                              }

                              //card num   validation
                              if (cardNumContoller.text.length < 16) {
                                AppUtil.errorToast(
                                    context, 'invalid card number');
                                return;
                              }
                              final cardNum =
                                  cardNumContoller.text.removeAllWhitespace;

                              //cvv validation
                              if (dateController.text.length < 5) {
                                AppUtil.errorToast(
                                    context, 'invalid date number');
                                return;
                              }
                              final month = dateController.text.substring(0, 2);
                              final year = dateController.text.substring(3, 5);
                              if (int.parse(year) <
                                  int.parse(DateTime.now()
                                      .year
                                      .toString()
                                      .substring(2, 4))) {
                                AppUtil.errorToast(
                                    context, 'invalid date number');
                                return;
                              }

                              //cvv validation
                              if (cvvController.text.length < 3) {
                                AppUtil.errorToast(
                                    context, 'invalid cvv number');
                                return;
                              }
                              final cvv = cvvController.text;

                              //name validation
                              var regExp = new RegExp(r"\w+(\'\w+)?");
                              int wordscount = regExp
                                  .allMatches(cardNameController.text.trim())
                                  .length;
                              print('wordscount : $wordscount');
                              if (wordscount != 2) {
                                AppUtil.errorToast(context, 'invalid name');
                                return;
                              }
                              final cardName = cardNameController.text.trim();

                              var paymentResult =
                                  await _paymentController.payWithCreditCard(
                                      context: context,
                                      requestId: widget.offerDetails.requestId!,
                                      offerId: widget.offerDetails.id!,
                                      amount: widget.total,
                                      name: cardName,
                                      number: cardNum,
                                      cvc: cvv,
                                      month: month,
                                      year: year,
                                      schedule: widget.offerDetails.schedule);

                              if (paymentResult != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentWebView(
                                            url: paymentResult.transactionUrl!,
                                            title: 'Payment'))).then(
                                    (value) async {
                                  final offer =
                                      await widget.offerController.getOfferById(
                                    context: context,
                                    offerId: widget.offerDetails.id!,
                                  );
                                  print("paymentResult.paymentStatues");
                                  print(offer!.payment!['payStatus']);

                                  if (offer.payment!['payStatus'] == 'failed') {
                                    Get.back();
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                    'assets/images/paymentFaild.gif'),
                                                CustomText(
                                                    text:
                                                        "paymentFaild".tr),
                                              ],
                                            ),
                                            // actions: <Widget>[
                                            //   TextButton(
                                            //     onPressed: () {
                                            //       Navigator.of(ctx).pop();
                                            //     },
                                            //     child: Container(
                                            //       color: Colors.green,
                                            //       padding:
                                            //           const EdgeInsets.all(14),
                                            //       child: const Text("okay"),
                                            //     ),
                                            //   ),
                                            // ],
                                          );
                                        });
                                  } else if (offer.payment!['payStatus'] ==
                                      'paid') {
                                    final acceptedOffer = await widget
                                        .offerController
                                        .acceptOffer(
                                      context: context,
                                      offerId: widget.offerDetails.id!,
                                      schedules: widget.offerController
                                          .offerDetails.value.schedule!,
                                    );
                                    Get.back();
                                    Get.back();
                                  }

                                  return;
                                });
                                // !await launchUrl(Uri.parse( paymentResult.transactionUrl!));
                              }
                            },
                            title: "pay".tr.toUpperCase(),
                            icon: AppUtil.rtlDirection(context)
                                ? Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                  ),
                          ),
                    //  )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
