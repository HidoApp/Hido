import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/widgets/hospitality_booking_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/sign_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
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
                  textColor: widget.hospitalityObj.daysInfo.isEmpty
                      ? textlightGreen
                      : Colors.white,
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
