import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';

import 'package:flutter/material.dart';
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

  // void itineraryValdiation() {
  //   if (_activityConroller.text.isEmpty) {
  //     // widget.requestController.isActivtyReviewValid(false);
  //   } else {
  //     // widget.requestController.isActivtyReviewValid(true);
  //   }

  //   if (_activityConroller.text.isNotEmpty &&
  //       _formKey.currentState!.validate()) {
  //     // widget.requestController.validReviewSave(true);
  //   } else {
  //     // widget.requestController.validReviewSave(false);
  //   }
  // }
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
      elevation: 10,
      surfaceTintColor: Colors.black12,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: ExpandedTile(
        onTap: () {
          //TODO : must change to obx
          //   _controller.collapse();

          // setState(() {});
        },
        trailing: null,
        leading: _controller.isExpanded
            ? null
            : Container(
                width: width * 0.046,
                height: width * 0.025,
                decoration: const BoxDecoration(
                    color: colorGreen, shape: BoxShape.circle),
              ),
        title: _controller.isExpanded
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: _activityConroller.text),
                    ],
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
          // height: widget.experienceController.validSave.value
          //     ? width * 0.9
          //     : width * 0.92,
          // width: double.infinity,
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
                Row(
                  children: [
                    if (_controller.isExpanded)
                      Container(
                        width: width * 0.025,
                        height: width * 0.025,
                        decoration: const BoxDecoration(
                            color: colorGreen, shape: BoxShape.circle),
                      ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.028),
                        child: CustomTextField(
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
                        width: width * 0.33,
                        height: width * 0.099,
                        child: CustomButton(
                          raduis: 4,
                          title: 'delete'.tr,
                          buttonColor: Colors.white,
                          borderColor: colorRed,
                          textColor: colorRed,
                          onPressed: () {
                            widget.experienceController.reviewincludeItenrary
                                .removeAt(widget.indx);
                          },
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width * 0.33,
                        height: width * 0.099,
                        child: CustomButton(
                          raduis: 4,
                          title: 'save'.tr,
                          onPressed: () {
                            itineraryValdiation();
                            if (widget.experienceController.validSave.value) {
                              widget.experienceController
                                      .reviewincludeItenrary[widget.indx] =
                                  widget.include;
                              _controller.collapse();
                            }
                            // } else {
                            //   // AppUtil.errorToast(context, "msg");
                            // }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
