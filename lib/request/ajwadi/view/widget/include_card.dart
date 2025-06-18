import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class IncludeCard extends StatefulWidget {
  const IncludeCard({
    super.key,
    required this.indx,
    required this.experienceController,
  });

  final int indx;
  final dynamic experienceController;
  @override
  State<IncludeCard> createState() => _IncludeCardState();
}

class _IncludeCardState extends State<IncludeCard> {
  final _formKey = GlobalKey<FormState>();
  var activity = '';
  // final HospitalityController _hospitalityController =
  //     Get.put(HospitalityController());

  void itineraryValdiation() {
    final isSucces = _formKey.currentState!.validate();
    if (activity.isNotEmpty && isSucces) {
      widget.experienceController.validSave(true);
    } else {
      widget.experienceController.validSave(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      // height:
      //     widget.experienceController.validSave.value ? width * 0.9 : width * 1,
      padding: EdgeInsets.only(
        left: width * 0.030,
        top: width * 0.05,
        bottom: width * 0.05,
        right: width * 0.030,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3FC7C7C7),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ]),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: width * 0.01,
            ),
            Row(
              children: [
                Container(
                  width: width * 0.025,
                  height: width * 0.025,
                  decoration: const BoxDecoration(
                      color: colorGreen, shape: BoxShape.circle),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.028),
                    child: CustomTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) => activity = value,
                      validator: false,
                      validatorHandle: (activity) {
                        if (activity == null || activity.isEmpty) {
                          return "activityError".tr;
                        }
                        return null;
                      },
                      //  height: 40,
                      //  height: width * 0.09,
                      hintText: 'activityHint'.tr,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: width * 0.06,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.028),
              child: Row(
                children: [
                  SizedBox(width: width * 0.03),
                  SizedBox(
                    width: width * 0.34,
                    height: width * 0.099,
                    child: CustomButton(
                      raduis: 4,
                      title: 'delete'.tr,
                      buttonColor: Colors.white,
                      borderColor: colorRed,
                      textColor: colorRed,
                      onPressed: () {
                        widget.experienceController.includeList
                            .removeAt(widget.indx);
                        widget.experienceController.includeCount.value--;
                      },
                    ),
                  ),
                  // SizedBox(
                  //   width: width * 0.02,
                  // ),
                  const Spacer(),
                  SizedBox(
                    width: width * 0.34,
                    height: width * 0.099,
                    child: CustomButton(
                      raduis: 4,
                      title: 'save'.tr,
                      onPressed: () {
                        itineraryValdiation();
                        if (widget.experienceController.validSave.value) {
                          widget.experienceController.reviewincludeItenrary.add(
                            activity,
                          );
                          _formKey.currentState!.reset();

                          widget.experienceController.includeList.removeLast();
                          widget.experienceController.includeCount--;

                          // if (_hospitalityController
                          //         .reviewincludeItenrary.length >
                          //     3) {
                          // activity = '';

                          // _hospitalityController.includeList.add(IncludeCard(
                          //   indx: _hospitalityController.includeCount.value,
                          // ));
                          // _hospitalityController.includeCount++;
                          // }
                        } else {
                          // AppUtil.errorToast(context, "empty field");
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
