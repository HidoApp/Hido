import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AdCards extends StatelessWidget {
  const AdCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: !AppUtil.rtlDirection(context)
                              ? 'خصومات حصرية لضيوف\n'
                              : 'Exclusive Discounts for\n',
                          style: TextStyle(
                            fontFamily: !AppUtil.rtlDirection(context)
                                ? 'Noto Kufi Arabic'
                                : 'Kufam',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                        ),
                        TextSpan(
                          text: !AppUtil.rtlDirection(context)
                              ? 'هوليداي إن!'
                              : 'Holiday Inn ',
                          style: TextStyle(
                            fontFamily: AppUtil.rtlDirection(context)
                                ? 'Noto Kufi Arabic'
                                : 'Kufam',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: black,
                          ),
                        ),
                        TextSpan(
                          text: AppUtil.rtlDirection(context) ? '' : 'Guests!',
                          style: const TextStyle(
                            fontFamily: 'Kufam',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: 'happyExploring'.tr,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorDarkGrey,
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
    );
  }
}
