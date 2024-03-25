import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TripCard extends StatelessWidget {
  const TripCard(
      {super.key,
      required this.title,
      required this.location,
      required this.image});
  final String title;
  final String location;
  final String image;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      //places card
      width: 362,
      height: 102,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black.withOpacity(0.2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              child: Image.network(
                image,
                fit: BoxFit.fill,
                width: width * 0.2,
                height: height * 0.1,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //title of places
                  CustomText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/map_pin.svg'),
                      const SizedBox(
                        width: 8,
                      ),
                      //city
                      CustomText(
                        text: location,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: textGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                color: colorDarkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
