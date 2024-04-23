import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/payment/check_out_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReservaationDetailsWidget extends StatefulWidget {
  const ReservaationDetailsWidget(
      {super.key,
      required this.context,
      required this.color,
      required this.serviceController,
      this.hospitality,
      this.avilableDate});

  final BuildContext context;
  final Color color;

  final SrvicesController serviceController;
  final Hospitality? hospitality;
  final List<DateTime>? avilableDate;

  @override
  State<ReservaationDetailsWidget> createState() =>
      _ReservaationDetailsWidgetState();
}

class _ReservaationDetailsWidgetState extends State<ReservaationDetailsWidget> {
  final _formKey = GlobalKey<FormState>();

  int selectedChoice = 3;

  int guestNum = 0;
  int femaleGuestNum = 0;
  int maleGuestNum = 0;

  Invoice? invoice;
  bool isCheckingForPayment = false;

  PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => Stack(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Form(
                        key: _formKey,
                        child: ListView(children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Align(
                            child: Icon(
                              Icons.keyboard_arrow_up_outlined,
                              size: 30,
                            ),
                          ),
                          CustomText(
                            text: "date".tr,
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Align(
                            alignment: AppUtil.rtlDirection(context)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: CustomTextWithIconButton(
                              onTap: () {
                                print("object");
                                setState(() {
                                  selectedChoice = 3;
                                });
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CalenderDialog(
                                        fromAjwady: false,
                                        type: 'hospitality',
                                        avilableDate: widget.avilableDate,
                                        srvicesController:
                                            widget.serviceController,
                                        hospitality: widget.hospitality,
                                      );
                                    });
                              },
                              height: height * 0.06,
                              width: width * 0.65,
                              title: widget.serviceController
                                      .isHospatilityDateSelcted.value
                                  ? widget.serviceController.selectedDate.value
                                      .toString()
                                      .substring(0, 10)
                                  : 'mm/dd/yyy'.tr,
                              borderColor: lightGreyColor,
                              prefixIcon: SvgPicture.asset(
                                'assets/icons/Time (2).svg',
                                //  color: widget.color,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_forward_ios,
                                color: widget.color,
                                size: 15,
                              ),
                              textColor: almostGrey,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          if (widget
                                  .serviceController.selectedDateIndex.value !=
                              -1)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                CustomText(
                                  text: "guests2".tr,
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                CustomText(
                                  text: "${"totalNumOfGeusts".tr} : $guestNum",
                                  color: almostGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  height: 64,
                                  width: 380,
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  margin: EdgeInsets.only(
                                      top: height * 0.02, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: lightGreyColor),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        text: "male".tr,
                                        fontWeight: FontWeight.w200,
                                        color: textGreyColor,
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                          onTap: () {
                                            if (guestNum > 0 &&
                                                maleGuestNum > 0) {
                                              setState(() {
                                                guestNum = guestNum - 1;
                                                maleGuestNum = maleGuestNum - 1;
                                                if (guestNum <= 10) {}
                                              });
                                            }
                                          },
                                          child: const Icon(
                                              Icons.horizontal_rule_outlined,
                                              color: darkGrey)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      CustomText(
                                        text: maleGuestNum.toString(),
                                        color: tileGreyColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            if (guestNum <=
                                                widget
                                                    .hospitality!
                                                    .daysInfo[widget
                                                        .serviceController
                                                        .selectedDateIndex
                                                        .value]
                                                    .seats) {
                                              setState(() {
                                                guestNum = guestNum + 1;
                                                maleGuestNum = maleGuestNum + 1;
                                              });
                                            }
                                          },
                                          child: const Icon(Icons.add,
                                              color: darkGrey)),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 64,
                                  width: 380,
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  margin: EdgeInsets.only(
                                      top: height * 0.02, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: lightGreyColor),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        text: "female".tr,
                                        fontWeight: FontWeight.w200,
                                        color: textGreyColor,
                                        fontSize: 14,
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                          onTap: () {
                                            if (guestNum > 0 &&
                                                femaleGuestNum > 0) {
                                              setState(() {
                                                guestNum = guestNum - 1;
                                                femaleGuestNum =
                                                    femaleGuestNum - 1;
                                                if (guestNum <= 10) {}
                                              });
                                            }
                                          },
                                          child: const Icon(
                                              Icons.horizontal_rule_outlined,
                                              color: darkGrey)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      CustomText(
                                        text: femaleGuestNum.toString(),
                                        color: tileGreyColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            if (guestNum <=
                                                widget
                                                    .hospitality!
                                                    .daysInfo[widget
                                                        .serviceController
                                                        .selectedDateIndex
                                                        .value]
                                                    .seats) {
                                              setState(() {
                                                guestNum = guestNum + 1;
                                                femaleGuestNum =
                                                    femaleGuestNum + 1;
                                              });
                                            }
                                          },
                                          child: const Icon(Icons.add,
                                              color: darkGrey)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.1,
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    text: "totaltotalPrice".tr,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  CustomText(
                                    text: (widget.hospitality!.price * guestNum)
                                            .toString() +
                                        ' ' +
                                        'sar'.tr,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                  )
                                ],
                              ),
                              Spacer(),
                           widget.serviceController.isCheckAndBookLoading.value  ||  paymentController.isPaymenInvoiceLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: purple,
                                    ))
                                  : CustomButton(
                                      buttonColor: widget.color,
                                      iconColor: widget.color == purple
                                          ? darkPurple
                                          : darkPink,
                                      title: "book".tr,
                                      onPressed: () async {
                                        if (guestNum == 0 ||
                                            widget
                                                    .serviceController
                                                    .isHospatilityDateSelcted
                                                    .value ==
                                                false) {
                                          AppUtil.errorToast(
                                              context, 'Enter all data');
                                        } else {
                                          final isSuccess = await widget
                                              .serviceController
                                              .checkAndBookHospitality(
                                                  context: context,
                                                  check: false,
                                                  hospitalityId:
                                                      widget.hospitality!.id,
                                                  date: widget.serviceController
                                                      .selectedDate.value,

                                                  //   '${widget.hospitality!.daysInfo[widget.serviceController.selectedDateIndex.value].startTime.substring(11)}',
                                                  dayId: widget
                                                      .hospitality!
                                                      .daysInfo[widget
                                                          .serviceController
                                                          .selectedDateIndex
                                                          .value]
                                                      .id,
                                                  numOfMale: maleGuestNum,
                                                  numOfFemale: femaleGuestNum,
                                                  cost: (widget
                                                          .hospitality!.price *
                                                      guestNum));

                                          print("isSuccess : $isSuccess");

                                          if (isSuccess) {
                                            print("invoice != null");
                                            print(invoice != null);

                                            invoice ??= await paymentController
                                                .paymentInvoice(
                                                    context: context,
                                                    description: 'DESCRIPTION',
                                                    amount: (widget.hospitality!
                                                            .price *
                                                        guestNum));
                                            if (invoice != null) {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PaymentWebView(
                                                                  url: invoice!
                                                                      .url!,
                                                                  title:
                                                                      'Payment')))
                                                  .then((value) async {
                                                setState(() {
                                                  isCheckingForPayment = true;
                                                });

                                                final checkInvoice =
                                                    await paymentController
                                                        .paymentInvoiceById(
                                                            context: context,
                                                            id: invoice!.id);

                                                if (checkInvoice!
                                                        .invoiceStatus !=
                                                    'faild') {
                                                  final isSuccess = await widget
                                                      .serviceController
                                                      .checkAndBookHospitality(
                                                          context: context,
                                                          check: true,
                                                          cost: (widget
                                                                  .hospitality!
                                                                  .price *
                                                              guestNum),
                                                          date: widget
                                                              .serviceController
                                                              .selectedDate
                                                              .value,
                                                          hospitalityId: widget
                                                              .hospitality!.id,
                                                          dayId: widget
                                                              .hospitality!
                                                              .daysInfo[widget
                                                                  .serviceController
                                                                  .selectedDateIndex
                                                                  .value]
                                                              .id,
                                                          numOfMale:
                                                              maleGuestNum,
                                                          numOfFemale:
                                                              femaleGuestNum,
                                                          paymentId:
                                                              invoice!.id);
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
                                                    Get.back();
                                                    Get.back();
                                                  

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
                                                        });
                                                  }
                                                } else {}
                                              });
                                            }
                                          }
                                        }
                                      },
                                      icon: !AppUtil.rtlDirection(context)
                                          ? const Icon(Icons.arrow_back_ios)
                                          : const Icon(Icons.arrow_forward_ios),
                                      customWidth: width * 0.5,
                                    )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                        ]),
                      )),
                  if (isCheckingForPayment)
                    Center(
                        child: Container(
                            height: 150,
                            width: 180,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator.adaptive(),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  text: 'checkingForPayment'.tr,
                                  color: colorGreen,
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            )))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _openTimePicker(BuildContext context) {
    BottomPicker.time(
      title: '',
      buttonStyle: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: purple,
        ),
      ),
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.orange,
      ),
      onSubmit: (index) {
        print(index);
      },
      onChange: (time) {
        widget.serviceController.selectedTime(time.toString());
      },
      onClose: () {
        print('Picker closed');
      },
      //  bottomPickerTheme: BottomPickerTheme.orange,
      use24hFormat: true,
      minTime: Time(
          hours: DateTime.parse(widget
                  .hospitality!
                  .daysInfo[widget.serviceController.selectedDateIndex.value]
                  .startTime)
              .hour,
          minutes: DateTime.parse(widget
                  .hospitality!
                  .daysInfo[widget.serviceController.selectedDateIndex.value]
                  .startTime)
              .minute),
      initialTime: Time(
          hours: DateTime.parse(widget
                  .hospitality!
                  .daysInfo[widget.serviceController.selectedDateIndex.value]
                  .startTime)
              .hour,
          minutes: DateTime.parse(widget
                  .hospitality!
                  .daysInfo[widget.serviceController.selectedDateIndex.value]
                  .startTime)
              .minute),
      maxTime: Time(
          hours: DateTime.parse(widget
                  .hospitality!
                  .daysInfo[widget.serviceController.selectedDateIndex.value]
                  .endTime)
              .hour,
          minutes: DateTime.parse(widget
                  .hospitality!
                  .daysInfo[widget.serviceController.selectedDateIndex.value]
                  .endTime)
              .minute),
    ).show(context);
  }
}
