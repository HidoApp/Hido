import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.image,
    this.personImage,
    required this.title,
    required this.location,
    required this.meal,
    required this.category,
    required this.rate,
    required this.onTap,
    this.dayInfo,
  });

  final String image;
  final String? personImage;
  final String title;
  final String location;
  final String meal;
  final String category;
  final String rate;
  final List<DayInfo>? dayInfo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Container(
          width: 362,
          height: 114,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black12)],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        bottom: 7,
                        start: 7,
                        child: personImage == null
                            ? const CircleAvatar(
                                radius: 12.5,
                                backgroundImage: AssetImage(
                                    'assets/images/profile_image.png'),
                              )
                            : CircleAvatar(
                                radius: 13.5,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 12.5,
                                  backgroundImage: NetworkImage(personImage!),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          SvgPicture.asset(
                            'assets/icons/map_pin.svg',
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
                        height: 8,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/grey_calender.svg'),
                              const SizedBox(
                                width: 4,
                              ),
                              if (dayInfo != null || dayInfo != [])
                                CustomText(
                                  text: dayInfo![0].startTime.substring(0, 10),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: starGreyColor,
                                ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/meal_icon.svg'),
                              // SvgPicture.asset('assets/icons/calendar.svg',color: purple,),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              SizedBox(
                                width: 100,
                                child: CustomText(
                                  text: meal,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: starGreyColor,
                                  maxlines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SvgPicture.asset('assets/icons/star.svg'),
              SizedBox(
                width: width * 0.01,
              ),
              CustomText(
                text: rate,
                fontSize: width * 0.025,
                fontWeight: FontWeight.w700,
                color: colorDarkGreen,
                fontFamily: 'Kufam',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
