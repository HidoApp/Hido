import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomButton(
            onPressed: () {},
            title: "contactHidoTeam".tr,
            icon: SvgPicture.asset("assets/icons/chat_icon.svg"),
            iconColor: colorGreen,
            customWidth: width * 0.7,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
