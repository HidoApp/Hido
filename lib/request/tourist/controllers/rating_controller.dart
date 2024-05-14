import 'package:ajwad_v4/request/tourist/models/rating.dart';
import 'package:ajwad_v4/request/tourist/services/rating_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class RatingController extends GetxController {
  var isRatingsLoading = false.obs;
  var ratings = <Rating>[].obs;
  var placeReview = '';
  var localReview = '';
  var localRate = 0.0;
  var placeRate = 0.0;

  Future<List<Rating>?> getRatings(
      {required BuildContext context, required String profileId}) async {
    try {
      isRatingsLoading(true);
      final data =
          await RatingService.getRtings(context: context, profileId: profileId);

      ratings(data);
      print(ratings);
      return ratings;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isRatingsLoading(false);
    }
  }
}
