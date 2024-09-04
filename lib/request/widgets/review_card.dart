import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //user details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                //radius: 20,
                backgroundColor: Colors.transparent,
                child: image == "profile_image.png"
                    ? SvgPicture.asset(
                        "assets/images/$image",
                        fit: BoxFit.cover,
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
                //name
                CustomText(
                  text: name,
                  fontSize: 16,
                ),
                //date
                CustomText(
                  text: created,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: almostGrey,
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        //Rating
        SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.centerLeft,
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
        CustomText(text: description), //comment sperated
        const Divider(
          color: lightGrey,
        )
      ],
    );
  }
}
