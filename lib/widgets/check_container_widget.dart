import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ajwad_v4/utils/app_util.dart';

import '../constants/colors.dart';
import '../request/tourist/models/schedule.dart';

class CheckContainerWidget extends StatefulWidget {
  final OfferController? offerController;
  const CheckContainerWidget({
    super.key,
    required this.offerController,
  });

  @override
  State<CheckContainerWidget> createState() => _CheckContainerWidgetState();
}

class _CheckContainerWidgetState extends State<CheckContainerWidget> {
  List<Schedule>? scheduleList;
  @override
  void initState() {
    super.initState();
    scheduleList = widget.offerController?.offerDetails.value.schedule;
    widget.offerController?.getCheckedList(null, true);
    widget.offerController?.scheduleState.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: const EdgeInsets.only(
          top: 24,
          left: 21,
          right: 18,
          bottom: 24,
        ),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child:
                      widget.offerController?.offerDetails.value.image != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(widget
                                  .offerController!.offerDetails.value.image!),
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profile_image.png'),
                            ),
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomText(
                  text: widget.offerController?.offerDetails.value.name ?? "",
                  color: black,
                  fontSize: width * 0.038,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            CustomText(
              text: 'checkText'.tr,
              textAlign: TextAlign.start,
              color: colorDarkGrey,
              fontSize: 12,
              fontFamily: 'HT Rakik',
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 318,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFDCDCE0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Obx(
              () => Column(
                children: [
                  if (scheduleList != null)
                    ...List.generate(
                        scheduleList!.length,
                        (index) => _CustomCheckWidget(
                              isChecked:
                                  widget.offerController?.checkedList[index] ??
                                      false,
                              onTap: () {
                                bool check = !(widget
                                        .offerController?.checkedList[index] ??
                                    false);
                                widget.offerController
                                    ?.checkTotal(index, check);
                                widget.offerController
                                    ?.getTotalPrice(scheduleList, index);
                              },
                              schedule: scheduleList![index],
                              isLast: index == scheduleList!.length - 1,
                              isBold: !(index == 0 || index == 2),
                            )),
                ],
              ),
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class _CustomCheckWidget extends StatelessWidget {
  final Schedule? schedule;
  final bool isChecked;
  final bool isCircle;
  final bool isBold;
  final bool isLast;
  final void Function()? onTap;
  _CustomCheckWidget({
    this.isChecked = true,
    this.isLast = false,
    this.isBold = false,
    this.schedule,
    this.onTap,
    this.isCircle = false,
  });

  TextStyle titleStyle = const TextStyle(
    color: Color(0xFF070708),
    fontSize: 15,
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600,
  );
  TextStyle titleBold = const TextStyle(
    color: Color(0xFF070708),
    fontSize: 15,
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600,
  );

  TextStyle priceBold = const TextStyle(
    color: Color(0xFF37B268),
    fontSize: 13,
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  TextStyle priceStyle = const TextStyle(
    color: Color(0xFF37B268),
    fontSize: 13,
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  String convertTo12HourFormat(String time) {
    return DateFormat.jm()
        .format(DateTime.parse('2022-01-01' ' ' "$time"))
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          InkWell(
            onTap: onTap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius:
                            isCircle ? null : BorderRadius.circular(3),
                        border: Border.all(color: colorGreen, width: 1.5),
                        color: isChecked ? colorGreen : Colors.white,
                      ),
                      child: const Icon(Icons.check,
                          size: 12, color: Colors.white)),
                  const SizedBox(
                    width: 22,
                  ),
                  // Text.rich(
                  //   TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: '${schedule?.price ?? 0}\n',
                  //         style: isBold ? priceBold : priceStyle,
                  //       ),
                  //       const TextSpan(
                  //         text: 'للشخص',
                  //         style: TextStyle(
                  //           color: colorDarkGrey,
                  //           fontSize: 8,
                  //           fontFamily: 'HT Rakik',
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   textAlign: TextAlign.right,
                  // ),
                  // const SizedBox(
                  //   width: 22,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: Text(
                          schedule?.scheduleName ?? '',
                          style: isBold ? titleBold : titleStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      if (schedule?.scheduleTime != null)
                        Row(
                          children: [
                            CustomText(
                              text: AppUtil.formatStringTimeWithLocale(
                                  context, schedule?.scheduleTime!['from']),
                              color: const Color(0xFF676767),
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                            const CustomText(
                              text: " - ",
                              color: Color(0xFF676767),
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText(
                              text:
                                  "${AppUtil.formatStringTimeWithLocale(context, schedule?.scheduleTime!['to'])} ",
                              color: Color(0xFF676767),
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: AppUtil.rtlDirection2(context)
                                  ? '${schedule?.price ?? 0} ريال '
                                  : '${schedule?.price ?? 0} SAR ',
                              style: isBold ? priceBold : priceStyle,
                            ),
                            // const TextSpan(
                            //   text: 'للشخص',
                            //   style: TextStyle(
                            //     color: colorDarkGrey,
                            //     fontSize: 8,
                            //     fontFamily: 'HT Rakik',
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   width: 22,
                  // ),
                ]),
          ),
          if (!isLast)
            Align(
              alignment: AppUtil.rtlDirection2(context)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 20,
                  height: 32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_divider(), _divider(), _divider()],
                  ),
                ),
              ),
            ),
        ]),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 2,
      height: 8,
      decoration: const BoxDecoration(
        color: colorGreen,
      ),
    );
  }
}
