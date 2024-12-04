import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

class ChatBubble extends StatelessWidget {
  // final String name;
  // final String? image;
  final ChatMessage message;
  final bool isSender;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    //  required this.name,
    // required this.image
  });

  @override
  Widget build(BuildContext context) {
    //isSender = (message.senderId == userId)
    return Container(
        child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
          Padding(
            padding: isSender
                ? const EdgeInsets.only(right: 12)
                : const EdgeInsets.only(left: 12),
            // child: CustomText(
            //   text: name,
            //   color: isSender ? Colors.black : Colors.black,
            //   // Colors.white,
            // ),
          ),
          IntrinsicWidth(
            child: Container(
                alignment: isSender
                    ? AppUtil.rtlDirection2(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft
                    : AppUtil.rtlDirection2(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: isSender
                      ? const Color(0xFFECF9F1)
                      : const Color.fromARGB(255, 255, 255, 255),

                  //Colors.green[800],
                  borderRadius: BorderRadius.only(
                      topLeft: isSender
                          ? const Radius.circular(8)
                          : const Radius.circular(0),
                      topRight: isSender
                          ? const Radius.circular(0)
                          : const Radius.circular(8),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.start, //new

                  // isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,

                  children: [
                    // Name And Image
                    // Row(
                    //   mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,//new

                    //   children: [
                    //     // CircleAvatar(
                    //     //     backgroundImage: NetworkImage(image ??
                    //     //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyvcgeumvf2F5w91arQxkFOMXAe0AzdiWMsEsO4L8obQ&s")),
                    //     //const SizedBox(width: 8),
                    //     // CustomText(
                    //     //     text: name, color: isSender ? Colors.black : Colors.white),
                    //   ],
                    // ),
                    // const SizedBox(height: 8),

                    // Message
                    CustomText(
                        text: message.message!,
                        textDirection: AppUtil.rtlDirection2(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr, //new
                        color: isSender ? Colors.black : Colors.black),
                    // Colors.white),

                    // // Date

                    // const SizedBox(height: 4),
                    // CustomText(
                    //     text: message.created!,
                    //     textDirection: AppUtil.rtlDirection2(context)? TextDirection.rtl:TextDirection.ltr,
                    //     fontSize: 10,
                    //     color: isSender ? Colors.black :Colors.black),
                    // Colors.white),
                  ],
                )),
          ),
          const SizedBox(height: 4),

          // Date
          Row(
            mainAxisAlignment: isSender
                ? MainAxisAlignment.end
                : MainAxisAlignment.start, //new
            //new Date
            children: [
              CustomText(
                  text: formatTimeWithLocale(
                      context, message.created!.substring(12)),
                  textAlign: TextAlign.center,
                  fontFamily: AppUtil.SfFontType(context),
                  // textDirection: AppUtil.rtlDirection2(context)? TextDirection.rtl:TextDirection.ltr,
                  fontSize: 10,
                  color: isSender
                      ? const Color(0xFF676767)
                      : const Color(0xFF676767)),
            ],
          ),
          const SizedBox(height: 6),
        ]));
  }
}

String formatTimeWithLocale(BuildContext context, String dateTimeString) {
  DateTime dateTime;

  try {
    // Try parsing as ISO 8601
    dateTime = DateTime.parse(dateTimeString);
  } catch (e) {
    dateTime = intl.DateFormat('hh:mm a').parse(dateTimeString);
  }

  // Format time
  String formattedTime = intl.DateFormat('jm').format(dateTime);

  if (AppUtil.rtlDirection2(context)) {
    // Arabic locale
    String suffix = dateTime.hour < 12 ? 'ص' : 'م';
    formattedTime = formattedTime
        .replaceAll('AM', '')
        .replaceAll('PM', '')
        .trim(); // Remove AM/PM
    return '$formattedTime $suffix';
  } else {
    // Default to English locale
    return formattedTime;
  }
}
