import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAjwadiCard extends StatelessWidget {
  const CustomAjwadiCard(
      {Key? key,
      required this.name,
      required this.image,
      required this.rating,
      required this.price,
      required this.tripNumber})
      : super(key: key);

  final String name;
  final String image;
  final int rating, price, tripNumber;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      image,
                    ),
                    radius: 25,
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile_image.png',
                    ),
                    radius: 25,
                  ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontSize: width * 0.038,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                ),
                Row(
                  children: [
                    CustomText(
                        text: "$tripNumber  ",
                        fontSize: width * 0.028,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        color: starGreyColor),
                    // CustomText(text: " ${"trips2".tr}   |  $rating  "),
                    CustomText(
                      text: "${"trips2".tr}     ",
                      fontSize: width * 0.028,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w500,
                      color: starGreyColor,
                    ),

                    SvgPicture.asset("assets/icons/star.svg"),
                    CustomText(
                      text: "  $rating  ",
                      fontSize: width * 0.028,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w500,
                      color: starGreyColor,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 34,
              width: 115,
              decoration: BoxDecoration(
                  color: colorGreen, borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: CustomText(
                    text: AppUtil.rtlDirection2(context)
                        ? "$price ريال"
                        : "$price SAR",
                    color: Colors.white,
                    fontSize: width * 0.038,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
