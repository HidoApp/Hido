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
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReservaationDetailsWidget extends StatefulWidget {
  const ReservaationDetailsWidget(
      {super.key,
      required this.color,
      required this.serviceController,
      this.hospitality,
      this.avilableDate});

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
        // Get.back();
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Align(
            child: Obx(
              () => SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Form(
                          key: _formKey,
                          child: ListView(shrinkWrap: true, children: [
                            const SizedBox(
                              height: 5,
                            ),

                            const Align(
                              child: Icon(
                                Icons.keyboard_arrow_up_outlined,
                                size: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CustomText(
                                  text: "Booking Details",
                                  fontSize: 20,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                CustomText(
                                  text: "guests2".tr,
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
                              ],
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
                                    ? widget
                                        .serviceController.selectedDate.value
                                        .toString()
                                        .substring(0, 10)
                                    : 'mm/dd/yyy'.tr,
                                borderColor: lightGreyColor,
                                prefixIcon: SvgPicture.asset(
                                  'assets/icons/Time (2).svg',
                                  //  color: widget.color,
                                ),
                                suffixIcon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: almostGrey,
                                  size: 15,
                                ),
                                textColor: almostGrey,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            // if (widget
                            //         .serviceController.selectedDateIndex.value !=
                            //     -1)

                            const SizedBox(
                              height: 10,
                            ),
                            widget.serviceController.isCheckAndBookLoading
                                        .value ||
                                    paymentController
                                        .isPaymenInvoiceLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: purple,
                                  ))
                                : CustomButton(
                                    iconColor: widget.color == purple
                                        ? darkPurple
                                        : darkPink,
                                    title: "confirm".tr,
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
                                                cost:
                                                    (widget.hospitality!.price *
                                                        guestNum));

                                        print("isSuccess : $isSuccess");

                                        if (isSuccess) {
                                          print("invoice != null");
                                          print(invoice != null);

                                          invoice ??= await paymentController
                                              .paymentInvoice(
                                                  context: context,
                                                  description: 'DESCRIPTION',
                                                  amount: (widget
                                                          .hospitality!.price *
                                                      guestNum));
                                          if (invoice != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentWebView(
                                                            url: invoice!.url!,
                                                            title:
                                                                'Payment'))).then(
                                                (value) async {
                                              setState(() {
                                                isCheckingForPayment = true;
                                              });

                                              final checkInvoice =
                                                  await paymentController
                                                      .paymentInvoiceById(
                                                          context: context,
                                                          id: invoice!.id);

                                              if (checkInvoice!.invoiceStatus !=
                                                  'faild') {
                                                final isSuccess = await widget
                                                    .serviceController
                                                    .checkAndBookHospitality(
                                                        context: context,
                                                        check: true,
                                                        cost:
                                                            (widget.hospitality!
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
                                                        numOfMale: maleGuestNum,
                                                        numOfFemale:
                                                            femaleGuestNum,
                                                        paymentId: invoice!.id);
                                                setState(() {
                                                  isCheckingForPayment = false;
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

class ReservaationDetailsAdventureWidget extends StatefulWidget {
  const ReservaationDetailsAdventureWidget(
      {super.key,
      required this.color,
      required this.serviceController,
      this.hospitality,
      this.avilableDate});

  final Color color;

  final SrvicesController serviceController;
  final Hospitality? hospitality;
  final List<DateTime>? avilableDate;

  @override
  State<ReservaationDetailsAdventureWidget> createState() =>
      _ReservaationDetailsAdventureWidgetState();
}

class _ReservaationDetailsAdventureWidgetState extends State<ReservaationDetailsAdventureWidget> {


@override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    widget.serviceController.isAdventureTimeSelcted(false);

  
  }



  final _formKey = GlobalKey<FormState>();

  int selectedChoice = 3;
    late DateTime time, returnTime, newTimeToGo = DateTime.now();

  int guestNum = 0;
  int femaleGuestNum = 0;
  int maleGuestNum = 0;
 bool showErrorGuests = false;
  bool showErrorDate = false;
 bool showErrorTime = false;

TextEditingController _controller = TextEditingController();

  Invoice? invoice;
  bool isCheckingForPayment = false;

  PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
     time = DateTime.now();

    return GestureDetector(
      onTap: () {
        // Get.back();
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Align(
            child: Obx(
              () => SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Form(
                          key: _formKey,
                          child: ListView(shrinkWrap: true, children: [
                            const SizedBox(
                              height: 5,
                            ),

                            const Align(
                              child: Icon(
                                Icons.keyboard_arrow_up_outlined,
                                size: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CustomText(
                                  text: "Booking Details",
                                  fontSize: 20,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                
                                CustomText(
                                  text: "guests2".tr,
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,

                                ),
                          //       SizedBox(
                          //     height: height * 0.02,
                          // ),
                          // Container(
 
                          //         height: 48,
                          //         width: 342,
                          //         padding: const EdgeInsets.only(
                          //           left: 1,
                          //           right: 1,
                          //         ),
                          //         margin: EdgeInsets.only(
                          //             top: height * 0.02, bottom: 5),
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(8)
                          //           ),
//                                child: TextFormField(
//   controller: _controller,
//   readOnly: true, // Make the text field read-only
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return ;
//     }
//     return null;
//   },
  
//   decoration: InputDecoration(
//     hintText: "guests2".tr,
//     errorText:'You need to add at least one guest' , // Initial value
//     border: OutlineInputBorder(),
//     suffixIcon: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Spacer(),

//         GestureDetector(
//           onTap: () {
//             setState(() {
//               if (guestNum > 0) {
//                 guestNum = guestNum - 1;
//                 maleGuestNum = maleGuestNum - 1;
//                 _controller.text = maleGuestNum.toString();
//               }
//             });
//           },
//           child: const Icon(
//             Icons.horizontal_rule_outlined,
//             color:darkGrey,
//           ),
//         ),
//         const SizedBox(width: 15),
//         Text(
//           maleGuestNum.toString(),
//           style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
//         ),
//         const SizedBox(width: 15),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               guestNum = guestNum + 1;
//               maleGuestNum = maleGuestNum + 1;
//               _controller.text = maleGuestNum.toString();
//             });
//           },
//           child: const Icon(
//             Icons.add,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
                          //),
                                Container(
                                  
                                  height: 48,
                                  width: 342,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  margin: EdgeInsets.only(
                                      top: height * 0.02, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                   color: showErrorGuests ? Colors.red : lightGreyColor,
                                        ),                                 
                                         ),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        text: "guests2".tr,
                                        fontWeight: FontWeight.w200,
                                        color: textGreyColor,
                                      ),
                                      Spacer(),
GestureDetector(
  onTap: () {
    setState(() {
      if (guestNum > 0) {
        guestNum = guestNum - 1;
        maleGuestNum = maleGuestNum - 1;
      }
    });
  },
  child: const Icon(
    Icons.horizontal_rule_outlined,
    color: darkGrey,
  ),
),
const SizedBox(width: 15),
CustomText(
  text: maleGuestNum.toString(),
  color: tileGreyColor,
  fontSize: 18,
  fontWeight: FontWeight.w400,
),
const SizedBox(width: 15),
GestureDetector(
  onTap: () {
    setState(() {
      guestNum = guestNum + 1;
      maleGuestNum = maleGuestNum + 1;
    });
  },
  child: const Icon(
    Icons.add,
    color: darkGrey,
  ),
),
                                    ],
                                  ),
                                ),

                                if (showErrorGuests)
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'You need to add at least one guest',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
                                // Container(
                                //   height: 64,
                                //   width: 380,
                                //   padding: const EdgeInsets.only(
                                //     left: 15,
                                //     right: 15,
                                //   ),
                                //   margin: EdgeInsets.only(
                                //       top: height * 0.02, bottom: 5),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     border: Border.all(color: lightGreyColor),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       CustomText(
                                //         text: "female".tr,
                                //         fontWeight: FontWeight.w200,
                                //         color: textGreyColor,
                                //         fontSize: 14,
                                //       ),
                                //       Spacer(),
                                //       GestureDetector(
                                //           onTap: () {
                                //             if (guestNum > 0 &&
                                //                 femaleGuestNum > 0) {
                                //               setState(() {
                                //                 guestNum = guestNum - 1;
                                //                 femaleGuestNum =
                                //                     femaleGuestNum - 1;
                                //                 if (guestNum <= 10) {}
                                //               });
                                //             }
                                //           },
                                //           child: const Icon(
                                //               Icons.horizontal_rule_outlined,
                                //               color: darkGrey)),
                                //       const SizedBox(
                                //         width: 15,
                                //       ),
                                //       CustomText(
                                //         text: femaleGuestNum.toString(),
                                //         color: tileGreyColor,
                                //         fontSize: 18,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //       const SizedBox(
                                //         width: 15,
                                //       ),
                                //       GestureDetector(
                                //           onTap: () {
                                //             if (guestNum <=
                                //                 widget
                                //                     .hospitality!
                                //                     .daysInfo[widget
                                //                         .serviceController
                                //                         .selectedDateIndex
                                //                         .value]
                                //                     .seats) {
                                //               setState(() {
                                //                 guestNum = guestNum + 1;
                                //                 femaleGuestNum =
                                //                     femaleGuestNum + 1;
                                //               });
                                //             }
                                //           },
                                //           child: const Icon(Icons.add,
                                //               color: darkGrey)),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            CustomText(
                              text: "date".tr,
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Align(
                              alignment: !AppUtil.rtlDirection2(context)
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
                                 height: height * 0.060,
                                 width: width * 0.95,
                                title: widget.serviceController
                                        .isHospatilityDateSelcted.value
                                    ? widget
                                        .serviceController.selectedDate.value
                                        .toString()
                                        .substring(0, 10)
                                    : 'mm/dd/yyy'.tr,
                                borderColor: lightGreyColor,
                                prefixIcon: SvgPicture.asset(
                                  'assets/icons/Time (2).svg',
                                  //  color: widget.color,
                                ),
                                suffixIcon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: almostGrey,
                                  size: 15,
                                ),
                                textColor: almostGrey,
                              ),
                            ),
                            
                                if (showErrorDate)
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'You need to select date',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
                             SizedBox(
                              height: height * 0.02,
                            ),

  CustomText(
                            text: "Time",
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Align(
                            alignment: !AppUtil.rtlDirection2(context)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: CustomTextWithIconButton(
                              onTap: () {
                                showCupertinoModalPopup<void>(
                                    context: context,
                                    // barrierColor: Colors.white,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            
                                            decoration: const BoxDecoration(
                                              color: Color(0xffffffff),
                                              border: Border(
                                                bottom: BorderSide(
                                                  //  color: Color(0xff999999),
                                                  width: 0.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                CupertinoButton(
                                                  onPressed: () {
                                                    widget.serviceController.isAdventureTimeSelcted
                                                        (
                                                            true);
                                                    setState(() {
                                                      Get.back();
                                                      time = newTimeToGo;
                                                    });
                                                  },
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 5.0,
                                                  ),
                                                  child: CustomText(
                                                    text: "confirm".tr,
                                                    color: colorGreen,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 220,
                                            width: width,
                                            margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child: Container(
                                              width: width,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                backgroundColor: Colors.white,
                                                initialDateTime: newTimeToGo,
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                use24hFormat: false,
                                                onDateTimeChanged:
                                                    (DateTime newT) {
                                                  print(DateFormat('HH:mm:ss')
                                                      .format(newTimeToGo));
                                                  setState(() {
                                                    newTimeToGo = newT;
                                                    //   print(newTime);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              height: height * 0.060,
                                 width: width * 0.95,
                              title: !widget.serviceController.isAdventureTimeSelcted
                                      .value
                                  ? "00 :00 AM"
                                  : DateFormat('hh:mm a').format(newTimeToGo),
                              //  test,
                              borderColor: lightGreyColor,
                              prefixIcon: SvgPicture.asset(
                                "assets/icons/time_icon.svg",
                              ),
                              // suffixIcon: Container(),
                               suffixIcon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: almostGrey,
                                  size: 15,
                                ),
                                textColor: almostGrey,
                            ),
                          ),
                     

                                if (showErrorTime)
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'You need to select the time',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),





                            SizedBox(
                              height: height * 0.03,
                            ),
                            if (widget
                                    .serviceController.selectedDateIndex.value !=
                                -1)

                            const SizedBox(
                              height: 10,
                            ),
                            widget.serviceController.isCheckAndBookLoading
                                        .value ||
                                    paymentController
                                        .isPaymenInvoiceLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: purple,
                                  ))
                                : CustomButton(
                                    iconColor: widget.color == purple
                                        ? darkPurple
                                        : darkPink,
                                    title: "confirm".tr,
                                    onPressed: () async {
                                       
                                        setState(() {
                                          showErrorGuests = guestNum == 0 && widget.serviceController.isHospatilityDateSelcted.value==true || guestNum == 0 && widget.serviceController.isAdventureTimeSelcted.value==true;
                                           showErrorDate = guestNum == 1 && widget.serviceController.isHospatilityDateSelcted.value==false  || widget.serviceController.isHospatilityDateSelcted.value==false &&  widget.serviceController.isAdventureTimeSelcted.value==true ;
                                          showErrorTime = guestNum == 1 && widget.serviceController.isAdventureTimeSelcted.value==false || widget.serviceController.isAdventureTimeSelcted.value==false && widget.serviceController.isHospatilityDateSelcted.value== true;
                                          });
                                      if (guestNum == 0 && widget
                                                  .serviceController
                                                  .isHospatilityDateSelcted
                                                  .value ==false && widget.serviceController.isAdventureTimeSelcted.value==false
                                              ) {
                                        AppUtil.errorToast(
                                            context, 'Enter all data');
                                     
                                     
                                      } 
                                      else {
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
                                                cost:
                                                    (widget.hospitality!.price *
                                                        guestNum));

                                        print("isSuccess : $isSuccess");

                                        if (isSuccess) {
                                          print("invoice != null");
                                          print(invoice != null);

                                          invoice ??= await paymentController
                                              .paymentInvoice(
                                                  context: context,
                                                  description: 'DESCRIPTION',
                                                  amount: (widget
                                                          .hospitality!.price *
                                                      guestNum));
                                          if (invoice != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentWebView(
                                                            url: invoice!.url!,
                                                            title:
                                                                'Payment'))).then(
                                                (value) async {
                                              setState(() {
                                                isCheckingForPayment = true;
                                              });

                                              final checkInvoice =
                                                  await paymentController
                                                      .paymentInvoiceById(
                                                          context: context,
                                                          id: invoice!.id);

                                              if (checkInvoice!.invoiceStatus !=
                                                  'faild') {
                                                final isSuccess = await widget
                                                    .serviceController
                                                    .checkAndBookHospitality(
                                                        context: context,
                                                        check: true,
                                                        cost:
                                                            (widget.hospitality!
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
                                                        numOfMale: maleGuestNum,
                                                        numOfFemale:
                                                            femaleGuestNum,
                                                        paymentId: invoice!.id);
                                                setState(() {
                                                  isCheckingForPayment = false;
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