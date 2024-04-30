import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExpertCard extends StatelessWidget {
  const ExpertCard(
      {super.key,
      required this.title,
      required this.image,
      required this.location,
      required this.rating});
  final String title;
  final String image;
  final String location;
  final int rating;
  @override
  Widget build(BuildContext context) {
    //TODO: must make it responsive
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 12),
      height: 114,
      width: 362,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/Image.png'),
          const SizedBox(
            width: 16,
          ),
          Column(
            children: [
              Row(
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/map_pin.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    text: location,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: almostGrey,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset("assets/icons/star.svg"),
          const SizedBox(
            width: 5,
          ),
          CustomText(
            text: rating.toString(),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          )
        ],
      ),
    );
  }
}
