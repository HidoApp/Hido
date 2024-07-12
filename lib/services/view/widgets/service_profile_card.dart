import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ServicesProfileCard extends StatelessWidget {
  const ServicesProfileCard(
      {super.key,
      required this.name,
      required this.image,
      required this.onTap});
  final String name;
  final String image;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: almostGrey.withOpacity(0.2),
                spreadRadius: -3,
                blurRadius: 5,
                offset: const Offset(4, 6))
          ],
        ),
        child: Row(
          children: [
            image != ""
                ? CircleAvatar(
                    radius: 20.5,
                    backgroundImage: NetworkImage(image),
                  )
                : const CircleAvatar(
                    radius: 20.5,
                    backgroundImage:
                        AssetImage('assets/images/profile_image.png'),
                  ),
            const SizedBox(
              width: 15,
            ),
            CustomText(
              text: name,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',
            )
          ],
        ),
      ),
    );
  }
}
