import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReviewTicket extends StatelessWidget {
  const ReviewTicket(
      {super.key, required this.person, required this.adventure});
  final int person;
  final Adventure adventure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Review Booking"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Adventure Details",
              fontSize: 18,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/locationHos.svg",
                  color: starGreyColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? adventure.regionAr!
                      : adventure.regionEn!,
                  color: colorDarkGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/grey_calender.svg',
                  color: starGreyColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  text: DateFormat('E-dd-MMM')
                      .format(DateTime.parse(adventure!.date!)),
                  color: colorDarkGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/timeGrey.svg",
                  color: starGreyColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                const CustomText(
                  text: "5:00-8:00 AM ",
                  color: colorDarkGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: almostGrey,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomText(
              text: "Number of People",
              fontSize: 18,
            ),
            Row(
              children: [
                const CustomText(
                  text: "person",
                  color: almostGrey,
                  fontSize: 15,
                ),
                const Spacer(),
                CustomText(
                  text: person.toString(),
                  color: almostGrey,
                  fontSize: 15,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const Divider(
              color: almostGrey,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomText(
              text: "Booking Date & Time ",
              fontSize: 18,
            ),
            Row(
              children: [
                CustomText(
                  color: almostGrey,
                  text: DateFormat('d MMMM y')
                      .format(DateTime.parse(DateTime.now().toString())),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  color: almostGrey,
                  text: DateFormat('h:mm a')
                      .format(DateTime.parse(DateTime.now().toString())),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: almostGrey,
            ),
            const SizedBox(
              height: 232,
            ),
            const DottedSeparator(
              color: almostGrey,
              height: 1,
            ),
            const SizedBox(
              height: 28,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Total',
                  fontSize: 20,
                ),
                Spacer(),
                CustomText(
                  text: 'SAR ${adventure.price.toString()}',
                  fontSize: 20,
                )
              ],
            ),
            const Spacer(),
            CustomButton(onPressed: () {}, title: 'Checkout')
          ],
        ),
      ),
    );
  }
}
