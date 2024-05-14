import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
import 'package:ajwad_v4/request/tourist/models/rating.dart';
import 'package:ajwad_v4/request/tourist/services/rating_service.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/review_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart';

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet(
      {super.key, required this.localId, required this.bookingId});
  final String localId;
  final String bookingId;
  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final _rateController = Get.put(RatingController());
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
              width: double.infinity,
              height: 486,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //place Review
                    ReviewTile(
                      title: "How was your tour in Edge of the World",
                      onRatingUpdate: (rate) {
                        _rateController.placeRate = rate;
                      },
                      onChanged: (text) {
                        _rateController.placeReview = text;
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //local Review
                    ReviewTile(
                      title: "How was you guide Suliman Al Hogail?",
                      onRatingUpdate: (rate) {
                        _rateController.localRate = rate;
                      },
                      onChanged: (text) {
                        _rateController.localReview = text;
                      },
                    ),

                    const SizedBox(
                      height: 24,
                    ),
                    CustomButton(
                      onPressed: () async {
                        print(_rateController.placeRate);
                        print(_rateController.placeReview);
                        print(_rateController.localRate);
                        print(_rateController.localReview);
                        await RatingService.postRating(
                          context: context,
                          localId: widget.localId,
                          bookingId: widget.bookingId,
                          rating: Rating(
                            rating: _rateController.placeRate.toInt(),
                            description: _rateController.placeReview,
                            userRating: _rateController.localRate.toInt(),
                            userDescription: _rateController.localReview,
                          ),
                        );
                        Get.back();
                      },
                      title: "submit".tr,
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
