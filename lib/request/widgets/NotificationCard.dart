import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/utils/app_util.dart';


class NotificationCrd extends StatelessWidget {
  const NotificationCrd({
    Key? key,
      required this.name,
      required this.isRtl,
      required this.width,
      required this.days,


  }) : super(key: key);
 final String name;
  final double width;
  final bool isRtl;
  final String  days;


 @override
Widget build(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/icons/bell.svg'),
            const SizedBox(width: 13),
            SizedBox(
              width: width * 0.48,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: isRtl ? "رحلتك القادمة الى  " : 'Your next tour to ',
                    style: TextStyle(
                      fontFamily: isRtl ? 'Noto Kufi Arabic' : 'Kufam',
                      fontSize: 14,
                      fontWeight: isRtl ? FontWeight.w700 : FontWeight.w400,
                      color: isRtl ? Colors.black : colorDarkGrey,
                    ),
                  ),
                  TextSpan(
                    text: name + days,
                    style: TextStyle(
                      fontFamily: isRtl ? 'Noto Kufi Arabic' : 'Kufam',
                      fontSize: 14,
                      fontWeight: isRtl ? FontWeight.w400 : FontWeight.w700,
                      color: isRtl ? colorDarkGrey : Colors.black,
                    ),
                  ),
                ]),
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle button press
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        width: 30,
      ),
      // const Divider(),
    ],
  );
}

}