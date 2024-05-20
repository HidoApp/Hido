import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/services/view/widgets/review_guests.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class ReviewAdventure extends StatelessWidget {
  const ReviewAdventure({
    super.key,
    required this.person,
    required this.adventure,
  });
  final int person;
  final Adventure adventure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar("Review Booking"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Adventure Details",
              fontSize: 18,
            ),
            const SizedBox(
              height: 4,
            ),
            ReviewDetailsTile(
                title: AppUtil.rtlDirection2(context)
                    ? adventure.regionAr!
                    : adventure.regionEn!,
                image: "assets/icons/locationHos.svg"),
            const SizedBox(
              height: 4,
            ),
            // Details
            ReviewDetailsTile(
                title: DateFormat('E-dd-MMM').format(
                  DateTime.parse(adventure!.date!),
                ),
                image: 'assets/icons/grey_calender.svg'),
            const SizedBox(
              height: 4,
            ),
            const ReviewDetailsTile(
                title: "5:00-8:00 AM ", image: "assets/icons/timeGrey.svg"),
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
            ReviewGuestsTile(
              guest: person,
              title: "person",
            ),
            const Divider(
              color: almostGrey,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 268,
            ),
            //discount widget
            Container(
              child: Text("sss"),
            ),
            Spacer(),
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
            SizedBox(
              height: 20,
            ),
            CustomButton(onPressed: () {}, title: 'Checkout')
          ],
        ),
      ),
    );
  }
}

