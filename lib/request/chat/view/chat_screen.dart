import 'dart:developer';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/chat/controllers/chat_controller.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/chat/view/widgets/chat_bubble.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String chatId;
  const ChatScreen({super.key, required this.senderId, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final chatController = Get.put(ChatController());

  @override
  void initState() {
    log("\n \n");
    log("Chat Screen senderId ${widget.senderId}  chatId ${widget.chatId}");
    log("\n \n");
    chatController.getChatById(id: widget.chatId, context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Row(
              children: [
                if (AppUtil.rtlDirection(context))
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: black,
                      size: 26,
                    ),
                  ),
                if (AppUtil.rtlDirection(context))
                  const SizedBox(
                    width: 4,
                  ),
                CustomText(
                  text: 'chat'.tr,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                if (!AppUtil.rtlDirection(context))
                  const SizedBox(
                    width: 4,
                  ),
                if (!AppUtil.rtlDirection(context))
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: black,
                      size: 26,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Chat List View
            Expanded(
              child: Obx(
                () => chatController.isGetChatByIdLoading.value
                    ? Center(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: CircularProgressIndicator(
                                color: Colors.green[800])),
                      )
                    : (chatController.chat.value.messages == null ||
                            chatController.chat.value.messages == [] ||
                            chatController.chat.value.messages!.isEmpty)
                        ? Center(
                            child: CustomText(
                                text: 'StartChat'.tr,
                                fontSize: 24,
                                color: Colors.black87),
                          )
                        : RefreshIndicator(
                            color: Colors.green,
                            onRefresh: () async {
                              await chatController.getChatById(
                                  id: widget.chatId, context: context);
                            },
                            child: ListView.separated(
                              shrinkWrap: true,
                              controller: scrollController,
                              // physics: const ScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 4,
                                );
                              },
                              itemCount:
                                  chatController.chat.value.messages!.length,
                              itemBuilder: (context, index) {
                                final getStorage = GetStorage();
                                String token = getStorage.read('accessToken');

                                final Token jwtToken =
                                    AuthService.jwtForToken(token)!;

                                token = jwtToken.id;
                                String userRole = jwtToken.userRole;
                                log(userRole);
                                // var local = chatController
                                //     .chat.value.local!.profile!.name!;

                              var local = chatController.chat.value.localInChat!.profileInChat!.name!;

                                // var tourist = chatController
                                //     .chat.value.tourist!.profile!.name!;
                                    var tourist = chatController.chat.value.touristInChat!.profileInChat!.name!;
                                    
                                log("local $local  tourist $tourist");

                                return ChatBubble(
                                  name:
                                      //local
                                      (userRole == 'local' &&
                                              chatController
                                                      .chat
                                                      .value
                                                      .messages![index]
                                                      .senderId ==
                                                  widget.senderId)
                                          ? chatController
                                              .chat.value.localInChat!.profileInChat!.name!
                                              //.local!.profile!.name!
                                          :
                                          //tourist
                                          (userRole == 'tourist' &&
                                                  chatController
                                                          .chat
                                                          .value
                                                          .messages![index]
                                                          .senderId ==
                                                      widget.senderId)
                                              ? chatController.chat.value.touristInChat!.profileInChat!.name!
                                                  //.tourist!.profile!.name!
                                              : userRole == 'local'
                                                  ? chatController.chat.value.localInChat!.profileInChat!.name!
                                                      //.local!.profile!.name!
                                                  : userRole == 'tourist'
                                                      ? chatController
                                                          .chat
                                                          .value
                                                          .touristInChat!.profileInChat!.name!
                                                          // .tourist!
                                                          // .profile!
                                                          // .name!
                                                      : "chatController",
                                  image: userRole == 'local'
                                      ? chatController
                                          .chat.value.localInChat!.profileInChat?.image
                                          //local?.profile?.image
                                      : chatController
                                          .chat.value.touristInChat!.profileInChat?.image,
                                          //tourist?.profile?.image,
                                  isSender: chatController.chat.value
                                          .messages![index].senderId ==
                                      widget.senderId,
                                  message: ChatMessage(
                                      message: chatController
                                          .chat.value.messages![index].message,
                                      created: chatController
                                          .chat.value.messages![index].created),
                                );
                              },
                            ),
                          ),
              ),
            ),

            // Send Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Obx(
                    () => chatController.isPostMessageLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Colors.green[800]))
                        : Directionality(
                            textDirection: TextDirection.ltr,
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                size: 30,
                                color: Colors.green[800],
                              ),
                              onPressed: () async {
                                if (messageController.text.trim() != '') {
                                  bool? send = await chatController.postMessage(
                                      chatId: widget.chatId,
                                      message: messageController.text,
                                      context: context);
                                  if (send == true) {
                                    setState(() {
                                      chatController.chat.value.messages!.add(
                                          ChatMessage(
                                              senderId: widget.senderId,
                                              message: messageController.text,
                                              created: 'now'));
                                    });
                                    messageController.clear();
                                    scrollController.jumpTo(scrollController
                                            .position.maxScrollExtent *
                                        1.4);
                                  }
                                }
                              },
                            ),
                          ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: messageController,
                      hintText: 'message'.tr,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: (String value) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}
