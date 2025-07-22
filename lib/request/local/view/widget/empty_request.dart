import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmptyRequest extends StatelessWidget {
  const EmptyRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/emptyRequest.svg'),
          CustomText(
            text: "offline".tr,
            color: almostGrey,
            fontSize: width * 0.043,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: width * 0.010,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * 0.76),
            child: CustomText(
              text: 'offlineText'.tr,
              color: almostGrey,
              fontSize: width * 0.04,
            ),
          )
        ],
      ),
    );
  }
}
