import 'dart:developer';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/chat/controllers/chat_controller.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/chat/view/widgets/chat_bubble.dart';
import 'package:ajwad_v4/request/chat/view/widgets/vehicleInfo.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/schedule_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' as intel;
import 'package:skeletonizer/skeletonizer.dart';

import '../../../explore/tourist/controller/tourist_explore_controller.dart';
import '../../../explore/tourist/model/booking.dart' as book;
import '../../../widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  String? chatId;
  final Booking? booking;
  book.Booking? booking2;
  bool? isTourist;

  ChatScreen(
      {super.key,
      required this.chatId,
      this.booking,
      this.booking2,
      this.isTourist});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final chatController = Get.put(ChatController());
  final getStorage = GetStorage();
  late String userId;
  //  book.Booking? booking2;
  late List<book.Offer>? offers;
  bool isDetailsTapped = false;
  late double width, height;

  bool isDetailsTapped1 = false;
  bool isDetailsTapped3 = false;

  late bool isArabicSelected;
  int startIndex = -1;
  bool isSendTapped = false;
  ChatModel? chat;
  // Booking?book;

  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final _offerController = Get.put(OfferController());
  final _profileController = Get.put(ProfileController());

  RxBool isDetailsTapped2 = false.obs;

  @override
  void initState() {
    super.initState();

    log("\n \n");
    log("\n \n");
    // getChat();
    _initializeChatAndInfo();

    String token = getStorage.read('accessToken');
    final Token jwtToken = AuthService.jwtForToken(token)!;
    userId = jwtToken.id;

    log("Chat Screen senderIdchatId $userId");
  }

  void _initializeChatAndInfo() async {
    await getChat(); // Wait for the chat to be fetched
    if (widget.isTourist ?? true) {
      getCarInfo(); // Call getCarInfo after the chat is fetched
    }
  }

  Future<void> getChat() async {
    chat =
        await chatController.getChatById(id: widget.chatId!, context: context);
  }

  Future<void> getCarInfo() async {
    if (chat != null) {
      await _profileController.getProfile(
          context: context, profileId: chat!.localId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return Obx(
      () => chatController.isGetChatByIdLoading.value ||
              _profileController.isProfileLoading.value
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()))
          : Scaffold(
              backgroundColor: lightGreyBackground,
              appBar: CustomAppBar(
                "chat".tr,
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 90)),
                                    if (widget.isTourist ?? true) ...[
                                      Skeletonizer(
                                          enabled: _profileController
                                              .isProfileLoading.value,
                                          child: VehicleInfoWidget(
                                            vehicleClassDesc: _profileController
                                                .profile
                                                .vehicle!
                                                .vehicleClassDescEn,
                                            plateInfo:
                                                '${_profileController.profile.vehicle!.plateNumber} '
                                                '${_profileController.profile.vehicle!.plateText1.toUpperCase()}'
                                                '${_profileController.profile.vehicle!.plateText2.toUpperCase()}'
                                                '${_profileController.profile.vehicle!.plateText3.toLowerCase()}',
                                          )

                                          // : Container(
                                          //     width: 0.90 * width,
                                          //     //  height: 0.089 *height,

                                          //     decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius:
                                          //           BorderRadius.circular(8),
                                          //     ),
                                          //     child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: [
                                          //         ListTile(
                                          //           onTap: () async {
                                          //             if (widget.booking2 ==
                                          //                 null) {
                                          //               widget.booking2 =
                                          //                   await _touristExploreController
                                          //                       .getTouristBookingById(
                                          //                 context: context,
                                          //                 bookingId:
                                          //                     chat!.bookingId!,
                                          //               );

                                          //               if (widget.booking2 !=
                                          //                       null ||
                                          //                   widget.booking !=
                                          //                       null) {
                                          //                 print(
                                          //                     "this is widget book");
                                          //                 print(
                                          //                     chat!.bookingId!);
                                          //               }
                                          //             }
                                          //             setState(() {
                                          //               isDetailsTapped1 =
                                          //                   !isDetailsTapped1;
                                          //             });
                                          //           },
                                          //           title: CustomText(
                                          //             text: 'tripDetails'.tr,
                                          //             color: Color(0xFF070708),
                                          //             fontSize: 17,
                                          //             fontFamily: 'HT Rakik',
                                          //             fontWeight:
                                          //                 FontWeight.w500,
                                          //             height: 0.10,
                                          //             textAlign:
                                          //                 AppUtil.rtlDirection2(
                                          //                         context)
                                          //                     ? TextAlign.right
                                          //                     : TextAlign.left,
                                          //           ),
                                          //           trailing: Icon(
                                          //             isDetailsTapped
                                          //                 ? Icons
                                          //                     .keyboard_arrow_up
                                          //                 : Icons
                                          //                     .keyboard_arrow_down,
                                          //             color: darkGrey,
                                          //             size: 24,
                                          //           ),
                                          //         ),
                                          //         if (isDetailsTapped1)
                                          //           Padding(
                                          //             padding: const EdgeInsets
                                          //                 .symmetric(
                                          //                 horizontal: 20,
                                          //                 vertical: 10),
                                          //             child: Column(
                                          //               crossAxisAlignment:
                                          //                   CrossAxisAlignment
                                          //                       .start,
                                          //               children: [
                                          //                 Row(
                                          //                   children: [
                                          //                     SvgPicture.asset(
                                          //                         'assets/icons/date.svg'),
                                          //                     const SizedBox(
                                          //                       width: 10,
                                          //                     ),
                                          //                     CustomText(
                                          //                       text: widget.booking !=
                                          //                               null
                                          //                           ? AppUtil.formatBookingDate(
                                          //                               context,
                                          //                               widget
                                          //                                   .booking!
                                          //                                   .date!)
                                          //                           : AppUtil.formatBookingDate(
                                          //                               context,
                                          //                               widget
                                          //                                   .booking2!
                                          //                                   .date!),
                                          //                       color:
                                          //                           almostGrey,
                                          //                       fontSize: 13,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w400,
                                          //                       fontFamily: AppUtil
                                          //                           .SfFontType(
                                          //                               context),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //                 const SizedBox(
                                          //                   height: 10,
                                          //                 ),
                                          //                 Row(
                                          //                   children: [
                                          //                     SvgPicture.asset(
                                          //                         'assets/icons/time3.svg'),
                                          //                     const SizedBox(
                                          //                       width: 9,
                                          //                     ),
                                          //                     CustomText(
                                          //                       text: widget.booking !=
                                          //                               null
                                          //                           ? AppUtil.rtlDirection2(
                                          //                                   context)
                                          //                               ? 'من ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)} إلى ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)} '
                                          //                               : 'Pick up: ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)}, Drop off: ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)}'
                                          //                           : AppUtil.rtlDirection2(
                                          //                                   context)
                                          //                               ? 'من ${AppUtil.formatStringTimeWithLocale(context, widget.booking2!.timeToGo)} إلى ${AppUtil.formatStringTimeWithLocale(context, widget.booking2!.timeToReturn!)} '
                                          //                               : 'Pick up: ${AppUtil.formatStringTimeWithLocale(context, widget.booking2!.timeToGo)}, Drop off: ${AppUtil.formatStringTimeWithLocale(context, widget.booking2!.timeToReturn)}',
                                          //                       color:
                                          //                           almostGrey,
                                          //                       fontSize: 13,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w400,
                                          //                       fontFamily: AppUtil
                                          //                           .SfFontType(
                                          //                               context),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //                 const SizedBox(
                                          //                   height: 10,
                                          //                 ),
                                          //                 Row(
                                          //                   children: [
                                          //                     SvgPicture.asset(
                                          //                         'assets/icons/guests.svg'),
                                          //                     const SizedBox(
                                          //                       width: 10,
                                          //                     ),
                                          //                     CustomText(
                                          //                       text: widget.booking !=
                                          //                               null
                                          //                           ? '${widget.booking?.guestNumber ?? 0} ${'guests'.tr}'
                                          //                           : '${widget.booking2?.guestNumber ?? 0} ${'guests'.tr}',
                                          //                       color:
                                          //                           almostGrey,
                                          //                       fontSize: 13,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w400,
                                          //                       fontFamily: AppUtil
                                          //                           .SfFontType(
                                          //                               context),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //                 const SizedBox(
                                          //                   height: 10,
                                          //                 ),
                                          //                 Row(
                                          //                   children: [
                                          //                     widget.booking !=
                                          //                             null
                                          //                         ? SvgPicture
                                          //                             .asset(
                                          //                             'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
                                          //                             width: 20,
                                          //                           )
                                          //                         : SvgPicture
                                          //                             .asset(
                                          //                             'assets/icons/unselected_${widget.booking2?.vehicleType!}_icon.svg',
                                          //                             width: 20,
                                          //                           ),
                                          //                     const SizedBox(
                                          //                       width: 10,
                                          //                     ),
                                          //                     CustomText(
                                          //                       text: widget.booking !=
                                          //                               null
                                          //                           ? widget.booking
                                          //                                   ?.vehicleType ??
                                          //                               ''
                                          //                           : widget.booking2
                                          //                                   ?.vehicleType ??
                                          //                               '',
                                          //                       color:
                                          //                           almostGrey,
                                          //                       fontSize: 13,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w400,
                                          //                       fontFamily: AppUtil
                                          //                           .SfFontType(
                                          //                               context),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //       ],
                                          //     ),
                                          //   ),

                                          ),
                                    ],
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Center(
                                      child: chat!.bookingId == ''
                                          ? Container()
                                          : Container(
                                              width: double.infinity,
                                              // width: 0.90 * width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    onTap: () async {
                                                      widget.booking2 =
                                                          await _touristExploreController
                                                              .getTouristBookingById(
                                                        context: context,
                                                        bookingId:
                                                            chat!.bookingId!,
                                                      );
                                                      if (widget.booking2 !=
                                                              null ||
                                                          widget.booking !=
                                                              null) {
                                                        if (widget.booking2
                                                                ?.offers !=
                                                            []) {
                                                          offers = widget
                                                              .booking2
                                                              ?.offers!;
                                                          //  await _offerController.getOfferById(context: context, offerId:booking2?.offers!.last.id??'');
                                                        }
                                                        setState(() {
                                                          isDetailsTapped3 =
                                                              !isDetailsTapped3;
                                                          print(
                                                              'state of secdle');
                                                          print(offers
                                                              ?.last
                                                              .schedule
                                                              ?.length);
                                                        });
                                                      }
                                                    },
                                                    title: Row(
                                                      children: [
                                                        // const CircleAvatar(
                                                        //   backgroundImage: AssetImage('assets/images/ajwadi_image.png'),
                                                        // ),
                                                        // const SizedBox(width: 12),
                                                        CustomText(
                                                          text:
                                                              'ItineraryDetails'
                                                                  .tr,
                                                          color: const Color(
                                                              0xFF070708),
                                                          fontSize: 17,
                                                          fontFamily:
                                                              'HT Rakik',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0.10,
                                                          textAlign: AppUtil
                                                                  .rtlDirection2(
                                                                      context)
                                                              ? TextAlign.right
                                                              : TextAlign.left,
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Icon(
                                                      isDetailsTapped3
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color: const Color(
                                                          0xFF454545),
                                                      size: 24,
                                                    ),
                                                  ),
                                                  if (isDetailsTapped3)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 7,
                                                          vertical: 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ScheduleContainerWidget(
                                                              scheduleList:
                                                                  offers?.last
                                                                      .schedule),
                                                          // CustomText(
                                                          //   text: !AppUtil.rtlDirection2(context)
                                                          //       ?  ScheduleContainerWidget(
                                                          //       offerController: _offerController),
                                                          //       : 'I\'m happy to help you, this is the flight schedule check out the things you want to do',

                                                          //      // _offerController.offerDetails.value.schedule?.last.scheduleName??'bn'
                                                          //       //'يسعدني مساعدتك,  هذا هو جدول الرحلة ، تحقق من الأشياء التي تريد القيام بها'
                                                          //       // : 'I\'m happy to help you, this is the flight schedule check out the things you want to do',
                                                          //   fontSize: 12,
                                                          //   fontWeight: FontWeight.w400,
                                                          //   color: colorDarkGrey,
                                                          //   textAlign: AppUtil.rtlDirection2(context) ? TextAlign.right : TextAlign.left,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height:
                                          chatController.chat.messages!.isEmpty
                                              ? 40
                                              : 13,
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder<ChatModel?>(
                                stream: chatController.getChatByIdStream(
                                    id: widget.chatId!, context: context),
                                builder: (context, snapshot) {
                                  log("snapshot ${snapshot.data}");
                                  return Obx(() => chatController
                                          .isGetChatByIdLoading.value
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 14),
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          ),
                                        )
                                      : (chatController.chat.messages == null ||
                                              chatController.chat.messages ==
                                                  [] ||
                                              chatController
                                                  .chat.messages!.isEmpty)
                                          ? Center(
                                              child: CustomText(
                                                text: 'StartChat'.tr,
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    AppUtil.SfFontType(context),
                                                color: Graytext,
                                              ),
                                            )
                                          : RefreshIndicator(
                                              color: Colors.green,
                                              onRefresh: () async {
                                                await chatController
                                                    .getChatById(
                                                        id: widget.chatId!,
                                                        context: context);
                                              },
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                reverse: true,
                                                controller: chatController
                                                    .scrollController,
                                                // physics: const ScrollPhysics(),
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 4);
                                                },
                                                itemCount: chatController
                                                    .chat.messages!.length,
                                                itemBuilder: (context, index) {
                                                  ChatMessage message =
                                                      chatController.chat
                                                          .messages![index];
                                                  log(" message.senderId ${message.senderId}");
                                                  log(" userId $userId");
                                                  String msgSenderId =
                                                      message.senderId ?? "";
                                                  String senderId = userId;
                                                  bool isSender =
                                                      (msgSenderId == senderId);
                                                  log("isSender $isSender");
                                                  // message.senderName;
                                                  // message.senderImage;

                                                  print(
                                                    intel.DateFormat(
                                                            'dd/MM/yyyy hh:mm a')
                                                        .format(
                                                      DateTime.parse(
                                                        chatController
                                                            .chat
                                                            .messages!
                                                            .last
                                                            .created!,
                                                      ),
                                                    ),
                                                  );
                                                  return ChatBubble(
                                                    // name: message.senderName ??
                                                    //     "",
                                                    // image: message.senderImage,
                                                    isSender: isSender,
                                                    message: ChatMessage(
                                                      message: chatController
                                                          .chat
                                                          .messages![index]
                                                          .message,
                                                      created: intel.DateFormat(
                                                              'dd/MM/yyyy hh:mm a')
                                                          .format(
                                                        DateTime.parse(
                                                          chatController
                                                              .chat
                                                              .messages![index]
                                                              .created!,
                                                        ).add(const Duration(
                                                            hours: 3)),
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

                    const SizedBox(height: 4)
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 14,
                        left: 16,
                        right: 16,
                        bottom: 30,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        textDirection: AppUtil.rtlDirection2(context)
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          Obx(
                            () => chatController.isPostMessageLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive())
                                : Expanded(
                                    child: CustomTextField(
                                      controller: messageController,
                                      hintText: 'HintMessage'.tr,

                                      suffixIcon: IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/ChatSend.svg',
                                        ),
                                        // Icon(
                                        //   Icons.send ,
                                        //   size: 24,
                                        //   color: Colors.green[800],
                                        // ),
                                        onPressed: () async {
                                          if (messageController.text.trim() !=
                                              '') {
                                            bool? send = await chatController
                                                .postMessage(
                                                    chatId: widget.chatId!,
                                                    message:
                                                        messageController.text,
                                                    context: context);

                                            if (send == true) {
                                              setState(() {
                                                chatController.chat.messages!
                                                    .add(ChatMessage(
                                                        // senderName: "",
                                                        // senderImage: "",
                                                        senderId: userId,
                                                        message:
                                                            messageController
                                                                .text,
                                                        created: DateTime.now()
                                                            .subtract(
                                                                const Duration(
                                                                    hours: 3))
                                                            .toString()));
                                              });
                                              messageController.clear();
                                              if (chatController
                                                          .chat.messages !=
                                                      null &&
                                                  chatController.chat.messages!
                                                          .length >
                                                      2) {
                                                chatController.scrollController
                                                    .jumpTo(chatController
                                                            .scrollController
                                                            .position
                                                            .maxScrollExtent *
                                                        1.4);
                                              }
                                            }
                                          }
                                        },
                                      ),
                                      // prefixIcon: AppUtil.rtlDirection2(context)?
                                      //   IconButton(
                                      //   icon: Icon(
                                      //     Icons.send ,
                                      //     size: 24,
                                      //     color: Colors.green[800],
                                      //   ),
                                      //   onPressed: () async {
                                      //     if (messageController.text.trim() != '') {
                                      //       bool? send =
                                      //           await chatController.postMessage(
                                      //               chatId: widget.chatId!,
                                      //               message: messageController.text,
                                      //               context: context);
                                      //       if (send == true) {
                                      //         setState(() {
                                      //           chatController.chat.messages!.add(
                                      //               ChatMessage(
                                      //                   // senderName: "",
                                      //                   // senderImage: "",
                                      //                   senderId: userId,
                                      //                   message: messageController.text,
                                      //                   created:
                                      //                       DateTime.now().toString()));
                                      //         });
                                      //         messageController.clear();
                                      //         if (chatController.chat.messages !=
                                      //                 null &&
                                      //             chatController
                                      //                     .chat.messages!.length >
                                      //                 2) {
                                      //           chatController.scrollController.jumpTo(
                                      //               chatController.scrollController
                                      //                       .position.maxScrollExtent *
                                      //                   1.4);
                                      //         }
                                      //       }
                                      //     }
                                      //     }
                                      //   ): null,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      maxLines: 100,
                                      minLines: 2,
                                      onChanged: (String value) {},
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
