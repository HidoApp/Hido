import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/experience_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostInfoReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Review'.tr,
        isAjwadi: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviewexperience'.tr,
              style: TextStyle(
                color: Color(0xFF070708),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Text(
                'explination'.tr,
                style: TextStyle(
                  color: Color(0xFF9392A0),
                  fontSize: 15,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3FC7C7C7),
                    blurRadius: 16,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage("https://via.placeholder.com/90x90"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ahmad’s house',
                              style: TextStyle(
                                color: Color(0xFF070708),
                                fontSize: 16,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFF36B268), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '5.0',
                                  style: TextStyle(
                                    color: Color(0xFF36B268),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Riyadh,Al-Majma\'ah, Saudi Arabia',
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Wed 28 Apr - 2 PM',
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.restaurant, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Lunch',
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    // SizedBox(
                                    //     width:
                                    //         68), // Adjust spacing between text and button
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 16, vertical: 8),
                                    //   decoration: BoxDecoration(
                                    //     color: Color(0xFFECF9F1),
                                    //     borderRadius:
                                    //         BorderRadius.circular(9999),
                                    //   ),
                                    //   child: Text(
                                    //     'show preview',
                                    //     style: TextStyle(
                                    //       color: Color(0xFF36B268),
                                    //       fontSize: 13,
                                    //       fontFamily: 'SF Pro',
                                    //       fontWeight: FontWeight.w400,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 35),
                    child: Container(
                      child: CustomButton(onPressed: () {}, title: 'Publish'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
