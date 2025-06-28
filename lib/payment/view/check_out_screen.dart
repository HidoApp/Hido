import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen(
      {Key? key, this.total, this.offerDetails, this.offerController})
      : super(key: key);

  final int? total;
  final OfferDetails? offerDetails;
  final OfferController? offerController;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

final creditCardInfo = [
  {
    'bank': 'Axis Bank',
    'cardNum': '374245455400126',
    'icon': 'assets/icons/logos_mastercard.svg'
  },
  {
    'bank': 'HDFC Bank',
    'cardNum': '374245455400126',
    'icon': 'assets/icons/logos_visa.svg'
  },
];

enum PaymentType {
  creditCard,
  applePay,
  stcPay,
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  PaymentType? _payment;
  int? cardValue = -1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: CustomAppBar("checkout".tr),
      body: SingleChildScrollView(
        child: Container(
          height: height * 0.88,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "creditAndDebit".tr,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: width * 0.95,
                // height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: lightGrey.withOpacity(0.7)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: const [
                      BoxShadow(
                          color: lightGrey,
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(1, 8))
                    ]),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: width * 0.85,
                        decoration: BoxDecoration(
                            border: Border.all(color: lightGrey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          SvgPicture.asset('assets/icons/logos_mastercard.svg'),
                          const SizedBox(
                            width: 2,
                          ),
                          SvgPicture.asset('assets/icons/logos_visa.svg'),
                          const SizedBox(
                            width: 6,
                          ),
                          CustomText(text: 'creditCard'.tr),
                          // CustomText(
                          //     text: creditCardInfo[i]['cardNum']!
                          //         .replaceRange(0, 10, '**********')),
                          const Spacer(),
                          Radio<PaymentType>(
                            value: PaymentType.creditCard,
                            groupValue: _payment,
                            fillColor: WidgetStateProperty.all(colorGreen),
                            onChanged: (PaymentType? value) {
                              setState(() {
                                _payment = value;
                              });
                            },
                          ),
                        ])),
                    // Column(
                    //   children:
                    //       List<Widget>.generate(creditCardInfo.length, (int i) {
                    //     return Column(
                    //       children: [
                    //         Container(
                    //           padding: EdgeInsets.symmetric(horizontal: 10),
                    //           width: width * 0.85,
                    //           decoration: BoxDecoration(
                    //               border: Border.all(color: lightGrey),
                    //               borderRadius: BorderRadius.circular(10)),
                    //           child: Row(
                    //             children: [
                    //               SvgPicture.asset('assets/icons/logos_mastercard.svg'),
                    //              const  SizedBox(
                    //                 width: 2,
                    //               ),
                    //               SvgPicture.asset('assets/icons/logos_visa.svg'),
                    //               SizedBox(
                    //                 width: 6,
                    //               ),
                    //               CustomText(
                    //                   text:
                    //                       creditCardInfo[i]['bank'].toString() +
                    //                           "   "),
                    //               CustomText(
                    //                   text: creditCardInfo[i]['cardNum']!
                    //                       .replaceRange(0, 10, '**********')),
                    //               Spacer(),
                    //               Radio<int>(
                    //                 value: i,
                    //                 groupValue: cardValue,
                    //                 fillColor:
                    //                     MaterialStateProperty.all(colorGreen),
                    //                 onChanged: (int? value) {
                    //                   setState(() {
                    //                     cardValue = value;
                    //                     _payment = null;
                    //                   });
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         )
                    //       ],
                    //     );
                    //   }),
                    // ),

                    const SizedBox(
                      height: 20,
                    ),
                    _payment == PaymentType.creditCard
                        ? GestureDetector(
                            onTap: () {
                              // Get.bottomSheet( AddNewCreditCard(
                              //           total: widget.total!,
                              //           offerDetails: widget.offerDetails!,
                              //           offerController: widget.offerController!,
                              //         ));

                              // showModalBottomSheet(
                              //     isScrollControlled: true,
                              //     backgroundColor: Colors.transparent,
                              //     shape: const RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.only(
                              //       topRight: Radius.circular(30),
                              //       topLeft: Radius.circular(30),
                              //     )),
                              //     context: context,
                              //     builder: (context) {
                              //       return Padding(
                              //         padding: EdgeInsets.only(
                              //             bottom: MediaQuery.of(context)
                              //                 .viewInsets
                              //                 .bottom),
                              //         child:  AddNewCreditCard(
                              //           total: widget.total!,
                              //           offerDetails: widget.offerDetails!,
                              //         ),
                              //       );
                              //     });
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                      color: colorGreen,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: "addNewCard".tr,
                                  fontSize: 16,
                                  color: lightBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // CustomText(
              //   text: "other".tr,
              //   fontWeight: FontWeight.w500,
              //   fontSize: 17,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   padding: EdgeInsets.all(20),
              //   width: width * 0.95,
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       border: Border.all(color: lightGrey.withOpacity(0.7)),
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //       boxShadow: const [
              //         BoxShadow(
              //             color: lightGrey,
              //             blurRadius: 12,
              //             spreadRadius: 2,
              //             offset: Offset(1, 8))
              //       ]),
              //   child: Column(
              //     children: [
              //       Container(
              //         padding: EdgeInsets.symmetric(horizontal: 10),
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             border: Border.all(color: lightGrey)),
              //         child: Platform.isIOS
              //             ? Row(
              //                 children: [
              //                   SvgPicture.asset(
              //                       "assets/icons/applePay_icon.svg"),
              //                   Spacer(),
              //                   Radio<PaymentType>(
              //                     fillColor:
              //                         MaterialStateProperty.all(colorGreen),
              //                     value: PaymentType.applePay,
              //                     groupValue: _payment,
              //                     onChanged: (PaymentType? value) {
              //                       setState(() {
              //                         _payment = value;
              //                         //  cardValue = -1;
              //                       });
              //                     },
              //                   )
              //                 ],
              //               )
              //             : Container(),
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       Container(
              //         padding: EdgeInsets.symmetric(horizontal: 10),
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             border: Border.all(color: lightGrey)),
              //         child: Row(
              //           children: [
              //             SvgPicture.asset("assets/icons/STCPAY.svg"),
              //             Spacer(),
              //             Radio<PaymentType>(
              //               fillColor: MaterialStateProperty.all(colorGreen),
              //               value: PaymentType.stcPay,
              //               groupValue: _payment,
              //               onChanged: (PaymentType? value) {
              //                 setState(() {
              //                   _payment = value;
              //                 });
              //               },
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              const Spacer(),
              const DottedSeparator(
                color: textGreyColor,
                height: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  CustomText(
                    text: "total".tr,
                    color: black,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                  const Spacer(),
                  CustomText(
                    text: "SAR ${widget.total}",
                    color: black,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  )
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  CustomText(
                    text: "promocode".tr,
                    color: almostGrey,
                    fontSize: 14,
                  ),
                  const Spacer(),
                  const CustomText(
                    text: "−SAR 00,00",
                    color: almostGrey,
                    fontSize: 14,
                  ),
                ],
              ),
              _payment == PaymentType.applePay
                  ? const SizedBox(
                      height: 15,
                    )
                  : Container(),
              _payment == PaymentType.applePay
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(black),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        fixedSize: WidgetStateProperty.all(Size(width, 58)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomText(
                            text: "Pay with  ",
                            textAlign: TextAlign.center,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          SvgPicture.asset(
                            "assets/icons/applePay_icon.svg",
                            color: Colors.white,
                            height: 25,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              _payment == PaymentType.applePay
                  ? const SizedBox(
                      height: 5,
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
              _payment == PaymentType.stcPay
                  ? CustomButton(
                      onPressed: () {},
                      title: 'pay'.tr,
                      icon: AppUtil.rtlDirection(context)
                          ? const Icon(Icons.arrow_back)
                          : const Icon(Icons.arrow_forward),
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
