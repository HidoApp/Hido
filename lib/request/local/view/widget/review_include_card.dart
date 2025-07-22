import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';

class ReivewIncludeCard extends StatefulWidget {
  const ReivewIncludeCard(
      {super.key,
      required this.experienceController,
      required this.indx,
      required this.include});

  final int indx;
  final dynamic experienceController;
  final String include;

  @override
  State<ReivewIncludeCard> createState() => _ReivewIncludeCardState();
}

class _ReivewIncludeCardState extends State<ReivewIncludeCard> {
  final _formKey = GlobalKey<FormState>();

  var activityName = '';
  final _activityConroller = TextEditingController();

  late ExpandedTileController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize controller
    _activityConroller.text = widget.include;
    _controller = ExpandedTileController(isExpanded: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _activityConroller.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant ReivewIncludeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _activityConroller.text = widget.include;
  }

  void itineraryValdiation() {
    final isSucces = _formKey.currentState!.validate();
    if (activityName.isNotEmpty && isSucces) {
      widget.experienceController.validSave(true);
    } else {
      widget.experienceController.validSave(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 1,
          color: borderGreyColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpandedTile(
        onTap: () {
          //TODO : must change to obx

          setState(() {
            _activityConroller.text = widget.include;

            !_controller.isExpanded;
          });
        },
        trailingRotation: 360,
        trailing: _controller.isExpanded
            ? null
            : CustomText(
                text: 'update'.tr,
                fontSize: width * 0.033,
                fontWeight: FontWeight.w400,
                color: black,
              ),
        leading: null,
        title: _controller.isExpanded
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: _activityConroller.text,
                      fontSize: width * 0.038,
                      maxlines: 4,
                      fontWeight: FontWeight.w400,
                      color: black,
                    ),
                  ),
                  // const Spacer(),
                ],
              ),
        controller: _controller,
        expansionAnimationCurve: Curves.easeIn,
        disableAnimation: true,
        contentseparator: 0,
        theme: ExpandedTileThemeData(
            headerColor: Colors.white,
            titlePadding: EdgeInsets.symmetric(horizontal: width * 0.020),
            headerRadius: _controller.isExpanded ? 0 : 8,
            headerSplashColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            trailingPadding: EdgeInsets.zero),
        content: Container(
          padding: EdgeInsets.only(
              left: width * 0.030,
              // top: width * 0.051,
              bottom: width * 0.05,
              right: width * 0.030),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_controller.isExpanded)
                  CustomTextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[\u0600-\u06FF\s\(\)\-،\.]'),
                      ), // Allow only Arabic characters and spaces
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => activityName = value,
                    validator: false,
                    controller: _activityConroller,
                    validatorHandle: (activity) {
                      if (activity == null || activity.isEmpty) {
                        return "activityError".tr;
                      }
                      return null;
                    },
                    hintText: 'includeHint'.tr,
                  ),
                SizedBox(
                  height: width * 0.05,
                ),
                Row(
                  children: [
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
                            widget.experienceController
                                    .reviewincludeItenrary[widget.indx] =
                                _activityConroller.text;
                            _controller.collapse();
                          }
                          // } else {
                          //   // AppUtil.errorToast(context, "msg");
                          // }
                        },
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: width * 0.38,
                      height: width * 0.092,
                      child: CustomButton(
                        raduis: 4,
                        title: 'delete'.tr,
                        fontSize: width * 0.038,
                        buttonColor: Colors.white,
                        borderColor: colorRed,
                        textColor: colorRed,
                        onPressed: () {
                          _controller.collapse();

                          widget.experienceController.reviewincludeItenrary
                              .removeAt(widget.indx);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
