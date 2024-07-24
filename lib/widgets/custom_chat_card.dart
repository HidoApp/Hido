import 'dart:math';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/controllers/chat_controller.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen_live.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/request/tourist/view/tourist_chat_screen.dart';
import 'package:intl/intl.dart';

import '../request/chat/view/chat_screen.dart';

class CustomChatCard extends StatelessWidget {
  final ChatModel chatModel;
  final Booking? booking2;
  String? chatId2;

  CustomChatCard(
      {super.key, required this.chatModel, this.booking2, this.chatId2});
  final chatController = Get.put(ChatController());
 final offerController=Get.put(OfferController());
 
  @override
  Widget build(BuildContext context) {
                   

print(";lkjhgfd");
    return InkWell(
      onTap: () async {

        Get.to(() =>

            // ChatScreenLive(
            //   offerController: Get.put(OfferController()),
            //     chatId: chatModel.id,
            //     booking: chatModel.booking!,
            //     requestController: Get.put(RequestController()),
            //     isAjwadi: chatModel.localInChat == null ? true : false)

            ChatScreen(
                chatId: chatModel.id,
                booking:
                    Get.put(OfferController()).offerDetails.value.booking ??
                        null));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: chatModel.localInChat != null
                        ? chatModel.localInChat!.profileInChat!.image == null
                            ? Image.asset(
                                "assets/images/profile_image.png",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    chatModel.localInChat!.profileInChat!
                                            .image ??
                                        ''),
                                radius: 30,
                              )

                        // Image.network(
                        //     chatModel.localInChat!.profileInChat!.image!,
                        //     height: 45,
                        //     width: 45,
                        //   )
                        : chatModel.touristInChat!.profileInChat!.image == null
                            ? Image.asset(
                                "assets/images/profile_image.png",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              )
                            : chatModel.localInChat == null
                                ? CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        chatModel.touristInChat!.profileInChat!
                                                .image ??
                                            ''),
                                    radius: 25,
                                  )
                                : CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        chatModel.localInChat!.profileInChat!
                                                .image ??
                                            ''),
                                    radius: 25,
                                  )

                    // Image.network(
                    //     chatModel.localInChat!.profileInChat!.image!,
                    //     height: 45,
                    //     width: 45,
                    //   )

                    ),

                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: chatModel.localInChat != null
                          ? chatModel.localInChat!.profileInChat!.name ?? ''
                          : chatModel.touristInChat!.profileInChat!.name ?? '',
                      color: Color(0xFF070708),
                      fontSize: 16,
                      fontFamily:   AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                      fontWeight: FontWeight.w500,
                      height: chatModel.messages!.isNotEmpty ? 0 : 3,
                    ),
                    // CustomText(
                    //   text:
                    //       '( ${AppUtil.rtlDirection(context) ? chatModel.booking!.place!.nameEn ?? "" : chatModel.booking!.place!.nameAr ?? ""} )',
                    //   fontSize: 10,
                    // ),

                    if (chatModel.messages!.isNotEmpty) ...[
                      SizedBox(
                        height: 6,
                      ),
                      CustomText(
                        text: chatModel.messages!.last.message,
                        color: Color(0xFF9392A0),
                        fontSize: 13,
                        fontFamily:   AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      )
                    ],
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    CustomText(
                        // text: '${chatModel.created!.substring(0, 10)}',
                        text: chatModel.messages!.isNotEmpty
                            //  ? DateFormat('jm').format(DateTime.parse(chatModel.messages!.last.created!))
                            //  'HH:mm'
                            // ?AppUtil.formatTimeWithLocale(context, chatModel.messages!.last.created!,'jm')
                            ? formatTimeWithLocale(
                                context, chatModel.messages!.last.created!)
                            : '',
                        color: Color(0xFF37B268),
                        fontSize: 13,
                        fontFamily:   AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0),
                    SizedBox(
                      height: chatModel.messages!.isNotEmpty ? 5 : 0,
                    ),
                    // Container(
                    //   width: 19,
                    //   height: 19,
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //     chatModel.messages!.length.toString(),
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 13,
                    //       fontFamily: 'SF Pro',
                    //       fontWeight: FontWeight.w500,
                    //       height: 1.0,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                //   Padding(padding:chatModel.messages!.isNotEmpty?EdgeInsets.only(top:0) :EdgeInsets.only(top:14),
                //   child:Icon(
                //   Icons.arrow_forward_ios_rounded,
                //   color: colorGreen,
                //   size: 18,
                // ),
                //    ),
              ],
            ),
            //   if(chatModel.messages!.isNotEmpty)...[
            //  SizedBox(
            //        height: 25,
            //       ),
            //          Container(
            //   width: 358,
            //   decoration: ShapeDecoration(
            //   shape: RoundedRectangleBorder(
            //  side: BorderSide(
            //  width: 1,
            //   strokeAlign: BorderSide.strokeAlignCenter,
            //  color: Color(0xFFDCDCE0),
            // ),
            //    ),
            //   ),
            //  )
            //   ]
          ],
        ),
      ),
    );
  }

  // Function to format time with locale-specific suffix
  String formatTimeWithLocale(BuildContext context, String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).add(Duration(hours: 3));
    String formattedTime = DateFormat('jm').format(dateTime);

    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = dateTime.hour < 12 ? 'صباحًا' : 'مساءً';
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
}
