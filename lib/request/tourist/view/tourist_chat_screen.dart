import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/view/check_out_screen.dart';
import 'package:ajwad_v4/request/widgets/custom_request_text_field.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';

import 'package:ajwad_v4/request/tourist/models/offer_details.dart';

import 'package:intl/intl.dart' as intel;

class TouristChatScreen extends StatefulWidget {
  const TouristChatScreen({
    super.key,
    this.isChat = true,
    this.booking,
    this.place,
  });

  final bool isChat;
  final Booking? booking;
  final Place? place;
  @override
  State<TouristChatScreen> createState() => _TouristChatScreenState();
}

class _TouristChatScreenState extends State<TouristChatScreen> {
  bool isDetailsTapped1 = false;
  bool isDetailsTapped2 = false;
  bool isIconDisabled = false;

  late bool isArabicSelected;
  bool isStarChecked = false;
  int startIndex = -1;
  bool isSendTapped = false;

  @override
  void initState() {
    super.initState();
    isArabicSelected = AppUtil.rtlDirection(context);
  }

  Future<void> showBottomSheet(
      double width, double height, Function(bool) updateIconDisabled) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            width: width,
            height: isStarChecked ? height * 0.4 : height * 0.35,
            child: isStarChecked
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'sorryForHearingThat'.tr,
                          fontFamily: 'Kufam',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        CustomText(
                          text: 'tellUsWhatHappened'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        CustomTextArea(
                          onChanged: (value) {},
                        ),
                        CustomButton(
                          onPressed: () {
                            setState(() {
                              isSendTapped = false;
                              isStarChecked = false;
                              updateIconDisabled(
                                  true); // Update the state of the parent widget
                            });
                            Get.back();
                          },
                          title: 'send'.tr,
                          icon: AppUtil.rtlDirection2(context)
                              ? const Icon(Icons.arrow_back)
                              : const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                  )
                : isSendTapped
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'ما رايك في محمد كأجودي؟'
                                  : 'What do you think about Mohammed As ajwady?',
                              fontFamily: 'Kufam',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                            ),
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'محمد أخذك في رحلة في طويق ، اليوم الساعة 19:47.'
                                  : 'Mohammed give you a trip in Tuwaik , today at 19:47.',
                              fontFamily: 'Kufam',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 16,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        startIndex = index;
                                      });
                                    },
                                    child: index <= startIndex
                                        ? const Icon(
                                            Icons.star,
                                            size: 40,
                                            color: Colors.yellow,
                                          )
                                        : const Icon(
                                            Icons.star_border,
                                            size: 40,
                                            color: Colors.yellow,
                                          ),
                                  );
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (startIndex + 1 <= 2) {
                                  // Show "What happened" part
                                  setState(() {
                                    isStarChecked = true;
                                  });
                                } else {
                                  // Finish and close the bottom sheet
                                  setState(() {
                                    updateIconDisabled(
                                        true); // Update the state of the parent widget
                                  });
                                  Get.back();
                                }
                              },
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'howWasTheTrip'.tr,
                              fontFamily: 'Kufam',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                            CustomTextArea(
                              onChanged: (value) {},
                            ),
                            CustomButton(
                              onPressed: () {
                                setState(() {
                                  isSendTapped = true;
                                });
                              },
                              title: 'send'.tr,
                              icon: AppUtil.rtlDirection2(context)
                                  ? const Icon(Icons.arrow_back)
                                  : const Icon(Icons.arrow_forward),
                            )
                          ],
                        ),
                      ),
          );
        });
      },
    );
  }

  void updateIconDisabled(bool value) {
    setState(() {
      isIconDisabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: lightGreyBackground,
      bottomNavigationBar: widget.isChat
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: Colors.white,
              child: const CustomRequestTextField(
                radius: 4,
                hasPrefixIcon: true,
                isTourist: true,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomButton(
                onPressed: () {
                  Get.to((() => const CheckOutScreen()));
                },
                title: 'pay'.tr,
                icon: AppUtil.rtlDirection2(context)
                    ? const Icon(Icons.arrow_back)
                    : const Icon(Icons.arrow_forward),
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 40,
          right: 24,
          left: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              textDirection: AppUtil.rtlDirection2(context)
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IgnorePointer(
                  ignoring: isIconDisabled, // Set this based on your logic
                  child: InkWell(
                    onTap: () {
                      showBottomSheet(width, height, updateIconDisabled);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/more.svg',
                      color: isIconDisabled ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                Row(
                  textDirection: AppUtil.rtlDirection2(context)
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    CustomText(
                      text: 'chat'.tr,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        AppUtil.rtlDirection2(context)
                            ? Icons.arrow_back
                            : Icons.arrow_back,
                        color: black,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          isDetailsTapped1 = !isDetailsTapped1;
                        });
                      },
                      title: CustomText(
                        text: 'tripDetails'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        textAlign: AppUtil.rtlDirection2(context)
                            ? TextAlign.right
                            : TextAlign.left,
                      ),
                      trailing: Icon(
                        isDetailsTapped1
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: lightBlack,
                        size: 24,
                      ),
                    ),
                  ),

                  if (isDetailsTapped1)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      padding: const EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/guests.svg'),
                                const SizedBox(width: 10),
                                CustomText(
                                  text:
                                      '${widget.booking?.guestNumber ?? 0} ${'guests'.tr}',
                                  color: almostGrey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/date.svg'),
                                const SizedBox(width: 10),
                                CustomText(
                                  text:
                                      '${intel.DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.booking?.date ?? '2022-01-01'))} - ${widget.booking?.timeToGo}',
                                  color: almostGrey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
                                  width: 20,
                                ),
                                const SizedBox(width: 10),
                                CustomText(
                                  text: widget.booking?.vehicleType ?? '',
                                  color: almostGrey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 32,
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          isDetailsTapped2 = !isDetailsTapped2;
                        });
                      },
                      title: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/ajwadi_image.png'),
                          ),
                          const SizedBox(width: 12),
                          CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? 'محمد علي'
                                : 'Mohamed Ali',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Kufam',
                            textAlign: AppUtil.rtlDirection2(context)
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ],
                      ),
                      trailing: Icon(
                        isDetailsTapped2
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF454545),
                        size: 24,
                      ),
                    ),
                  ),

                  if (isDetailsTapped2)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'يسعدني مساعدتك,  هذا هو جدول الرحلة ، تحقق من الأشياء التي تريد القيام بها'
                                  : 'I\'m happy to help you, this is the flight schedule check out the things you want to do',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colorDarkGrey,
                              textAlign: AppUtil.rtlDirection2(context)
                                  ? TextAlign.right
                                  : TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // SizedBox(
                  //   height: widget.isChat ? 8 : 19,
                  // ),
                  // if (!widget.isChat)
                  //   Stack(
                  //     children: [
                  //       Positioned.directional(
                  //         textDirection: Directionality.of(context),
                  //         start: 7,
                  //         child: SizedBox(
                  //           width: 2,
                  //           child: ListView.separated(
                  //             shrinkWrap: true,
                  //             physics:
                  //                 const NeverScrollableScrollPhysics(),
                  //             separatorBuilder: (context, index) {
                  //               return const SizedBox(
                  //                 height: 4,
                  //               );
                  //             },
                  //             itemCount: 20,
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 color: colorGreen,
                  //                 width: 2,
                  //                 height: 8,
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //       Column(
                  //         crossAxisAlignment:
                  //             CrossAxisAlignment.start,
                  //         children: [
                  //           CustomTripOption(
                  //             price: '23 SAR',
                  //             time: '10am - 11am',
                  //             perPerson: true,
                  //             option: AppUtil.rtlDirection(context)
                  //                 ? 'فطور على الحافة'
                  //                 : 'Breakfast in cliff',
                  //             isTourist: true,
                  //           ),
                  //           const SizedBox(
                  //             height: 18,
                  //           ),
                  //           CustomTripOption(
                  //             price: '233 SAR',
                  //             time: '11:00pm - 12:00pm',
                  //             isChecked: true,
                  //             isWhiteOption: true,
                  //             option: AppUtil.rtlDirection(context)
                  //                 ? 'ركوب الاحصنة'
                  //                 : 'Ride Horses',
                  //             isTourist: true,
                  //           ),
                  //           const SizedBox(
                  //             height: 18,
                  //           ),
                  //           CustomTripOption(
                  //             price: '300 SAR',
                  //             time: '01:00pm - 02:00pm',
                  //             option: AppUtil.rtlDirection(context)
                  //                 ? 'غدا في مطعم'
                  //                 : 'Lunch in restaurant ',
                  //             isTourist: true,
                  //           ),
                  //           const SizedBox(
                  //             height: 18,
                  //           ),
                  //           CustomTripOption(
                  //             price: '200 SAR',
                  //             time: '02:00pm - 03:00pm',
                  //             isChecked: true,
                  //             isWhiteOption: true,
                  //             option: AppUtil.rtlDirection(context)
                  //                 ? 'ذهاب للوادي'
                  //                 : 'See the cultural in city',
                  //             isTourist: true,
                  //           ),
                  //           const SizedBox(
                  //             height: 18,
                  //           ),
                  //           CustomTripOption(
                  //             price: '43 SAR',
                  //             time: '02:00pm - 03:00pm',
                  //             isChecked: true,
                  //             isWhiteOption: true,
                  //             perPerson: true,
                  //             option: AppUtil.rtlDirection(context)
                  //                 ? 'عشاء'
                  //                 : 'Dinner in cafe',
                  //             isTourist: true,
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),

                  const SizedBox(
                    height: 26,
                  ),
                  if (widget.isChat)
                    Column(
                      children: [
                        Align(
                          alignment: AppUtil.rtlDirection2(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: width * double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'ما هي اللغة التي تفضلها ؟'
                                  : 'What language would you prefer ?',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colorDarkGrey,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: width,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isArabicSelected = false;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: isArabicSelected
                                            ? Border.all(
                                                color: colorGreen,
                                                width: 1.5,
                                              )
                                            : null,
                                        color: isArabicSelected
                                            ? null
                                            : colorGreen,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: CustomText(
                                        text: 'English',
                                        color: isArabicSelected
                                            ? colorGreen
                                            : Colors.white,
                                        fontFamily: 'Kufam',
                                        fontSize: isArabicSelected ? 14 : 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isArabicSelected = true;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: !isArabicSelected
                                            ? Border.all(
                                                color: colorGreen,
                                                width: 1.5,
                                              )
                                            : null,
                                        color: !isArabicSelected
                                            ? null
                                            : colorGreen,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: CustomText(
                                        text: 'العربية',
                                        color: !isArabicSelected
                                            ? colorGreen
                                            : Colors.white,
                                        fontFamily: 'Kufam',
                                        fontSize: !isArabicSelected ? 14 : 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Container(
                        //     width: width * 0.373,
                        //     height: 51,
                        //     decoration: BoxDecoration(
                        //       color: colorGreen.withOpacity(0.2),
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(12)),
                        //     ),
                        //     alignment: Alignment.center,
                        //     child: CustomText(
                        //       text: isArabicSelected ? 'العربية' : 'English',
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w700,
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            text: isArabicSelected
                                ? 'رائع ، سآتي اصطحابك الساعة 10:00 صباحًا في سيارة جي إم سي - سوداء - الرقم: S B A 0 9 9'
                                : 'Great, i will come and pick you at 10:00AM in GMC Car  - Black -Number: S B A 0 9 9',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorDarkGrey,
                            textAlign: isArabicSelected
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (!widget.isChat)
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: starGreyColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: const Color(0xffEBEBEB))),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: colorGreen,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/check.svg'),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CustomText(
                              text: 'available'.tr,
                              fontWeight: FontWeight.w700,
                              color: colorGreen,
                            ),
                          ],
                        ),
                        const CustomText(
                          text: 'Aj20',
                          fontFamily: 'Kufam',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'total'.tr,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      const CustomText(
                        text: 'SAR 420,50',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'discount'.tr,
                        color: almostGrey,
                      ),
                      const CustomText(
                        text: 'SAR 25,00',
                        color: almostGrey,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
