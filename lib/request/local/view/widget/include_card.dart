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
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: borderGreyColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[\u0600-\u06FF\s\(\)\-،\.]'),
                ), // Allow only Arabic characters and spaces
              ],

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
              hintText: 'includeHint'.tr,
            ),
            SizedBox(
              height: width * 0.05,
            ),
            Row(
              children: [
                // SizedBox(width: width * 0.03),

                SizedBox(
                  width: width * 0.38,
                  height: width * 0.092,
                  child: CustomButton(
                    raduis: 4,
                    title: 'save'.tr,
                    fontSize: width * 0.038,
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
                ),
                // SizedBox(
                //   width: width * 0.02,
                // ),
                const Spacer(),
                SizedBox(
                  width: width * 0.38,
                  height: width * 0.092,
                  child: CustomButton(
                    raduis: 4,
                    title: 'delete'.tr,
                    buttonColor: Colors.white,
                    borderColor: colorRed,
                    textColor: colorRed,
                    fontSize: width * 0.038,
                    onPressed: () {
                      widget.experienceController.includeList
                          .removeAt(widget.indx);
                      widget.experienceController.includeCount.value--;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
