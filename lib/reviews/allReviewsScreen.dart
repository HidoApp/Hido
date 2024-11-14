import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/experience_type.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/custom_experience_item.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
import 'package:ajwad_v4/reviews/review_card.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommonReviewsScreen extends StatefulWidget {
  const CommonReviewsScreen({
    super.key,
    required this.ratingType,
    required this.id,
  });
  final String ratingType;
  final String id;

  @override
  State<CommonReviewsScreen> createState() => _CommonReviewsScreenState();
}

class _CommonReviewsScreenState extends State<CommonReviewsScreen> {
  final _rattingController = Get.put(RatingController());

  void getRtings() {
    // RatingService.getRtings(profileId: widget.profileId, context: context);
    _rattingController.getRatings(
        context: context, profileId: widget.id, ratingType: widget.ratingType);
  }

  @override
  void initState() {
    super.initState();
    getRtings();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: lightGreyBackground,
      appBar: CustomAppBar(
        'reviews'.tr,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.041,
                    left: width * 0.041,
                  ),
                  child: Obx(
                    () => Skeletonizer(
                      enabled: _rattingController.isRatingsLoading.value,
                      child: _rattingController.ratings.isEmpty
                          ? SizedBox(
                              width: width,
                              child: CustomEmptyWidget(
                                title: 'noReview'.tr,
                                image: 'noReview',
                                subtitle: 'noReviewSub'.tr,
                              ))
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: _rattingController.ratings.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 11,
                                );
                              },
                              itemBuilder: (context, index) {
                                return ReviewCard(
                                  name:
                                      _rattingController.ratings[index].name ??
                                          "",
                                  rating: _rattingController
                                          .ratings[index].rating ??
                                      1,
                                  description: _rattingController
                                          .ratings[index].description ??
                                      "",
                                  image:
                                      _rattingController.ratings[index].image ??
                                          "profile_image.png",
                                  created: _rattingController
                                          .ratings[index].created ??
                                      "no date",
                                  status:
                                      _rattingController.ratings[index].status!,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
