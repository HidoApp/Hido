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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' as intel;

class ChatScreen extends StatefulWidget {
   String? chatId;
  final Booking ?booking;

   ChatScreen({super.key, required this.chatId, this.booking,
});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final chatController = Get.put(ChatController());
    final getStorage = GetStorage();
   late  String userId;

    bool isDetailsTapped = false;
  late double width, height;

  bool isDetailsTapped1 = false;
bool isDetailsTapped3 = false;

  late bool isArabicSelected;
  int startIndex = -1;
  bool isSendTapped = false;

 
RxBool isDetailsTapped2 = false.obs;

  @override
  void initState() {
    log("\n \n");
   // log("Chat Screen senderId ${widget.senderId}  chatId ${widget.chatId}");
    log("\n \n");
    chatController.getChatById(id: widget.chatId!, context: context);
    String token = getStorage.read('accessToken');
    final Token jwtToken = AuthService.jwtForToken(token)!;
  userId = jwtToken.id;
  //  userId = getStorage.read('userId');

   log("Chat Screen senderIdchatId ${userId}");

    super.initState();
  }
    // String userId = getStorage.read('userId');


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
            const SizedBox(height: 12),
            // Chat List View
           Expanded(
  child: Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
   child: SingleChildScrollView(
      child: Column(
        children: [
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    isDetailsTapped1 = !isDetailsTapped1;
                  });
                },
                title: CustomText(
                  text: 'tripDetails'.tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  textAlign: AppUtil.rtlDirection2(context)
                      ? TextAlign.right
                      : TextAlign.left,
                ),
                trailing: Icon(
                  isDetailsTapped1
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: darkGrey,
                  size: 24,
                ),
              ),
            ),
            if (isDetailsTapped1)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                padding: EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/guests.svg'),
                          const SizedBox(width: 10),
                          CustomText(
                            text: '${widget.booking?.guestNumber ?? 0} ${'guests'.tr}',
                            color: almostGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/date.svg'),
                          const SizedBox(width: 10),
                          CustomText(
                            text:'${intel.DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.booking?.date ?? '2022-01-01'))} - ${widget.booking?.timeToGo}',
                            color: almostGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          CustomText(
                            text: widget.booking?.vehicleType ?? '',
                            color: almostGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 13,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    isDetailsTapped3 = !isDetailsTapped3;
                  });
                },
                title: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/ajwadi_image.png'),
                    ),
                    const SizedBox(width: 12),
                    CustomText(
                      text: AppUtil.rtlDirection2(context) ? 'محمد علي' : 'Mohamed Ali',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Kufam',
                      textAlign: AppUtil.rtlDirection2(context)
                          ? TextAlign.right
                          : TextAlign.left,
                    ),
                  ],
                ),
                trailing: Icon(
                  isDetailsTapped3
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF454545),
                  size: 24,
                ),
              ),
            ),
            if (isDetailsTapped3)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? 'يسعدني مساعدتك,  هذا هو جدول الرحلة ، تحقق من الأشياء التي تريد القيام بها'
                            : 'I\'m happy to help you, this is the flight schedule check out the things you want to do',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorDarkGrey,
                        textAlign: AppUtil.rtlDirection2(context) ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 13,
            ),
          ],
        ),
              
              
              
              
              
               StreamBuilder<ChatModel?>(
                stream: chatController.getChatByIdStream(id: widget.chatId!, context: context),
                builder: (context, snapshot) {
                  log("snapshot ${snapshot.data}");
                  return Obx(() => chatController.isGetChatByIdLoading.value
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: CircularProgressIndicator(color: Colors.green[800]),
                          ),
                        )
                      : (chatController.chat.value.messages == null ||
                              chatController.chat.value.messages == [] ||
                              chatController.chat.value.messages!.isEmpty)
                          ? Center(
                              child: CustomText(
                                text: 'StartChat'.tr,
                                fontSize: 24,
                                color: Colors.black87,
                              ),
                            )
                          : RefreshIndicator(
                              color: Colors.green,
                              onRefresh: () async {
                                await chatController.getChatById(id: widget.chatId!, context: context);
                              },
                              child: ListView.separated(
                                          shrinkWrap: true,
                                          reverse: true,
                                          controller:
                                              chatController.scrollController,
                                          // physics: const ScrollPhysics(),
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(height: 4);
                                          },
                                          itemCount: chatController
                                              .chat.value.messages!.length,
                                          itemBuilder: (context, index) {
                                            ChatMessage message = chatController
                                                .chat.value.messages![index];
                                            log(" message.senderId ${message.senderId}");
                                            log(" userId $userId");
                                            String msgSenderId =
                                                message.senderId ?? "";
                                            String senderId = userId!;
                                            bool isSender =
                                                (msgSenderId == senderId);
                                            log("isSender $isSender");
                                            message.senderName;
                                            message.senderImage;

                                            return ChatBubble(
                                              name: message.senderName ?? "",
                                              image: message.senderImage,
                                              isSender: isSender,
                                              message: ChatMessage(
                                                message: chatController
                                                    .chat
                                                    .value
                                                    .messages![index]
                                                    .message,
                                                created: intel.DateFormat(
                                                        'dd/MM/yyyy hh:mm a')
                                                    .format(
                                                  DateTime.parse(
                                                    chatController
                                                        .chat
                                                        .value
                                                        .messages![index]
                                                        .created!,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                            ));
                },
              ),
                   ],
            ),
  ),
  ),
           ),

            // Send Button
            Container(
                 width: 390,
               height: 90,
              padding: const EdgeInsets.only(
                
              top: 14,
              left: 1,
              right: 1,
              bottom: 16,
               ),
              decoration: BoxDecoration(color: Colors.white),

                child: Row(
                children: [
                  Obx(
                    () =>chatController.isPostMessageLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green[800]))
                          :Expanded(
                        child: CustomTextField(
                          controller: messageController,
                          hintText: 'HintMessage'.tr,

                          suffixIcon: !AppUtil.rtlDirection2(context)?
                           IconButton(
                            icon: Icon(
                              Icons.send ,
                              size: 24,
                              color: Colors.green[800],
                            ),
                            onPressed: () async {
                              if (messageController.text.trim() != '') {
                                bool? send =
                                    await chatController.postMessage(
                                        chatId: widget.chatId!,
                                        message: messageController.text,
                                        context: context);
                                if (send == true) {
                                  setState(() {
                                    chatController.chat.value.messages!.add(
                                        ChatMessage(
                                            // senderName: "",
                                            // senderImage: "",
                                            senderId: userId,
                                            message: messageController.text,
                                            created:
                                                DateTime.now().toString()));
                                  });
                                  messageController.clear();
                                  if (chatController.chat.value.messages !=
                                          null &&
                                      chatController
                                              .chat.value.messages!.length >
                                          2) {
                                    chatController.scrollController.jumpTo(
                                        chatController.scrollController
                                                .position.maxScrollExtent *
                                            1.4);
                                  }
                                }
                              }
                            },
                          ):null, 
                          prefixIcon: AppUtil.rtlDirection2(context)?
                            IconButton(
                            icon: Icon(
                              Icons.send ,
                              size: 24,
                              color: Colors.green[800],
                            ),
                            onPressed: () async {
                              if (messageController.text.trim() != '') {
                                bool? send =
                                    await chatController.postMessage(
                                        chatId: widget.chatId!,
                                        message: messageController.text,
                                        context: context);
                                if (send == true) {
                                  setState(() {
                                    chatController.chat.value.messages!.add(
                                        ChatMessage(
                                            // senderName: "",
                                            // senderImage: "",
                                            senderId: userId,
                                            message: messageController.text,
                                            created:
                                                DateTime.now().toString()));
                                  });
                                  messageController.clear();
                                  if (chatController.chat.value.messages !=
                                          null &&
                                      chatController
                                              .chat.value.messages!.length >
                                          2) {
                                    chatController.scrollController.jumpTo(
                                        chatController.scrollController
                                                .position.maxScrollExtent *
                                            1.4);
                                  }
                                }
                              }
                              }
                            ): null,
                          height:  MediaQuery.of(context).size.height * 0.06,
                           maxLines: 5,
                           minLines: 3,
                          onChanged: (String value) {},
                        ),
                      ),
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}
