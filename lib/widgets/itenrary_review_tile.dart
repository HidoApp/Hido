import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewItenraryTile extends StatelessWidget {
  const ReviewItenraryTile(
      {super.key,
      required this.title,
      required this.timeTo,
      required this.timeFrom,
      required this.price});
  final String title;
  final String timeTo;
  final String timeFrom;
  final String price;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      
      title: CustomText(
        text: title,
        color: almostGrey,
        fontSize: 15,
      ),
      subtitle: CustomText(
        text: "$timeTo - $timeFrom",
        color: almostGrey,
        fontSize: 13,
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: CustomText(
          text: '$price ${"sar".tr}',
          color: almostGrey,
          fontSize: 13,
        ),
      ),
    );
  }
}
