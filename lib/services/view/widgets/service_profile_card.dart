import 'package:ajwad_v4/constants/colors.dart';
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
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
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
            image != null
                ? CircleAvatar(
                    radius: 25.5,
                    backgroundImage: NetworkImage(image!),
                  )
                : const CircleAvatar(
                    radius: 25.5,
                    backgroundImage:
                        AssetImage('assets/images/profile_image.png'),
                  ),
            const SizedBox(
              width: 30,
            ),
            CustomText(
              text: name,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            )
          ],
        ),
      ),
    );
  }
}
