import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/widgets/event_booking_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/sign_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class BottomEventBooking extends StatefulWidget {
  const BottomEventBooking({
    super.key,
    required this.event,
    required this.avilableDate,
    this.address='',
  });
  final Event event;
  final List<DateTime> avilableDate;
  final String address;

  @override
  State<BottomEventBooking> createState() => _BottomAdventureBookingState();
}

class _BottomAdventureBookingState extends State<BottomEventBooking> {
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  final _eventController = Get.put(EventController());

 void initState(){
_eventController.address(widget.address);

 }

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
          Row(
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
                text: '${widget.event.price} ${'sar'.tr}',
                fontWeight: FontWeight.w900,
                fontSize: width * 0.043,
                fontFamily: 'HT Rakik',
              ),
            ],
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
                          EventBookingSheet(
                            event: widget.event,
                            avilableDate: widget.avilableDate,
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
                title: "book".tr,
                icon: AppUtil.rtlDirection2(context)
                    ? const Icon(Icons.arrow_back_ios)
                    : const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
