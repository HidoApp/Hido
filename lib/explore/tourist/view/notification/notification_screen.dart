import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, this.hasNotifications = true});

  final bool hasNotifications;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 40),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      AppUtil.rtlDirection(context)
                          ? Icons.arrow_forward
                          : Icons.arrow_back,
                      color: black,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  CustomText(
                    text: 'notifications'.tr,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                ],
              ),
            ),
            if (!widget.hasNotifications)
              CustomEmptyWidget(
                title: 'noNotification'.tr,
                image: 'no_notifications',
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22.5,
                          backgroundImage:
                              AssetImage('assets/images/ajwadi_image.png'),
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        SizedBox(
                          width: width * 0.48,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: AppUtil.rtlDirection(context)
                                    ? 'أحمد سالم '
                                    : 'Ronald C. Kinch ',
                                style: TextStyle(
                                  fontFamily: AppUtil.rtlDirection(context)
                                      ? 'Noto Kufi Arabic'
                                      : 'Kufam',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: black,
                                ),
                              ),
                              TextSpan(
                                text: AppUtil.rtlDirection(context)
                                    ? 'قبل عرضك'
                                    : 'Accept tour trip',
                                style: TextStyle(
                                  fontFamily: AppUtil.rtlDirection(context)
                                      ? 'Noto Kufi Arabic'
                                      : 'Kufam',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: colorDarkGrey,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const Spacer(),
                        const CustomText(
                          text: '1hr ago',
                          fontSize: 12,
                          fontFamily: 'Kufam',
                          color: colorDarkGrey,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/bell.svg'),
                        const SizedBox(
                          width: 13,
                        ),
                        SizedBox(
                          width: width * 0.48,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: AppUtil.rtlDirection(context)
                                    ? 'هوليدي ان '
                                    : 'Come and visit us in ',
                                style: TextStyle(
                                  fontFamily: AppUtil.rtlDirection(context)
                                      ? 'Noto Kufi Arabic'
                                      : 'Kufam',
                                  fontSize: 14,
                                  fontWeight: AppUtil.rtlDirection(context)
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: AppUtil.rtlDirection(context)
                                      ? black
                                      : colorDarkGrey,
                                ),
                              ),
                              TextSpan(
                                text: AppUtil.rtlDirection(context)
                                    ? 'تدعوكم في حفلها الخيري ١٠ سنوي'
                                    : 'Holiday inn',
                                style: TextStyle(
                                  fontFamily: AppUtil.rtlDirection(context)
                                      ? 'Noto Kufi Arabic'
                                      : 'Kufam',
                                  fontSize: 14,
                                  fontWeight: AppUtil.rtlDirection(context)
                                      ? FontWeight.w400
                                      : FontWeight.w700,
                                  color: AppUtil.rtlDirection(context)
                                      ? colorDarkGrey
                                      : black,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const Spacer(),
                        const CustomText(
                          text: '1hr ago',
                          fontSize: 12,
                          fontFamily: 'Kufam',
                          color: colorDarkGrey,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/sun.svg'),
                        const SizedBox(
                          width: 13,
                        ),
                        SizedBox(
                          width: width * 0.48,
                          child: CustomText(
                            text: AppUtil.rtlDirection(context)
                                ? 'لا تنسى تقييم أحمد سالم'
                                : 'Don’t forget rate your last trip',
                          ),
                        ),
                        const Spacer(),
                        const CustomText(
                          text: '1hr ago',
                          fontSize: 12,
                          fontFamily: 'Kufam',
                          color: colorDarkGrey,
                        ),
                      ],
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
