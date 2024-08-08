import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ItineraryTile extends StatelessWidget {
  const ItineraryTile(
      {super.key,
      required this.title,
      required this.image,
      this.imageUrl,
      this.color= borderGrey,
      this.line = false,
      this.widthImage = 0,
});

  final String title;
  final String image;
  final String? imageUrl;
  final bool line;
  final Color? color;
  final double widthImage;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       SvgPicture.asset(image),
        SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: imageUrl != ''
              ? () async {
                  final Uri url = Uri.parse(imageUrl!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              : () {},
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: width * 0.03,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
              decoration: line?TextDecoration.underline:TextDecoration.none,
            ),
          ),
        ),
        if (line)
          SvgPicture.asset(
            "assets/icons/arrow_up.svg",
            // width: width * 0.05,
          ),
      ],
    );
  }
}
