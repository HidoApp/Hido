import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile(
      {super.key,
      required this.title,
      required this.onRatingUpdate,
      this.onChanged});
  final String title;
  final void Function(double) onRatingUpdate;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(
        fontSize: 18,
        text: title,
      ),
      const SizedBox(
        height: 4,
      ),
      RatingBar.builder(
        unratedColor: lightGrey,
        initialRating: 0,
        itemSize: 24,
        minRating: 1,
        direction: Axis.horizontal,
        // allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, _) => SvgPicture.asset(
          "assets/icons/star.svg",
        ),
        glow: false,
        onRatingUpdate: onRatingUpdate,
      ),
      const SizedBox(
        height: 16,
      ),
      CustomTextArea(
        onChanged: onChanged,
      )
    ]);
  }
}
