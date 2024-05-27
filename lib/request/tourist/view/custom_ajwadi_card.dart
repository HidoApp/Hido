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
     print("inter");
     print(name);
     print(price);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      image,
                    ),
                    radius: 30,
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile_image.png',
                    ),
                    radius: 32,
                  ),
            const SizedBox(
              width: 10,
            ),
            // Image.network(
            //   image,
            //   height: 60,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  color: black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  children: [
                    CustomText(text: "$tripNumber  "),
                    // CustomText(text: " ${"trips2".tr}   |  $rating  "),
                   CustomText(text: " ${"trips2".tr}   |  "),

                    SvgPicture.asset("assets/icons/star.svg"),
                    CustomText(text: "  $rating  "  ),

                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                  color: colorGreen, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: CustomText(
                  text: AppUtil.rtlDirection2(context)?"$price ريال":"$price SAR",
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
