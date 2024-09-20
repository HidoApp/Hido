import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ajwad_v4/utils/app_util.dart';

import '../constants/colors.dart';
import '../request/tourist/models/schedule.dart';

class ScheduleContainerWidget extends StatefulWidget {
  final OfferController? offerController;
  final List<Schedule>? scheduleList;
  final bool isReview;
  const ScheduleContainerWidget({
    super.key,
    required this.scheduleList,
    this.isReview = false,
    this.offerController,
  });

  @override
  State<ScheduleContainerWidget> createState() =>
      _ScheduleContainerWidgetState();
}

class _ScheduleContainerWidgetState extends State<ScheduleContainerWidget> {
  List<Schedule>? scheduleList2;
  List<bool> checkedList = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: !widget.isReview
            ? const EdgeInsets.only(
                top: 15,
                left: 12,
                right: 9,
                bottom: 24,
              )
            : const EdgeInsets.only(top: 12, left: 5, right: 9, bottom: 24),
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
            Column(
              children: [
                if (widget.scheduleList != null)
                  ...List.generate(widget.scheduleList!.length, (index) {
                    // widget.offerController?.checkedList[index] == true?

                    if (widget.offerController != null) {
                      final bool isChecked =
                          widget.offerController?.checkedList[index] ?? false;

                      if (isChecked) {
                        return _CustomCheckWidget(
                          // isChecked:
                          //     widget.offerController?.checkedList[index] ??false,

                          isReview: widget.isReview,
                          onTap: () {
                            //bool check = !(widget.offerController?.checkedList[index] ?? false);
                            //widget.offerController?.checkTotal(index, check);
                            // widget.offerController?.getTotalPrice(scheduleList, index);
                          },
                          schedule: widget.scheduleList![index],
                          isLast: index == widget.scheduleList!.length - 1,
                          isBold: !(index == 0 || index == 2),
                        );
                        // Return an empty Container if not checked
                      } else {
                        return SizedBox
                            .shrink(); // Return an empty widget if not checked
                      }
                    } else if (widget.scheduleList![index].userAgreed ??
                        false) {
                      return _CustomCheckWidget(
                        // isChecked:
                        //     widget.offerController?.checkedList[index] ??false,

                        isReview: widget.isReview,
                        onTap: () {
                          //bool check = !(widget.offerController?.checkedList[index] ?? false);
                          //widget.offerController?.checkTotal(index, check);
                          // widget.offerController?.getTotalPrice(scheduleList, index);
                        },
                        schedule: widget.scheduleList![index],
                        isLast: index == widget.scheduleList!.length - 1,
                        isBold: !(index == 0 || index == 2),
                      );
                    } else {
                      return SizedBox
                          .shrink(); // Return an empty widget if not checked
                    }
                  }),
              ],
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class _CustomCheckWidget extends StatelessWidget {
  final Schedule? schedule;
  //final bool isChecked;
  final bool isReview;
  final bool isCircle;
  final bool isBold;
  final bool isLast;
  final void Function()? onTap;
  _CustomCheckWidget({
    // this.isChecked = false,
    this.isLast = false,
    this.isBold = false,
    this.schedule,
    this.onTap,
    this.isCircle = true,
    this.isReview = false,
  });

  TextStyle titleStyle = TextStyle(
    color: Color(0xFF070708),
    fontSize: 15,
    fontFamily: "SF Pro",
    fontWeight: FontWeight.w500,
  );
  TextStyle titleBold = TextStyle(
    color: Color(0xFF070708),
    fontSize: 15,
    fontFamily: "SF Pro",
    fontWeight: FontWeight.w500,
  );
  TextStyle titleReview = TextStyle(
    color: starGreyColor,
    fontSize: 15,
    fontFamily: "SF Pro",
    fontWeight: FontWeight.w500,
  );
  TextStyle priceBold = TextStyle(
    color: Color(0xFF37B268),
    fontSize: 13,
    fontFamily: "SF Pro",
    fontWeight: FontWeight.w500,
    height: 0,
  );

  TextStyle priceStyle = TextStyle(
    color: Color(0xFF37B268),
    fontSize: 13,
    fontFamily: "SF Pro",
    fontWeight: FontWeight.w500,
    height: 0,
  );
  TextStyle priceReview = TextStyle(
    color: starGreyColor,
    fontSize: 13,
    fontFamily: "SF Pro",
    fontWeight: FontWeight.w500,
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
            // onTap: onTap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Adjust opacity based on condition
                  Visibility(
                      visible: !isReview, // Ignore pointer events when disabled
                      child: Container(
                        height: 23,
                        width: 10,
                        decoration: BoxDecoration(
                          shape:
                              isCircle ? BoxShape.circle : BoxShape.rectangle,
                          borderRadius:
                              isCircle ? null : BorderRadius.circular(3),
                          border: Border.all(color: colorGreen),
                          color: colorGreen,
                        ),
                      )),

                  SizedBox(width: !isReview ? 22 : 0),

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
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(
                          schedule?.scheduleName ?? '',
                          style: !isReview
                              ? isBold
                                  ? titleBold
                                  : titleStyle
                              : titleReview,
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
                              color: !isReview
                                  ? Color(0xFF676767)
                                  : Color(0xFFB9B8C1),
                              fontSize: 13,
                              fontFamily: AppUtil.SfFontType(context),
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: " - ",
                              color: !isReview
                                  ? Color(0xFF676767)
                                  : Color(0xFFB9B8C1),
                              fontSize: 13,
                              fontFamily: AppUtil.SfFontType(context),
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text:
                                  "${AppUtil.formatStringTimeWithLocale(context, schedule?.scheduleTime!['to'])} ",
                              color: !isReview
                                  ? Color(0xFF676767)
                                  : Color(0xFFB9B8C1),
                              fontSize: 13,
                              fontFamily: AppUtil.SfFontType(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        )
                    ],
                  ),
                  Spacer(),
                  Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: AppUtil.rtlDirection2(context)
                                    ? '${schedule?.price ?? 0} ريال '
                                    : '${schedule?.price ?? 0} SAR ',
                                style: !isReview
                                    ? isBold
                                        ? priceBold
                                        : priceStyle
                                    : priceReview,
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
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   width: 22,
                  // ),
                ]),
          ),
          if (!isLast)
            Visibility(
                visible: !isReview,
                child: Align(
                  alignment: AppUtil.rtlDirection2(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 10,
                      height: 32,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [_divider(), _divider(), _divider()],
                      ),
                    ),
                  ),
                )),
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
