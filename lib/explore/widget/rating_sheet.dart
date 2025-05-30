import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/activity_progress.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RatingSheet extends StatefulWidget {
  const RatingSheet({super.key, required this.activityProgress});
  final ActivityProgress activityProgress;
  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  final _ratingConroller = Get.put(RatingController());
  // var localReview = '';
  // var placeReview = '';
  final _placeReview = TextEditingController();
  final _localReview = TextEditingController();
  var placeRating = 5;
  var localRating = 5;
  @override
  void dispose() {
    _localReview.dispose();
    _placeReview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        //   width: double.infinity,
        padding: EdgeInsets.only(
          left: width * 0.061,
          right: width * 0.061,
          top: width * 0.041,
          bottom: width * 0.082,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.051,
            ),
            CustomText(
              text:
                  '${widget.activityProgress.placeId!.isEmpty ? "howYourExperience".tr : "howYourTour".tr} ${AppUtil.rtlDirection2(context) ? widget.activityProgress.requestName!.nameAr : widget.activityProgress.requestName!.nameEn} ',
              fontSize: width * 0.0435,
              fontWeight: FontWeight.w500,
            ),
            RatingBar.builder(
              glow: false,
              initialRating: 5,
              unratedColor: lightGrey,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 24,
              itemPadding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
              itemBuilder: (context, _) => RepaintBoundary(
                child: SvgPicture.asset(
                  'assets/icons/rating_star.svg',
                  color: Colors.amber,
                ),
              ),
              onRatingUpdate: (ratingPlace) =>
                  placeRating = ratingPlace.toInt(),
            ),
            SizedBox(
              height: width * 0.041,
            ),
            //place review
            CustomTextField(
              controller: _placeReview,
              height: width * 0.205,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              // minLines: null,
              //  expand: true,
              onChanged: (review) {},
              hintText: 'writeHere'.tr,
            ),
            SizedBox(
              height: width * 0.051,
            ),
            CustomText(
              text:
                  '${"howYourGudie".tr}  ${AppUtil.rtlDirection2(context) ? widget.activityProgress.localNameAr!.isEmpty ? widget.activityProgress.localNameEn! : widget.activityProgress.localNameAr! : widget.activityProgress.localNameEn!}',
              fontSize: width * .043,
              fontWeight: FontWeight.w500,
            ),
            RatingBar.builder(
              glow: false,
              initialRating: 5,
              unratedColor: lightGrey,
              minRating: 1,
              direction: Axis.horizontal,
              itemSize: 24,
              itemCount: 5,
              itemPadding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
              itemBuilder: (context, _) => RepaintBoundary(
                child: SvgPicture.asset(
                  'assets/icons/rating_star.svg',
                  color: Colors.amber,
                ),
              ),
              onRatingUpdate: (ratingLocal) =>
                  localRating = ratingLocal.toInt(),
            ),
            SizedBox(
              height: width * 0.041,
            ),
            //place review
            CustomTextField(
              height: width * 0.205,
              controller: _localReview,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onChanged: (review) {},
              hintText: 'writeHere'.tr,
            ),
            SizedBox(
              height: width * 0.0615,
            ),
            Obx(
              () => _ratingConroller.isSendRatingsLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : CustomButton(
                      title: 'submit'.tr,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        // if (localReview.isEmpty &&
                        //     placeReview.isEmpty &&
                        //     localRating == 0 &&
                        //     placeRating == 0) {
                        //   Get.back();
                        //   return;
                        // }
                        // log(placeReview);

                        log(placeRating.toString());
                        log(_localReview.text);
                        log(localRating.toString());
                        await _ratingConroller.postRating(
                          context: context,
                          localId: widget.activityProgress.localId!,
                          bookingId: widget.activityProgress.bookingId!,
                          localRate: localRating,
                          localReview: _localReview.text.isEmpty
                              ? "n"
                              : _localReview.text,
                          placeRate: placeRating,
                          placeReview: _placeReview.text.isEmpty
                              ? "n"
                              : _placeReview.text,
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (Get.isOverlaysOpen) {
                            Get.back();
                          }
                        });
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
