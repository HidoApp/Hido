import 'dart:developer';

import 'package:ajwad_v4/request/tourist/models/rating.dart';
import 'package:ajwad_v4/request/tourist/services/rating_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  var isRatingsLoading = false.obs;
  var isSendRatingsLoading = false.obs;
  var ratings = <Rating>[].obs;
  var placeReview = '';
  var localReview = '';
  var localRate = 0.0;
  var placeRate = 0.0;

  Future<List<Rating>?> getRatings(
      {required BuildContext context,
      required String profileId,
      String? ratingType}) async {
    try {
      isRatingsLoading(true);
      final data = await RatingService.getRtings(
          context: context, profileId: profileId, ratingType: ratingType);

      ratings(data);

      return ratings;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isRatingsLoading(false);
    }
  }

  Future<bool> postRating({
    required BuildContext context,
    required String localId,
    required String bookingId,
    int? placeRate,
    int? localRate,
    required String placeReview,
    required String localReview,
  }) async {
    try {
      isSendRatingsLoading(true);
      final isSucces = await RatingService.postRating(
        context: context,
        localId: localId,
        bookingId: bookingId,
        localRate: localRate,
        localReview: localReview,
        placeRate: placeRate,
        placeReview: placeReview,
      );
      return isSucces;
    } catch (e) {
      isSendRatingsLoading(false);
      return false;
    } finally {
      isSendRatingsLoading(false);
    }
  }
}
