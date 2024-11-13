import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatefulWidget {
  CustomTimePicker(
      {super.key, this.newTime, this.time, this.touristExploreController});
  DateTime? newTime;
  DateTime? time;
  TouristExploreController? touristExploreController;
  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Time to go",
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Align(
          alignment: AppUtil.rtlDirection(context)
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                onPressed: () {
                                  widget.touristExploreController!
                                      .isBookingTimeSelected(true);
                                  setState(() {
                                    Get.back();
                                    widget.time = widget.newTime;
                                  });
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 5.0,
                                ),
                                child: const CustomText(
                                  text: "confirm",
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
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            width: width,
                            color: Colors.white,
                            child: CupertinoDatePicker(
                              backgroundColor: Colors.white,
                              initialDateTime: widget.newTime,
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: false,
                              onDateTimeChanged: (DateTime newT) {
                                print(DateFormat('HH:mm:ss')
                                    .format(widget.newTime!));
                                setState(() {
                                  widget.newTime = newT;
                                  //
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            height: height * 0.06,
            width: width * 0.4,
            title: widget.touristExploreController!.isBookingTimeSelected.value
                ? "Time"
                : DateFormat('hh:mm a').format(widget.newTime!),
            //  test,
            borderColor: lightGreyColor,
            prefixIcon: SvgPicture.asset(
              "assets/icons/time_icon.svg",
            ),
            suffixIcon: Container(),
            textColor: almostGrey,
          ),
        ),
      ],
    );
  }
}
