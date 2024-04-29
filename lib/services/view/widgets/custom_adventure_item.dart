import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAdventureItem extends StatelessWidget {
  const CustomAdventureItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.rate,
    required this.location,
    required this.description,
  });

  final VoidCallback onTap;
  final String title;
  final String rate;
  final String location;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: 8,
      child: SizedBox(
        width: 253,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/camel.png'),
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 4,
                      end: 8,
                      child: Container(
                        width: 31,
                        height: 31,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff3A3A3A).withOpacity(0.3),
                        ),
                        child:
                            SvgPicture.asset('assets/icons/heart_rounded.svg'),
                      ),
                    ),
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      bottom: 8,
                      start: 8,
                      child: SizedBox(
                        height: 21,
                        child: Row(
                          children: [
                            ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return const Align(
                                    widthFactor: 0.6,
                                    child: CircleAvatar(
                                      radius: 10.5,
                                      backgroundImage: AssetImage(
                                          'assets/images/ajwadi_image.png'),
                                    ),
                                  );
                                }),
                            const Align(
                              widthFactor: 0.6,
                              child: CircleAvatar(
                                radius: 10.5,
                                backgroundColor: pink,
                                child: CustomText(
                                  text: '3+',
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'Kufam',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: title,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/popularity.svg'),
                              const SizedBox(
                                width: 4,
                              ),
                              CustomText(
                                text: rate,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: starGreyColor,
                                fontFamily: 'Kufam',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [ 
                          SvgPicture.asset(
                            'assets/icons/location_pin.svg',
                            color: pink,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CustomText(
                            text: location,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 230,
                        child: CustomText(
                          text: description,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffA3A3A3),
                          maxlines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
