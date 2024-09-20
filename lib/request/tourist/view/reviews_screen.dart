import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
import 'package:ajwad_v4/request/widgets/review_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    super.key,
    required this.profileId,
  });
  final String profileId;
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _rattingController = Get.put(RatingController());

  void getRtings() {
    // RatingService.getRtings(profileId: widget.profileId, context: context);
    _rattingController.getRatings(
        context: context, profileId: widget.profileId);
  }

  @override
  void initState() {
    super.initState();
    getRtings();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.profileId);
    final width = MediaQuery.of(context).size.width;

    return Obx(
      () => Skeletonizer(
        enabled: _rattingController.isRatingsLoading.value,
        child: _rattingController.ratings.isEmpty
            ? Center(
                child: Text(
                "NoReview".tr,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily:
                      !AppUtil.rtlDirection2(context) ? 'SF Pro' : 'SF Arabic',
                  fontWeight: FontWeight.w400,
                  color: starGreyColor,
                ),
              ))
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                itemCount: _rattingController.ratings.length,
                itemBuilder: (context, index) => ReviewCard(
                  name: _rattingController.ratings[index].name ?? "",
                  rating: _rattingController.ratings[index].rating ?? 1,
                  description:
                      _rattingController.ratings[index].description ?? "",
                  image: _rattingController.ratings[index].image ??
                      "profile_image.png",
                  created:
                      _rattingController.ratings[index].created ?? "no date",
                  status: _rattingController.ratings[index].status!,
                ),
              ),
      ),
    );
  }
}
