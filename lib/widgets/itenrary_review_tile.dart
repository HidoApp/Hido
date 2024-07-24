import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                color: Color(0xFF41404A),
                fontFamily:
                    !AppUtil.rtlDirection2(context) ? 'SF Pro' : 'SF Arabic',
                fontSize:
                    width * 0.038, // Adjust font size based on screen width
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  CustomText(
                    text: "$timeTo - $timeFrom",
                    color: starGreyColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: !AppUtil.rtlDirection2(context)
                        ? 'SF Pro'
                        : 'SF Arabic',
                    fontSize:
                        width * 0.035, // Adjust font size based on screen width
                  ),
                ],
              )
            ],
          ),
          Spacer(),
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$price ${"sar".tr}',
                      style: TextStyle(
                        color: Graytext,
                        fontFamily: !AppUtil.rtlDirection2(context)
                            ? 'SF Pro'
                            : 'SF Arabic',
                        fontWeight: FontWeight.w500,
                        fontSize: width *
                            0.035, // Adjust font size based on screen width
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ]);
  }
}
