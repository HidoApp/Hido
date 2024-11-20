import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:ajwad_v4/widgets/read_more_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intel;

class ReviewCard extends StatelessWidget {
  const ReviewCard(
      {super.key,
      required this.name,
      required this.rating,
      required this.description,
      required this.image,
      required this.created,
      required this.status});
  final String name;
  final int rating;
  final String description;
  final String image;
  final String created;
  final String status;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //user details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                child: image == "profile_image.png"
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/images/$image",
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: ImageCacheWidget(
                          image: image,
                          height: 100,
                          width: 100,
                        ),
                      )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: name,
                        fontSize: width * 0.03,
                        fontFamily: AppUtil.SfFontType(context),
                        color: black,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: formatBookingDate(context, created),
                        fontSize: width * 0.028,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.SfFontType(context),
                        color: Color(0xFFBFBFBF),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Align(
                      alignment: AppUtil.rtlDirection2(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ListView.separated(
                        shrinkWrap: true,
                        clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.horizontal,
                        itemCount: rating,
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                        itemBuilder: (context, index) => SvgPicture.asset(
                          "assets/icons/star.svg",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Rating

        //description
        if (description.isNotEmpty || description != "") ...[
          // CustomText(
          //   text: description,
          //   textAlign: AppUtil.rtlDirection2(context)
          //       ? TextAlign.right
          //       : TextAlign.left,
          //   fontFamily: AppUtil.SfFontType(context),
          //   fontSize: width * 0.044,
          //   fontWeight: FontWeight.w400,
          //   maxlines: 500,
          //   color: graySmallText,
          // ),
          ReadMoreWidget(
            text:
                'My recent tour in Tuwaiq Mountain with a local guide was absolutely incredible! The guides extensive knowledge and genuine passion for the culture made the experience truly unforgettable. From exploring the',
            fontSize: width * 0.03,
            fontWeight: FontWeight.w500,
            color: black,
            moreColor: Color(0xFFA0A0A0),
          ),
          const SizedBox(height: 10), //comment sperated
        ],
        const Divider(
          color: lightGrey,
        )
      ],
    );
  }
}

String formatBookingDate(BuildContext context, String date) {
  DateTime dateTime = DateTime.parse(date);
  if (AppUtil.rtlDirection2(context)) {
    // Set Arabic locale for date formatting without the day name
    return intel.DateFormat('d /M /yyyy', 'ar').format(dateTime);
  } else {
    // Default to English locale without the day name
    return intel.DateFormat('dd /M /yyyy').format(dateTime);
  }
}
