import 'package:ajwad_v4/request/tourist/models/rating.dart';
import 'package:ajwad_v4/request/tourist/services/rating_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  var isRatingsLoading = false.obs;
  var ratings = <Rating>[].obs;

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
