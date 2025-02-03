import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen.dart';
import 'package:ajwad_v4/widgets/icon_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class ContactInfoWidget extends StatelessWidget {
  const ContactInfoWidget(
      {super.key, required this.phoneNumber, required this.chatId});
  final String phoneNumber;
  final String chatId;
  // final Function() chatOnTap;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Row(
      children: [
        if (chatId.isNotEmpty)
          InkWell(
            onTap: () {
              Get.to(() => ChatScreen(chatId: chatId));
            },
            child: IconBackground(
              backgroundColor: colorlightGreen,
              child: SvgPicture.asset(
                'assets/icons/chat_message.svg',
                height: 24,
                width: 24,
              ),
            ),
          ),
        SizedBox(
          width: width * 0.0205,
        ),
        InkWell(
          onTap: () async {
            final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
            if (await canLaunchUrl(whatsappUri)) {
              await launchUrl(whatsappUri);
            } else {
              print("Could not open WhatsApp");
            }
          },
          child: IconBackground(
            backgroundColor: colorlightGreen,
            child: SvgPicture.asset(
              'assets/icons/whatsapp.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.0205,
        ),
        InkWell(
          onTap: () async {
            final Uri callUri = Uri.parse("tel:$phoneNumber");
            if (await canLaunchUrl(callUri)) {
              await launchUrl(callUri);
            } else {
              print("Could not launch call");
            }
          },
          child: IconBackground(
            backgroundColor: colorlightGreen,
            child: SvgPicture.asset(
              'assets/icons/phone.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
      ],
    );
  }
}
