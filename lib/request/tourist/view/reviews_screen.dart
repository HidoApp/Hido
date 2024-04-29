import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //user details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: almostGrey,
                child: SvgPicture.asset(
                  "assets/images/profile_rev.svg",
                  width: 49,
                  height: 49,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //name
                  CustomText(
                    text: "Cameron Williamson",
                    fontSize: 16,
                  ),
                  //date
                  CustomText(
                    text: "April 28, 2023",
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
                itemCount: 2,
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
          const CustomText(
              text:
                  "Cinemas is the ultimate experience to see new movies in Gold Class or Vmax. Find a cinema near you."),
          //comment sperated
          const Divider(
            color: lightGrey,
          )
        ],
      ),
    );
  }
}
