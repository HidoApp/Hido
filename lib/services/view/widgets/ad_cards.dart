import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AdCards extends StatelessWidget {
  const AdCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: purple.withOpacity(0.16),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                if (!AppUtil.rtlDirection(context))
                  Image.asset('assets/images/percent.png'),
                Padding(
                  padding: EdgeInsets.only(
                    right: !AppUtil.rtlDirection(context) ? 22 : 0,
                    left: !AppUtil.rtlDirection(context) ? 0 : 22,
                    top: 22,
                    bottom: 17,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'خصومات حصرية لضيوف\n'
                                  : 'Exclusive Discounts for\n',
                              style: TextStyle(
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'Noto Kufi Arabic'
                                    : 'SF Pro',
                                color: Color(0xFF14143E),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'هوليداي إن!'
                                  : 'Holiday Inn ',
                              style: TextStyle(
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'Noto Kufi Arabic'
                                    : 'SF Pro',
                                color: Color(0xFF9747FF),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: AppUtil.rtlDirection2(context)
                                  ? ' '
                                  : ' Guests!\n',
                              style: const TextStyle(
                                fontFamily: 'Kufam',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: black,
                              ),
                            ),
                            TextSpan(
                              text: 'happyExploring'.tr,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C0C25),
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (AppUtil.rtlDirection(context))
                  Image.asset('assets/images/percent.png'),
                Image.asset(
                  'assets/images/holiday.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
