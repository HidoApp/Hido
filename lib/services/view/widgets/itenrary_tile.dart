import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ItineraryTile extends StatelessWidget {
  const ItineraryTile({
    super.key,
    required this.title,
    required this.image,
    this.imageUrl,
    this.color = borderGrey,
    this.line = false,
    this.widthImage,
  });

  final String title;
  final String image;
  final String? imageUrl;
  final bool line;
  final Color? color;
  final double? widthImage;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widthImage == null
            ? RepaintBoundary(child: SvgPicture.asset(image))
            : RepaintBoundary(
                child: SvgPicture.asset(image, width: widthImage)),
        const SizedBox(
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
          child: CustomText(
            text: title,
            color: color ?? borderGrey,
            fontSize: width * 0.03,
            fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            fontWeight: FontWeight.w400,
            textDecoration:
                line ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
        if (line)
          RepaintBoundary(
            child: SvgPicture.asset(
              "assets/icons/arrow_up.svg",
              // width: width * 0.05,
            ),
          ),
      ],
    );
  }
}
