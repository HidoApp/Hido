import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/driving_license.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/vehicle_license.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TourStepper extends StatefulWidget {
  const TourStepper({super.key, required this.length});
  final int length;

  @override
  State<TourStepper> createState() => _TourStepperState();
}

class _TourStepperState extends State<TourStepper> {
  var activeBar = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nextStep(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StepProgressIndicator(
            size: 4.5,
            roundedEdges: Radius.circular(30),
            padding: 2,
            totalSteps: widget.length,
            currentStep: activeBar,
            selectedColor: colorGreen,
            unselectedColor: almostGrey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          if (activeBar == 1) {
                            Get.back();
                          } else {
                            setState(() {
                              activeBar--;
                            });
                          }
                        },
                        child: CustomText(
                          text: 'Back'.tr,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: CustomButton(
                      onPressed: () {
                        setState(() {
                          if (activeBar != widget.length) {
                            activeBar++;
                          }
                        });
                      },
                      title: 'next'.tr,
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget nextStep() {
    switch (activeBar) {
      case 1:
        return widget.length == 3
            ? const ContactInfo(
                isPageView: true,
              )
            : Container();
      case 2:
        return const DrivingLicense();
      case 3:
        return const VehicleLicenseScreen();
      default:
        return Container(); // Replace with your actual widget
    }
  }
}
