import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
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
  var activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StepProgressIndicator(
              size: 4.5,
              roundedEdges: Radius.circular(30),
              padding: 2,
              totalSteps: widget.length,
              currentStep: activeIndex + 1,
              selectedColor: colorGreen,
              unselectedColor: almostGrey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: GestureDetector(
                          //TODO: must change index way and use normal number 1,2,3
                          onTap: () {
                            if (activeIndex - 1 == 0) {
                              Get.back();
                            } else {
                              setState(() {
                                activeIndex--;
                              });
                            }
                          },
                          child: CustomText(
                            text: 'back'.tr,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            if (activeIndex + 1 != widget.length) {
                              activeIndex++;
                            }
                          });
                        },
                        title: 'next'.tr,
                        icon: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: ContactInfo(
          isPageView: true,
        ));
  }
}
