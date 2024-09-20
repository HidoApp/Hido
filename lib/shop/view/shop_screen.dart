import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/shop/view/product_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isSoapFavorite = false;
  bool isAccessoriesFavorite = false;
  bool isAvilablee = false;
  int soapIndex = 0;
  int accessoriesIndex = 0;

  List<String> crafts = [
    'soap',
    'accessories',
    'perfum',
    'soap',
    'accessories',
    'perfum'
  ];
  List<Color> colors = [reddishOrange, gold, pink, blue, colorGreen, purple];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 49),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   textDirection: TextDirection.ltr,
            //   children: [
            //     InkWell(
            //       onTap: () {},
            //       child: Container(
            //         height: 36,
            //         width: width * 0.536,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(18),
            //         ),
            //         alignment: Alignment.center,
            //         // child: Row(
            //         //   children: [
            //         //     const SizedBox(
            //         //       width: 22,
            //         //     ),
            //         //     SvgPicture.asset(
            //         //       'assets/icons/search.svg',
            //         //     ),
            //         //     const SizedBox(
            //         //       width: 12,
            //         //     ),
            //         //     CustomText(
            //         //       text: 'search'.tr,
            //         //       fontSize: 14,
            //         //       fontWeight: FontWeight.w400,
            //         //       color: thinGrey.withOpacity(0.5),
            //         //     ),
            //         //   ],
            //         // ),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {},
            //       child: Container(
            //         width: 36,
            //         height: 36,
            //         decoration: const BoxDecoration(
            //           shape: BoxShape.circle,
            //       //    color: pink,
            //         ),
            //         alignment: Alignment.center,
            //      //   child: SvgPicture.asset('assets/icons/heart-filled.svg'),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {
            //       //  Get.to(() => const TicketScreen());
            //       },
            //       child: Container(
            //         width: 36,
            //         height: 36,
            //         decoration: const BoxDecoration(
            //           shape: BoxShape.circle,
            //        //   color: blue,
            //         ),
            //         alignment: Alignment.center,
            //      //   child: SvgPicture.asset('assets/icons/bag.svg'),
            //       ),
            //     ),

            //    InkWell(
            //                 onTap: () {

            //               ProfileController _profileController = Get.put(ProfileController());
            //                 Get.to(()
            //                    =>  AppUtil.isGuest()
            //   ? const SignInScreen()
            //   :TicketScreen(profileController:_profileController));

            //                   //   Get.to(() => const TicketScreen());
            //                 },
            //                 child: Container(
            //                   width: 36,
            //                   height: 36,
            //                   decoration: const BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     color: reddishOrange,
            //                   ),
            //                   alignment: Alignment.center,
            //                   child:
            //                       SvgPicture.asset('assets/icons/ticket.svg'),
            //                 ),
            //               ),
            //                   InkWell(
            //              onTap: () {
            //                 ProfileController _profileController = Get.put(ProfileController());
            //               Get.to(() =>
            //                AppUtil.isGuest()
            //   ? const SignInScreen()
            //   : MessagesScreen(  profileController: _profileController));
            //             },
            //             child: Container(
            //               width: 36,
            //               height: 36,
            //               decoration: const BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: pink,
            //               ),
            //               alignment: Alignment.center,
            //               child: SvgPicture.asset('assets/icons/message.svg'),
            //             ),
            //           ),
            //     // InkWell(
            //     //   onTap: () {
            //     //     Get.to(() => const NotificationScreen());
            //     //   },
            //     //   child: Container(
            //     //     width: 36,
            //     //     height: 36,
            //     //     decoration: const BoxDecoration(
            //     //       shape: BoxShape.circle,
            //     //       color: colorGreen,
            //     //     ),
            //     //     alignment: Alignment.center,
            //     //     child: SvgPicture.asset('assets/icons/notifications.svg'),
            //     //   ),
            //     // ),
            //   ],
            // ),
            const SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: CustomText(
                text: 'craftTitle'.tr,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Kufam',
                height: 1.735,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: CustomText(
                text: 'craftSubtitle'.tr,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colorDarkGrey,
                height: 1.735,
              ),
            ),
            if (!AppUtil.rtlDirection(context))
              const Padding(
                padding: EdgeInsets.only(right: 7),
                child: CustomText(
                  text: 'Support local businesses and artisans!',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorDarkGrey,
                  height: 1.735,
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 32,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: crafts.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 9,
                  );
                },
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: CustomText(
                      text: crafts[index].tr,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            CustomText(
              text: 'soap'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 250,
              child: !isAvilablee
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.04,
                          ),
                          // Image.asset(
                          //   'assets/images/hido_logo.png',
                          //   color: blue,
                          // ),
                          // SizedBox(
                          //   height: height * 0.02,
                          // ),
                          CustomText(
                            text: 'commingSoon'.tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            textAlign: TextAlign.center,
                            color: colorDarkGrey,
                          )
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 16,
                        );
                      },
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 135,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ProductDetails());
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Image.asset('assets/images/soap.png'),
                                    Positioned(
                                      top: 6.56,
                                      left: 6.56,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          color: colorGreen,
                                        ),
                                        child: CustomText(
                                          text: 'new'.tr,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: AppUtil.rtlDirection(context)
                                        ? 'صابونةاللافندر'
                                        : 'Soap Lavender',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        soapIndex = index;
                                        isSoapFavorite = !isSoapFavorite;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                        'assets/icons/${isSoapFavorite && soapIndex == index ? 'heart_filled' : 'heart_outlined'}.svg'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              CustomText(
                                text: AppUtil.rtlDirection(context)
                                    ? 'هي صابونية طبيعية مصنوعة من مزيج فريد من الحلبة واللافندر الطبيعيين، والذين يعرفون بفوائدهما المهدئة للبشرة. يتميز هذا الصابون بتركيبته الطبيعية التي تنظف البشرة بلطف وترطبها بشكل فعال، مع ترك رائحة اللافندر العطرية الرائعة على الجلد.'
                                    : 'Wooden bedside table featuring a raised desi...',
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                maxlines: 2,
                                color: almostGrey,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            CustomText(
              text: 'accessories'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 250,
              child: !isAvilablee
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.04,
                          ),
                          // Image.asset(
                          //   'assets/images/hido_logo.png',
                          //   color: blue,
                          // ),
                          // SizedBox(
                          //   height: height * 0.02,
                          // ),
                          CustomText(
                            text: 'commingSoon'.tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            textAlign: TextAlign.center,
                            color: colorDarkGrey,
                          )
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 16,
                        );
                      },
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 135,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Image.asset('assets/images/accessories.png'),
                                  Positioned(
                                    top: 6.56,
                                    left: 6.56,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        color: colorGreen,
                                      ),
                                      child: CustomText(
                                        text: 'new'.tr,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: AppUtil.rtlDirection(context)
                                        ? 'صابونةاللافندر'
                                        : 'Soap Lavender',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        accessoriesIndex = index;
                                        isAccessoriesFavorite =
                                            !isAccessoriesFavorite;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                        'assets/icons/${isAccessoriesFavorite && accessoriesIndex == index ? 'heart_filled' : 'heart_outlined'}.svg'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              CustomText(
                                text: AppUtil.rtlDirection(context)
                                    ? 'هي صابونية طبيعية مصنوعة من مزيج فريد من الحلبة واللافندر الطبيعيين، والذين يعرفون بفوائدهما المهدئة للبشرة. يتميز هذا الصابون بتركيبته الطبيعية التي تنظف البشرة بلطف وترطبها بشكل فعال، مع ترك رائحة اللافندر العطرية الرائعة على الجلد.'
                                    : 'Wooden bedside table featuring a raised desi...',
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                maxlines: 2,
                                color: almostGrey,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
