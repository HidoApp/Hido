import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProgressSheet extends StatefulWidget {
  const ProgressSheet({super.key});

  @override
  State<ProgressSheet> createState() => _ProgressSheetState();
}

class _ProgressSheetState extends State<ProgressSheet> {
  int activeStep = 1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Your local guide arrived ',
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text:
                  'We hope you had the best time in your tour! Now set and relax while your local guide takes you to your destination. ',
              fontSize: 15,
              fontFamily: 'SF Pro',
              color: starGreyColor,
              fontWeight: FontWeight.w500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: EasyStepper(
                activeStep: activeStep,
                activeStepTextColor: Colors.black87,
                finishedStepTextColor: Colors.black87,
                internalPadding: 25,
                showLoadingAnimation: false,
                stepRadius: 15,
                showStepBorder: false,
                lineStyle: LineStyle(
                  lineType: LineType.normal,
                ),
                steps: [
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor:
                            activeStep >= 0 ? Colors.orange : Colors.white,
                      ),
                    ),
                    title: 'Waiting',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor:
                            activeStep >= 1 ? Colors.orange : Colors.white,
                      ),
                    ),
                    title: 'Order Received',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor:
                            activeStep >= 3 ? Colors.orange : Colors.white,
                      ),
                    ),
                    title: 'On Way',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor:
                            activeStep >= 4 ? Colors.orange : Colors.white,
                      ),
                    ),
                    title: 'Delivered',
                  ),
                ],
                onStepReached: (index) => setState(() => activeStep = index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStep({required String text, required bool isActive}) {
    return Container(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset('assets/icons/slider.svg',
                color: isActive ? Color(0xFF36B268) : Color(0xFFDCDCE0),
                height: 20,
                width: 20),
          ),
          Text(
            text,
            style: TextStyle(
              color: isActive ? Color(0xFF36B268) : Color(0xFFDCDCE0),
              fontSize: 11,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
