import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomRateOrderCard extends StatefulWidget {
  CustomRateOrderCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomRateOrderCard> createState() => _CustomRateOrderCardState();
}

class _CustomRateOrderCardState extends State<CustomRateOrderCard> {
  int _curentIndex = -1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 115,
              width: 94,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/product_detail1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Soap Lavender',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                SizedBox(
                  height: 2,
                ),
                CustomText(
                  text: 'SAR 150.00',
                  fontSize: 16,
                ),
                SizedBox(
                  height: 8,
                ),
                CustomText(
                  text: 'Wooden bedside table featuring ...',
                  color: almostGrey,
                ),
                Container(
                  height: 40,
                  width: width * 0.5,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _curentIndex = i;
                            });
                          },
                          child: _curentIndex < i
                              ? SvgPicture.asset(
                                  height: 25, 'assets/icons/star_outlined.svg')
                              : SvgPicture.asset(
                                  height: 25, 'assets/icons/star.svg'),
                        );
                      },
                      separatorBuilder: (_, i) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemCount: 5),
                )
              ],
            )
          ],
        ));
  }
}
