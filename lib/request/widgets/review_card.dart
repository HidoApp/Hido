import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //user details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                //radius: 20,
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
                        borderRadius: BorderRadius.circular(30),
                        child: ImageCacheWidget(
                          image: image,
                        ),
                      )),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontSize: width * 0.042,
                  fontFamily: AppUtil.SfFontType(context),
                  color: black,
                  fontWeight: FontWeight.w500,
                ),
                //date
                CustomText(
                  text: formatBookingDate(context, created),
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppUtil.SfFontType(context),
                  color: starGreyColor,
                )
              ],
            ),
          ],
        ),
        // const SizedBox(
        //   height: 12,
        // ),
        //Rating
        SizedBox(
          height: 35,
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
        //description
        if (description.isNotEmpty || description != "") ...[
          CustomText(
            text: description,
            textAlign: AppUtil.rtlDirection2(context)
                ? TextAlign.right
                : TextAlign.left,
            fontFamily: AppUtil.SfFontType(context),
            fontSize: width * 0.044,
            fontWeight: FontWeight.w400,
            maxlines: 500,
            color: graySmallText,
          ),
          SizedBox(height: 10), //comment sperated
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
    return DateFormat('d MMMM yyyy', 'ar').format(dateTime);
  } else {
    // Default to English locale without the day name
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
