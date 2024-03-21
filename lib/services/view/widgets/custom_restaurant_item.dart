import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRestaurantItem extends StatelessWidget {
  const CustomRestaurantItem({
    super.key,
    required this.image,
    required this.title,
    required this.time,
    required this.onTap,
  });

  final String image;
  final String title;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      radius: 16,
      child: Container(
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(16))),
        height: height * 0.3,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 12,
                  color: darkGrey.withOpacity(0.1))
            ]),

        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: width,
                    child: Image.asset(
                      'assets/images/resturant_image.png',
                      fit: BoxFit.fitWidth,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomText(
                    text: AppUtil.rtlDirection(context)
                        ? 'مطعم الركن السعودي'
                        : 'Saudi Corner Restaurant',
                    fontSize: 20,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomText(
                    text: AppUtil.rtlDirection(context)
                        ? 'يقوم هذا المطعم بتقديم الأكل السعودي '
                        : 'this restaurant is sell every Saudi food...',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     ClipRRect(
                //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                //       child: Image.asset(image),
                //     ),
                //     const SizedBox(
                //       width: 18,
                //     ),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         CustomText(
                //           text: title,
                //           fontSize: 18,
                //           fontWeight: FontWeight.w500,
                //         ),
                //         const SizedBox(
                //           height: 28,
                //         ),
                //         CustomText(
                //           text: time,
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //           fontFamily: 'Kufam',
                //           color: yellow,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                      color: reddishOrange.withOpacity(0.9),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 30,
                  )
                  //SvgPicture.asset(''),
                  ),
            ),
            Positioned(
              top: height * 0.198,
              left: width * 0.05,
              child: Container(
                  height: 30,
                  width: 76,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 7,
                            color: reddishOrange.withOpacity(0.5))
                      ]
                      //   shape: BoxShape.circle
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                            text: '4.5',
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                        const SizedBox(
                          width: 2,
                        ),
                        SvgPicture.asset('assets/icons/star.svg'),
                        const SizedBox(
                          width: 2,
                        ),
                        const CustomText(
                          text: '(25+)',
                          fontWeight: FontWeight.w200,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  )
                  //SvgPicture.asset(''),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
