import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/widgets/activity_booking_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/sign_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class BottomAdventureBooking extends StatefulWidget {
  const BottomAdventureBooking({
    super.key,
    required this.adventure,
    this.address = '',
    required this.avilableDate,
  });
  final Adventure adventure;
  final String address;
  final List<DateTime> avilableDate;

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
    //TODO : change the validtion here
    seat = widget.adventure.daysInfo!.first.seats;

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
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
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
                ignoring: widget.adventure.daysInfo!.isEmpty,
                child: CustomButton(
                  onPressed: () {
                    _adventureController.DateErrorMessage.value = false;

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
                            ActivityBookingSheet(
                              avilableDate: widget.avilableDate,
                              activity: widget.adventure,
                              address: widget.address,
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.06),
                                  topRight: Radius.circular(width * 0.06)),
                            ),
                          );
                  },
                  iconColor: darkPurple,
                  title: widget.adventure.daysInfo!.isEmpty
                      ? 'fullyBooked'.tr
                      : "book".tr,
                  icon: AppUtil.rtlDirection2(context)
                      ? const Icon(Icons.arrow_back_ios)
                      : const Icon(Icons.arrow_forward_ios),
                  buttonColor: widget.adventure.daysInfo!.isEmpty
                      ? colorlightGreen
                      : colorGreen,
                  borderColor: widget.adventure.daysInfo!.isEmpty
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
