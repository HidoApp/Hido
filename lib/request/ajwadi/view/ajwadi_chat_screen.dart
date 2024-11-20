import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/widgets/custom_request_text_field.dart';
import 'package:ajwad_v4/request/widgets/custom_trip_option.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AjwadiChatScreen extends StatefulWidget {
  const AjwadiChatScreen({super.key});

  @override
  State<AjwadiChatScreen> createState() => _AjwadiChatScreenState();
}

class _AjwadiChatScreenState extends State<AjwadiChatScreen> {
  bool isDetailsTapped = false;
  late bool isArabicSelected;
  bool isStarChecked = false;
  int startIndex = 0;

  @override
  void initState() {
    super.initState();
    isArabicSelected = AppUtil.rtlDirection(context);
  }

  Future<void> showBottomSheet(double width, double height) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: black,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              width: width,
              height: height * 0.35,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomText(
                      text: AppUtil.rtlDirection(context)
                          ? 'ما رايك في مها كسائح؟'
                          : 'What do you think about Maha As Tourist?',
                      fontFamily: 'Kufam',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                    ),
                    CustomText(
                      text: AppUtil.rtlDirection(context)
                          ? ' قمت بعمل رحلة  في طويق، اليوم الساعة 19:47.'
                          : 'You took Maha in a trip in Tuwaik, today at 19:47.',
                      fontFamily: 'Kufam',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      color: Colors.white,
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
                                isStarChecked = !isStarChecked;
                                startIndex = index;
                              });
                            },
                            child: isStarChecked && startIndex == index
                                ? const Icon(
                                    Icons.star,
                                    size: 40,
                                    color: yellow,
                                  )
                                : const Icon(
                                    Icons.star_border,
                                    size: 40,
                                    color: yellow,
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: black,
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: CustomRequestTextField(
          radius: 4,
          hasPrefixIcon: true,
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
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                      text: 'chat'.tr,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet(width, height);
                  },
                  child: SvgPicture.asset('assets/icons/more.svg'),
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Card(
                    color: darkBlack,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          isDetailsTapped = !isDetailsTapped;
                        });
                      },
                      title: CustomText(
                        text: 'tripDetails'.tr,
                        color: Colors.white,
                      ),
                      trailing: Icon(
                        isDetailsTapped
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF454545),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  if (isDetailsTapped)
                    Card(
                      color: darkBlack,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/ajwadi_image.png'),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                CustomText(
                                  text: AppUtil.rtlDirection(context)
                                      ? 'محمد علي'
                                      : 'Mohamed Ali',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CustomText(
                              text: AppUtil.rtlDirection(context)
                                  ? 'يسعدني مساعدتك,  هذا هو جدول الرحلة ، تحقق من الأشياء التي تريد القيام بها'
                                  : 'I\'m happy to help you, this is the flight schedule check out the things you want to do',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colorDarkGrey,
                            ),
                            const SizedBox(
                              height: 19,
                            ),
                            Stack(
                              children: [
                                Positioned.directional(
                                  textDirection: Directionality.of(context),
                                  start: 7,
                                  child: SizedBox(
                                    width: 2,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 4,
                                        );
                                      },
                                      itemCount: 20,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          color: colorGreen,
                                          width: 2,
                                          height: 8,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTripOption(
                                      price: '23 SAR',
                                      time: '10am - 11am',
                                      perPerson: true,
                                      option: AppUtil.rtlDirection(context)
                                          ? 'فطور على الحافة'
                                          : 'Breakfast in cliff',
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    CustomTripOption(
                                      price: '233 SAR',
                                      time: '11:00pm - 12:00pm',
                                      isChecked: true,
                                      isWhiteOption: true,
                                      option: AppUtil.rtlDirection(context)
                                          ? 'ركوب الاحصنة'
                                          : 'Ride Horses',
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    CustomTripOption(
                                      price: '300 SAR',
                                      time: '01:00pm - 02:00pm',
                                      option: AppUtil.rtlDirection(context)
                                          ? 'غدا في مطعم'
                                          : 'Lunch in restaurant ',
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    CustomTripOption(
                                      price: '200 SAR',
                                      time: '02:00pm - 03:00pm',
                                      isChecked: true,
                                      isWhiteOption: true,
                                      option: AppUtil.rtlDirection(context)
                                          ? 'ذهاب للوادي'
                                          : 'See the cultural in city',
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    CustomTripOption(
                                      price: '43 SAR',
                                      time: '02:00pm - 03:00pm',
                                      isChecked: true,
                                      isWhiteOption: true,
                                      perPerson: true,
                                      option: AppUtil.rtlDirection(context)
                                          ? 'عشاء'
                                          : 'Dinner in cafe',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            CustomText(
                              text: 'totalPayment'.tr,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const CustomText(
                              text: 'SAR 420,50',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 26,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: width * 0.5,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: const BoxDecoration(
                        color: darkBlack,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        text: AppUtil.rtlDirection(context)
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
                                  color: isArabicSelected ? null : colorGreen,
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
                                  color: !isArabicSelected ? null : colorGreen,
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
                  const SizedBox(
                    height: 16,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: width * 0.373,
                      height: 51,
                      decoration: BoxDecoration(
                        color: colorGreen.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        text: isArabicSelected ? 'العربية' : 'English',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        fontFamily: 'Kufam',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: darkBlack,
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
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
