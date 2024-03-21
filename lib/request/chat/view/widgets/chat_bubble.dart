import 'package:ajwad_v4/request/chat/model/chat_model.dart';
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
    print("name $name isSender $isSender");
    //isSender = (message.senderId == userId)
    return Container(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSender ? Colors.grey[300] : Colors.green[800],
          borderRadius: BorderRadius.only(
              topLeft: isSender
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              topRight: isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
              bottomRight: const Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            // Name And Image
            Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(image ??
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyvcgeumvf2F5w91arQxkFOMXAe0AzdiWMsEsO4L8obQ&s")),
                const SizedBox(width: 8),
                CustomText(
                    text: name, color: isSender ? Colors.black : Colors.white),
              ],
            ),
            const SizedBox(height: 8),

            // Message
            CustomText(
                text: message.message!,
                color: isSender ? Colors.black : Colors.white),
            // Date
            const SizedBox(height: 4),
            CustomText(
                text: message.created!,
                textDirection: TextDirection.ltr,
                fontSize: 10,
                color: isSender ? Colors.black : Colors.white),
          ],
        ));
  }
}
