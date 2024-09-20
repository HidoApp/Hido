import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatBubble extends StatelessWidget {
  final String name;
  final String? image;
  final ChatMessage message;
  final bool isSender;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isSender,
      required this.name,
      required this.image});

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
                ? EdgeInsets.only(right: 12)
                : EdgeInsets.only(left: 12),
            child: CustomText(
              text: name,
              color: isSender ? Colors.black : Colors.black,
              // Colors.white,
            ),
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
                      ? Color(0xFFECF9F1)
                      : Color.fromARGB(255, 255, 255, 255),

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
            mainAxisAlignment: MainAxisAlignment.center, //new
//new Date
            children: [
              Expanded(
                child: CustomText(
                    text: message.created!,
                    textAlign: TextAlign.center,
                    fontFamily: AppUtil.SfFontType(context),
                    // textDirection: AppUtil.rtlDirection2(context)? TextDirection.rtl:TextDirection.ltr,
                    fontSize: 10,
                    color: isSender ? Color(0xFF676767) : Color(0xFF676767)),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ]));
  }
}
