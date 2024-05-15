import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen_live.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/request/tourist/view/tourist_chat_screen.dart';

class CustomChatCard extends StatelessWidget {
  final ChatModel chatModel;

  const CustomChatCard({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: () {
        Get.to(() => 
        
        ChatScreenLive(
          offerController: Get.put(OfferController()),
            chatId: chatModel.id,
            booking: chatModel.booking!,
            requestController: Get.put(RequestController()),
            isAjwadi: chatModel.localInChat == null ? true : false)
            
            
            );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
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
                        : CircleAvatar(backgroundImage: CachedNetworkImageProvider(chatModel.localInChat!.profileInChat!.image!),radius: 30,)
                        
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
                        : chatModel.localInChat== null ?
                        
                        CircleAvatar(backgroundImage: CachedNetworkImageProvider(chatModel.touristInChat!.profileInChat!.image!),radius: 30,) :
                        CircleAvatar(backgroundImage: CachedNetworkImageProvider(chatModel.localInChat!.profileInChat!.image!),radius: 30,)
                        
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
                      ? chatModel.localInChat!.profileInChat!.name!
                      : chatModel.touristInChat!.profileInChat!.name!,
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                ),
                CustomText(
                  text:
                      '( ${AppUtil.rtlDirection(context) ? chatModel.booking!.place!.nameEn ?? "" : chatModel.booking!.place!.nameAr ?? ""} )',
                  fontSize: 10,
                ),

                //  CustomText(
                //   text:
                //     chatModel.localId,
                //   fontSize: 10,
                // )
              ],
            ),
            const Spacer(),
            CustomText(
              text: '${chatModel.created!.substring(0, 10)}',
              fontSize: 10,
              fontWeight: FontWeight.w200,
            ),

             const SizedBox(
              width: 5,
            ),

            const Icon(
          Icons.arrow_forward_ios_rounded,
          color: colorGreen,
          size: 18,
        )
          ],
        ),
      ),
    );
  }
}
