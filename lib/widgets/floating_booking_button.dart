import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/view/review_adventure_screen.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/widgets/hospitality_booking_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/sign_sheet.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class BottomHospitalityBooking extends StatefulWidget {
  const BottomHospitalityBooking({
    super.key,
    required this.hospitalityObj,
    required this.servicesController,
    required this.avilableDate,
    this.address = '',
  });
  final Hospitality hospitalityObj;
  final List<DateTime> avilableDate;
  final HospitalityController servicesController;
  final String address;

  @override
  State<BottomHospitalityBooking> createState() =>
      _BottomHospitalityBookingState();
}

class _BottomHospitalityBookingState extends State<BottomHospitalityBooking> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      color: Colors.white,
      width: double.infinity,
      height: width * 0.38,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: Row(
              children: [
                CustomText(
                  text: "pricePerPerson".tr,
                  fontSize: width * 0.038,
                  color: colorDarkGrey,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  text: " /  ",
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.043,
                  color: Colors.black,
                ),
                CustomText(
                  text: '${widget.hospitalityObj.price} ${'sar'.tr}',
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.043,
                  fontFamily: 'HT Rakik',
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              //padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
              padding: EdgeInsets.only(
                  right: width * 0.0025,
                  left: width * 0.0025,
                  bottom: width * 0.08),

              child: IgnorePointer(
                ignoring: widget.hospitalityObj.daysInfo.isEmpty,
                child: CustomButton(
                  onPressed: () {
                    AppUtil.isGuest()
                        ? showModalBottomSheet(
                            context: context,
                            builder: (context) => const SignInSheet(),
                            isScrollControlled: true,
                            enableDrag: true,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.06),
                                  topRight: Radius.circular(width * 0.06)),
                            ))
                        : Get.bottomSheet(
                            HospitalityBookingSheet(
                              color: Colors.green,
                              hospitality: widget.hospitalityObj,
                              avilableDate: widget.avilableDate,
                              serviceController: widget.servicesController,
                              address: widget.address,
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.06),
                                  topRight: Radius.circular(width * 0.06)),
                            ));
                  },
                  iconColor: darkPurple,
                  title: widget.hospitalityObj.daysInfo.isEmpty
                      ? 'fullyBooked'.tr
                      : "book".tr,
                  buttonColor: widget.hospitalityObj.daysInfo.isEmpty
                      ? colorlightGreen
                      : colorGreen,
                  borderColor: widget.hospitalityObj.daysInfo.isEmpty
                      ? colorlightGreen
                      : colorGreen,
                  icon: AppUtil.rtlDirection2(context)
                      ? const Icon(Icons.arrow_back_ios)
                      : const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomAdventureBooking extends StatefulWidget {
  const BottomAdventureBooking({
    super.key,
    required this.adventure,
    this.address = '',
  });
  final Adventure adventure;
  final String address;

  @override
  State<BottomAdventureBooking> createState() => _BottomAdventureBookingState();
}

class _BottomAdventureBookingState extends State<BottomAdventureBooking> {
  final _adventureController = Get.put(AdventureController());

  @override
  void initState() {
    super.initState();

    _adventureController.address(widget.address);
  }

  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  int seat = 0;
  bool showErrorGuests = false;

  bool isDateBeforeToday() {
    DateTime adventureDate =
        DateFormat('yyyy-MM-dd').parse(widget.adventure.date!);
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    return adventureDate.isBefore(currentDateInRiyadh);
  }

  bool isSameDay() {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime adventureDate =
        DateFormat('yyyy-MM-dd').parse(widget.adventure.date!);

    DateTime Date =
        DateFormat('HH:mm').parse(widget.adventure.times!.last.startTime);

    DateTime AdventureStartDate = DateTime(
        adventureDate.year,
        adventureDate.month,
        adventureDate.day,
        Date.hour,
        Date.minute,
        Date.second);

    DateTime bookingDeadline =
        AdventureStartDate.subtract(const Duration(hours: 24));

    return bookingDeadline.isBefore(currentDateInRiyadh);
  }

  bool getSeat() {
    seat = widget.adventure.seats;

    _adventureController.address(widget.address);

    return seat == 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var person = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: Row(
              children: [
                CustomText(
                  text: "pricePerPerson".tr,
                  fontSize: width * 0.038,
                  color: colorDarkGrey,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  text: " /  ",
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.043,
                  color: Colors.black,
                ),
                CustomText(
                  //text: '400 ${'sar'.tr}',
                  text: '${widget.adventure.price} ${'sar'.tr}',
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.043,
                  fontFamily: 'HT Rakik',
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              //padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
              padding: EdgeInsets.only(
                  right: width * 0.0025,
                  left: width * 0.0025,
                  bottom: width * 0.08),

              child: IgnorePointer(
                ignoring: widget.adventure.seats == 0,
                child: CustomButton(
                  onPressed: () {
                    AppUtil.isGuest()
                        ? showModalBottomSheet(
                            context: context,
                            builder: (context) => const SignInSheet(),
                            isScrollControlled: true,
                            enableDrag: true,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.06),
                                  topRight: Radius.circular(width * 0.06)),
                            ))
                        : Get.bottomSheet(
                            StatefulBuilder(
                              builder: (context, setState) => Container(
                                // height: width * 0.58,
                                // width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: width * 0.0615,
                                  right: width * 0.0615,
                                  top: width * 0.045,
                                  bottom: width * 0.0820,
                                ),

                                child: Obx(
                                  () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const BottomSheetIndicator(),
                                      SizedBox(
                                        height: width * 0.065,
                                      ),
                                      CustomText(
                                        text: 'numberofpeorson'.tr,
                                        color: Colors.black,
                                        fontSize: width * 0.044,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Container(
                                        height: height * 0.06,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.038),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.02),
                                          border: Border.all(
                                            color: showErrorGuests ||
                                                    _adventureController
                                                        .showErrorMaxGuest.value
                                                ? colorRed
                                                : borderGrey,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              text: "person".tr,
                                              fontWeight: FontWeight.w400,
                                              color: borderGrey,
                                              fontSize: width * 0.035,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (person > 0) {
                                                    person = person - 1;
                                                    _adventureController
                                                        .showErrorMaxGuest
                                                        .value = false;
                                                  }
                                                });
                                              },
                                              child: const Icon(
                                                Icons.horizontal_rule_outlined,
                                                color: borderGrey,
                                              ),
                                            ),
                                            SizedBox(width: width * 0.038),
                                            CustomText(
                                              text: person.toString(),
                                              fontWeight: FontWeight.w400,
                                              color: borderGrey,
                                              fontSize: width * 0.035,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                            ),
                                            SizedBox(width: width * 0.038),
                                            GestureDetector(
                                              onTap: () {
                                                if (getSeat()) {
                                                  _adventureController
                                                      .showErrorMaxGuest
                                                      .value = true;
                                                } else {
                                                  if (widget.adventure.seats >
                                                      person) {
                                                    setState(() {
                                                      person = person + 1;
                                                    });
                                                  } else {
                                                    _adventureController
                                                        .showErrorMaxGuest(
                                                            true);
                                                  }
                                                }
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                color: borderGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_adventureController
                                          .showErrorMaxGuest.value)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.01),
                                          child: CustomText(
                                            text: AppUtil.rtlDirection2(context)
                                                ? "ليس هناك مقاعد متاحة أكثر من العدد الحالي"
                                                : '*There are no more seats available than the current number',
                                            color: colorRed,
                                            fontSize: width * 0.028,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                          ),
                                        ),
                                      if (showErrorGuests)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.01),
                                          child: CustomText(
                                            text: AppUtil.rtlDirection2(context)
                                                ? "يجب أن تختار شخص على الأقل"
                                                : '*You need to add at least one guest',
                                            color: colorRed,
                                            fontSize: width * 0.028,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                          ),
                                        ),
                                      SizedBox(
                                        height: width * 0.06,
                                      ),
                                      CustomButton(
                                          onPressed: () {
                                            if ((getSeat())) {
                                              setState(() {
                                                _adventureController
                                                        .showErrorMaxGuest
                                                        .value ==
                                                    true;
                                              });
                                            } else if (person == 0) {
                                              setState(() {
                                                showErrorGuests = true;
                                              });
                                            } else if (!AppUtil
                                                .isDateTimeBefore24Hours(
                                                    '${widget.adventure.date ?? ''} ${widget.adventure.times!.first.startTime}')) {
                                              AppUtil.errorToast(
                                                  context,
                                                  AppUtil.rtlDirection2(context)
                                                      ? "يجب أن تحجز قبل 24 ساعة "
                                                      : "You must booking before 24 hours");
                                            } else {
                                              _adventureController
                                                  .showErrorMaxGuest(false);

                                              setState(() {
                                                showErrorGuests = false;
                                              });
                                              Get.to(() => ReviewAdventure(
                                                        adventure:
                                                            widget.adventure,
                                                        person: person,
                                                      ))!
                                                  .then(
                                                (value) {
                                                  setState(() => person = 0);

                                                  // Get.back();
                                                },
                                              );
                                              AmplitudeService.amplitude.track(
                                                  BaseEvent(
                                                      'Review Adventure Booking',
                                                      eventProperties: {
                                                    'adventureTime':
                                                        '${widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime)).join(', ')} - ${widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.endTime)).join(', ')}',
                                                    'adventureDate': AppUtil
                                                        .formatBookingDate(
                                                            context,
                                                            widget.adventure
                                                                .date!),
                                                    'PersonNo': person,
                                                  }));
                                            }
                                          },
                                          title: 'confirm'.tr)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.06),
                                  topRight: Radius.circular(width * 0.06)),
                            ),
                          ).then((value) {
                            person = 0;
                            showErrorGuests = false;
                            // _adventureController.showErrorMaxGuest(false);
                          });
                  },
                  iconColor: darkPurple,
                  title: widget.adventure.seats == 0
                      ? 'fullyBooked'.tr
                      : "book".tr,
                  icon: AppUtil.rtlDirection2(context)
                      ? const Icon(Icons.arrow_back_ios)
                      : const Icon(Icons.arrow_forward_ios),
                  buttonColor: widget.adventure.seats == 0
                      ? colorlightGreen
                      : colorGreen,
                  borderColor: widget.adventure.seats == 0
                      ? colorlightGreen
                      : colorGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
