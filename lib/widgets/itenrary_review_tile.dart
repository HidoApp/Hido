import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewItenraryTile extends StatelessWidget {
  const ReviewItenraryTile({
    super.key,
    required this.title,
    required this.timeTo,
    required this.timeFrom,
    required this.price,
  });

  final String title;
  final String timeTo;
  final String timeFrom;
  final String price;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        text: title,
        color: almostGrey,
        fontSize: width * 0.038, // Adjust font size based on screen width
      ),
      subtitle: CustomText(
        text: "$timeTo - $timeFrom",
        color: almostGrey,
        fontSize: width * 0.033, // Adjust font size based on screen width
      ),
      trailing: Padding(
        padding: EdgeInsets.only(
          bottom: width * 0.038, // Adjust padding based on screen width
        ),
        child: CustomText(
          text: '$price ${"sar".tr}',
          color: almostGrey,
          fontSize: width * 0.033, // Adjust font size based on screen width
        ),
      ),
    );
  }
}
