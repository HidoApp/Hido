import 'dart:developer';
import 'dart:ffi';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/view/check_out_screen.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/controllers/chat_controller.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/chat/view/widgets/chat_bubble.dart';
import 'package:ajwad_v4/request/chat/view/widgets/show_request_widget.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/services/view/paymentType.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/available_container_widget.dart';
import 'package:ajwad_v4/widgets/check_container_widget.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:ajwad_v4/widgets/total_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ajwad_v4/request/widgets/CansleDialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ajwad_v4/request/local_notification.dart';

import 'package:intl/intl.dart' as intel;

import '../../../services/view/review_request_screen.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../tourist/view/find_ajwady.dart';

class ChatScreenLive extends StatefulWidget {
  // final String senderId;

  String? chatId;
  final RequestController? requestController;
  final OfferController? offerController;
  final bool isAjwadi;
  final Booking? booking;
  final Place? place;
  ChatScreenLive({
    super.key,
    required this.chatId,
    this.booking,
    required this.isAjwadi,
    this.requestController,
    this.offerController,
    this.place,
  });

  @override
  State<ChatScreenLive> createState() => _ChatScreenLiveState();
}

class _ChatScreenLiveState extends State<ChatScreenLive> {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final TextEditingController messageController = TextEditingController();
  final chatController = Get.put(ChatController());

  final getStorage = GetStorage();
  String? userId;
  bool isDetailsTapped = false;
  late double width, height;
  int startIndex = -1;
  bool isSendTapped = false;

  RxBool isDetailsTapped2 = false.obs;
  bool isDetailsTapped3 = false;

  //PaymentController paymentController = Get.put(PaymentController());
  Invoice? invoice;
  bool isCheckingForPayment = false;

  static Future init() async {
    InitializationSettings settings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(settings);
  }

  @override
  void initState() {
    log("\n \n");
    log("Chat Screen   chatId ${widget.chatId}");
    log("\n \n");
    if (widget.chatId != null) {
      chatController.getChatById(id: widget.chatId!, context: context);
    }
    String token = getStorage.read('accessToken');
    final Token jwtToken = AuthService.jwtForToken(token)!;
    userId = jwtToken.id;
    log(userId ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: lightGreyBackground,
      appBar: CustomAppBar('showOffer'.tr),
      body: SafeArea(
        child: Obx(
          () => widget.offerController!.isOfferLoading.value
              ? CircularProgressIndicator.adaptive()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10),

                    // InkWell(
                    //   onTap: () async {
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return CancelBookingDialog(
                    //           dialogWidth:
                    //               MediaQuery.of(context).size.width * 0.588,
                    //           buttonWidth:
                    //               MediaQuery.of(context).size.width * 1.191,
                    //           // booking: widget.booking,
                    //           offerController: _offerController,
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: SvgPicture.asset(
                    //     'assets/icons/more.svg',
                    //      color: black,

                    //   ),
                    // ),

                    //                if (AppUtil.rtlDirection(context) && (!widget.isAjwadi))
                    // const SizedBox(
                    //   width: 4,
                    // ),
                    // if (!(!AppUtil.rtlDirection2(context)))
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 90),
                    //     child: IconButton(
                    //       onPressed: () {
                    //         Get.back();
                    //       },
                    //       icon: const Icon(
                    //         Icons.keyboard_arrow_left,
                    //         color: yellow,
                    //         size: 26,
                    //                       ),
                    //                     ),
                    //   ),

                    Padding(padding: const EdgeInsets.only(left: 90)),
                    Center(
                      child: Container(
                        width: 0.90 * width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () {
                                setState(() {
                                  isDetailsTapped = !isDetailsTapped;
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
                                isDetailsTapped
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: darkGrey,
                                size: 24,
                              ),
                            ),
                            if (isDetailsTapped)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/date.svg'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          text:
                                              '${DateFormat('EEE, dd MMMM yyyy').format(DateTime.parse(widget.booking!.date!))}',
                                          color: almostGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SF Pro',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/time3.svg'),
                                        const SizedBox(
                                          width: 9,
                                        ),
                                        CustomText(
                                          text: AppUtil.rtlDirection2(context)
                                              ? ' ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToGo}'))} إلى ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToReturn}'))} '
                                              : 'Pick up: ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToGo}'))}, Drop off: ${DateFormat.jm().format(DateTime.parse('1970-01-01T${widget.booking?.timeToReturn}'))}',
                                          color: almostGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SF Pro',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/guests.svg'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          text:
                                              '${widget.booking?.guestNumber} ${'guests'.tr}',
                                          color: almostGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SF Pro',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
                                          width: 20,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          text: widget.booking!.vehicleType!,
                                          color: almostGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SF Pro',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    // ?  ============== Request Case =================
                    if ((widget.isAjwadi)) ...[
                      Obx(() => isDetailsTapped2.value
                          ? widget.chatId == null
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    child: ShowRequestWidget(
                                      requestController:
                                          widget.requestController!,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: ShowRequestWidget(
                                    requestController:
                                        widget.requestController!,
                                  ),
                                )
                          : const SizedBox()),
                    ],
                    // ?  ============== Offers Case =================
                    if (widget.chatId == null && (!widget.isAjwadi)) ...[
                      Expanded(
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Column(
                              children: [
                                CheckContainerWidget(
                                    offerController: widget.offerController),

                                SizedBox(height: 10),
                                SizedBox(
                                  width: 358,
                                  child: Text(
                                    'notePrice'.tr,
                                    style: TextStyle(
                                      color: Color(0xFF9392A0),
                                      fontSize: 12,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...List.generate(
                                          10,
                                          (index) => Container(
                                                width: 20,
                                                decoration:
                                                    const ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 0.24,
                                                      strokeAlign: BorderSide
                                                          .strokeAlignCenter,
                                                      color: Color(0xFF979797),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                    ],
                                  ),
                                ),

                                // SizedBox(height: 100),

                                //  const AvailableContainerWidget(),
                                TotalWidget(
                                  offerController: widget.offerController,
                                  place: widget.place!,
                                ),
                                CustomButton(
                                  onPressed: () {
                                    //  Get.to(() =>PaymentTypeScreen(
                                    //           booking: widget.booking,
                                    //           offerController: widget.offerController,
                                    //           place: widget.place!,
                                    //         ));

                                    Get.to(() => ReviewRequest(
                                          booking: widget.booking,
                                          scheduleList: widget.offerController
                                              ?.offerDetails.value.schedule,
                                          offerController:
                                              widget.offerController,
                                          place: widget.place!,
                                        ));
                                  },
                                  title: 'confirm'.tr,
                                ),
                                SizedBox(height: 10),

                                CustomButton(
                                    onPressed: () {
                                      Get.until((route) =>
                                          Get.currentRoute == '/FindAjwady');
                                    },
                                    title: AppUtil.rtlDirection2(context)
                                        ? 'عودة للعروض'
                                        : 'Return to Offers'.tr,
                                    buttonColor: Colors.white.withOpacity(0.3),
                                    textColor: Color(0xFF070708)),

                                // paymentController.isPaymenInvoiceLoading.value
                                //     ? CircularProgressIndicator(
                                //         color: colorGreen,
                                //       )
                                //     : CustomButton(

                                //       title: 'confirm'.tr,

                                //       icon: Icon(Icons.keyboard_arrow_right,color: Colors.white),
                                //         onPressed: () async {
                                //           invoice ??=
                                //               await paymentController.paymentInvoice(
                                //                   context: context,
                                //                   description: 'Book place',
                                //                     amount: (widget.offerController!
                                //                               .totalPrice.value *
                                //                           widget
                                //                               .offerController!
                                //                               .offerDetails
                                //                               .value
                                //                               .booking!
                                //                               .guestNumber!));

                                //                   // amount: (widget.place!.price! *
                                //                   //         widget
                                //                   //             .offerController!
                                //                   //             .offerDetails
                                //                   //             .value
                                //                   //             .booking!
                                //                   //             .guestNumber!) +
                                //                   //     (widget.offerController!
                                //                   //             .totalPrice.value *
                                //                   //         widget
                                //                   //             .offerController!
                                //                   //             .offerDetails
                                //                   //             .value
                                //                   //             .booking!
                                //                   //             .guestNumber!));

                                //           Get.to(() => PaymentWebView(
                                //               url: invoice!.url!,
                                //               title: AppUtil.rtlDirection2(context)?'الدفع':'Checkout'))?.then((value) async {

                                //              setState(() {
                                //                         isCheckingForPayment = true;
                                //                       });

                                //                               final checkInvoice =
                                //                           await paymentController
                                //                               .paymentInvoiceById(
                                //                                   context: context,
                                //                                   id: invoice!.id);

                                //                                   print("checkInvoice!.invoiceStatus");
                                //                                   print(checkInvoice!.invoiceStatus);

                                //                                                if (checkInvoice
                                //                               .invoiceStatus !=
                                //                           'faild') {

                                //                         setState(() {
                                //                           isCheckingForPayment =
                                //                               false;
                                //                         });

                                //                         if (checkInvoice
                                //                                     .invoiceStatus ==
                                //                                 'failed' ||
                                //                             checkInvoice
                                //                                     .invoiceStatus ==
                                //                                 'initiated') {
                                //                           //  Get.back();

                                //                           showDialog(
                                //                               context: context,
                                //                               builder: (ctx) {
                                //                                 return AlertDialog(
                                //                                   backgroundColor:
                                //                                       Colors.white,
                                //                                   content: Column(
                                //                                     mainAxisSize:
                                //                                         MainAxisSize
                                //                                             .min,
                                //                                     children: [
                                //                                       Image.asset(
                                //                                           'assets/images/paymentFaild.gif'),
                                //                                       CustomText(
                                //                                           text:
                                //                                               "paymentFaild"
                                //                                                   .tr),
                                //                                     ],
                                //                                   ),
                                //                                 );
                                //                               });
                                //                         } else {
                                //                           print('YES');
                                //                           // Get.back();
                                //                           // Get.back();

                                //                               final acceptedOffer = await widget
                                //               .offerController!
                                //               .acceptOffer(
                                //             context: context,
                                //             offerId: widget.offerController!.offerDetails.value.id!,
                                //             invoiceId: checkInvoice.id,
                                //             schedules: widget.offerController!
                                //                 .offerDetails.value.schedule!,
                                //           );
                                //      //     Get.back();
                                //       //    Get.back();

                                //                           showDialog(
                                //                               context: context,
                                //                               builder: (ctx) {
                                //                                 return AlertDialog(
                                //                                   backgroundColor:
                                //                                       Colors.white,
                                //                                   content: Column(
                                //                                     mainAxisSize:
                                //                                         MainAxisSize
                                //                                             .min,
                                //                                     children: [
                                //                                       Image.asset(
                                //                                           'assets/images/paymentSuccess.gif'),
                                //                                       CustomText(
                                //                                           text:
                                //                                               "paymentSuccess"
                                //                                                   .tr),
                                //                                     ],
                                //                                   ),
                                //                                 );
                                //                               });
                                //                       LocalNotification().showNotification(context,widget.booking?.id, widget.booking?.timeToGo, widget.booking?.date ,widget.offerController?.offerDetails.value.name ?? "", widget.booking?.place?.nameAr,widget.booking?.place?.nameEn);

                                //                         }
                                //                       }
                                //           });
                                //           // Get.to(
                                //           //   () => CheckOutScreen(
                                //           //     total: (widget.place!.price! *
                                //           //             widget
                                //           //                 .offerController!
                                //           //                 .offerDetails
                                //           //                 .value
                                //           //                 .booking!
                                //           //                 .guestNumber!) +
                                //           //         (widget.offerController!.totalPrice
                                //           //                 .value *
                                //           //             widget
                                //           //                 .offerController!
                                //           //                 .offerDetails
                                //           //                 .value
                                //           //                 .booking!
                                //           //                 .guestNumber!),
                                //           //     offerDetails: widget.offerController!
                                //           //         .offerDetails.value,
                                //           //     offerController: widget.offerController,
                                //           //   ),
                                //           // )?.then((value) async {
                                //           //   final offer = await widget
                                //           //       .offerController!
                                //           //       .getOfferById(
                                //           //           context: context,
                                //           //           offerId: widget.offerController!
                                //           //               .offerDetails.value.id!);

                                //           //   widget.chatId = widget.offerController!
                                //           //       .offerDetails.value.booking!.chatId;

                                //           //   //  Get.back();
                                //           // });

                                //           // LocalNotification().showNotification(context,widget.booking?.id, widget.booking?.timeToGo, widget.booking?.date ,widget.offerController?.offerDetails.value.name ?? "", widget.booking?.place?.nameAr,widget.booking?.place?.nameEn);
                                //         },
                                //       )
                              ],
                            )

                            // ShowOfferWidget(
                            //   offerController: widget.offerController!,
                            //   place: widget.place!,
                            // ),
                            ),
                      ),
                    ],

                    // if (widget.chatId != null) ...[
                    //   //? ==========  Chat List View  ==========
                    //   Expanded(
                    //     child: StreamBuilder<ChatModel?>(
                    //         stream: chatController.getChatByIdStream(
                    //             id: widget.chatId!, context: context),
                    //         builder: ((context, snapshot) {
                    //           log("snapshot ${snapshot.data}");

                    //           return
                    //               // Obx(
                    //               //   () =>
                    //               chatController.isGetChatByIdLoading.value
                    //                   ? Center(
                    //                       child: Padding(
                    //                           padding:
                    //                               const EdgeInsets.only(right: 14),
                    //                           child: CircularProgressIndicator(
                    //                               color: Colors.green[800])),
                    //                     )
                    //                   : (chatController.chat.value.messages == null ||
                    //                           chatController.chat.value.messages ==
                    //                               [] ||
                    //                           chatController
                    //                               .chat.value.messages!.isEmpty)
                    //                       ? Center(
                    //                           child: CustomText(
                    //                               text: 'StartChat'.tr,
                    //                               fontSize: 24,
                    //                               color: Colors.black87),
                    //                         )
                    //                       : RefreshIndicator(
                    //                           color: Colors.green,
                    //                           onRefresh: () async {
                    //                             await chatController.getChatById(
                    //                                 id: widget.chatId!,
                    //                                 context: context);
                    //                           },
                    //                           child: ListView.separated(
                    //                             shrinkWrap: true,
                    //                             reverse: true,
                    //                             controller:
                    //                                 chatController.scrollController,
                    //                             // physics: const ScrollPhysics(),
                    //                             separatorBuilder: (context, index) {
                    //                               return const SizedBox(height: 4);
                    //                             },
                    //                             itemCount: chatController
                    //                                 .chat.value.messages!.length,
                    //                             itemBuilder: (context, index) {
                    //                               ChatMessage message = chatController
                    //                                   .chat.value.messages![index];
                    //                               log(" message.senderId ${message.senderId}");
                    //                               log(" userId $userId");
                    //                               String msgSenderId =
                    //                                   message.senderId ?? "";
                    //                               String senderId = userId!;
                    //                               bool isSender =
                    //                                   (msgSenderId == senderId);
                    //                               log("isSender $isSender");
                    //                               message.senderName;
                    //                               message.senderImage;

                    //                               return ChatBubble(
                    //                                 name: message.senderName ?? "",
                    //                                 image: message.senderImage,
                    //                                 isSender: isSender,
                    //                                 message: ChatMessage(
                    //                                   message: chatController
                    //                                       .chat
                    //                                       .value
                    //                                       .messages![index]
                    //                                       .message,
                    //                                   created: DateFormat(
                    //                                           'dd/MM/yyyy hh:mm a')
                    //                                       .format(
                    //                                     DateTime.parse(
                    //                                       chatController
                    //                                           .chat
                    //                                           .value
                    //                                           .messages![index]
                    //                                           .created!,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               );
                    //                             },
                    //                           ),
                    //                           // ),
                    //                         );
                    //         })),
                    //   ),

                    //   // Send Button
                    //   Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Row(
                    //       children: [
                    //         // Obx(
                    //         //   () =>

                    //         chatController.isPostMessageLoading.value
                    //             ? Center(
                    //                 child: CircularProgressIndicator(
                    //                     color: Colors.green[800]))
                    //             : IconButton(
                    //               icon: Icon(
                    //                 Icons.send,
                    //                 size: 30,
                    //                 color: Colors.green[800],
                    //               ),
                    //               onPressed: () async {
                    //                 if (messageController.text.trim() != '') {
                    //                   bool? send =
                    //                       await chatController.postMessage(
                    //                           chatId: widget.chatId!,
                    //                           message: messageController.text,
                    //                           context: context);
                    //                   if (send == true) {
                    //                     setState(() {
                    //                       chatController.chat.value.messages!.add(
                    //                           ChatMessage(
                    //                               // senderName: "",
                    //                               // senderImage: "",
                    //                               senderId: userId,
                    //                               message: messageController.text,
                    //                               created:
                    //                                   DateTime.now().toString()));
                    //                     });
                    //                     messageController.clear();
                    //                     if (chatController.chat.value.messages !=
                    //                             null &&
                    //                         chatController
                    //                                 .chat.value.messages!.length >
                    //                             2) {
                    //                       chatController.scrollController.jumpTo(
                    //                           chatController.scrollController
                    //                                   .position.maxScrollExtent *
                    //                               1.4);
                    //                     }
                    //                   }
                    //                 }
                    //               },
                    //             ),
                    //         Expanded(
                    //           child: CustomTextField(
                    //             controller: messageController,
                    //             hintText: 'message'.tr,
                    //             maxLines: 5,
                    //             minLines: 1,
                    //             onChanged: (String value) {},
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ],
                    const SizedBox(height: 4)
                  ],
                ),
        ),
      ),
    );
  }
}




























































































































// import 'dart:developer';
// import 'dart:ffi';
// import 'package:ajwad_v4/auth/models/token.dart';
// import 'package:ajwad_v4/auth/services/auth_service.dart';
// import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
// import 'package:ajwad_v4/constants/colors.dart';
// import 'package:ajwad_v4/explore/tourist/model/place.dart';
// import 'package:ajwad_v4/payment/controller/payment_controller.dart';
// import 'package:ajwad_v4/payment/model/invoice.dart';
// import 'package:ajwad_v4/payment/view/check_out_screen.dart';
// import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
// import 'package:ajwad_v4/request/chat/controllers/chat_controller.dart';
// import 'package:ajwad_v4/request/chat/model/chat_model.dart';
// import 'package:ajwad_v4/request/chat/view/widgets/chat_bubble.dart';
// import 'package:ajwad_v4/request/chat/view/widgets/show_request_widget.dart';
// import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
// import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
// import 'package:ajwad_v4/utils/app_util.dart';
// import 'package:ajwad_v4/widgets/available_container_widget.dart';
// import 'package:ajwad_v4/widgets/check_container_widget.dart';
// import 'package:ajwad_v4/widgets/custom_button.dart';
// import 'package:ajwad_v4/widgets/custom_text.dart';
// import 'package:ajwad_v4/widgets/custom_textfield.dart';
// import 'package:ajwad_v4/widgets/payment_web_view.dart';
// import 'package:ajwad_v4/widgets/total_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart' ;
// import 'package:ajwad_v4/request/widgets/CansleDialog.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:ajwad_v4/request/local_notification.dart';

// import 'package:intl/intl.dart' as intel;




// class ChatScreenLive extends StatefulWidget {
//   // final String senderId;

//   String? chatId;
//   final RequestController? requestController;
//   final OfferController? offerController;
//   final bool isAjwadi;
//   final Booking ?booking;
//   final Place? place;
//   ChatScreenLive({
//     super.key,
//     required this.chatId,
//     this.booking,
//     required this.isAjwadi,
//     this.requestController,
//     this.offerController,
//     this.place,
//   });

//   @override
//   State<ChatScreenLive> createState() => _ChatScreenLiveState();
// }

// class _ChatScreenLiveState extends State<ChatScreenLive> {
// static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   final TextEditingController messageController = TextEditingController();
//   final chatController = Get.put(ChatController());
//   final _offerController = Get.put(OfferController());

//   final getStorage = GetStorage();
//   String? userId;
//     bool isDetailsTapped = false;
//   late double width, height;

//   bool isDetailsTapped1 = false;
// bool isDetailsTapped3 = false;

//   late bool isArabicSelected;
//   int startIndex = -1;
//   bool isSendTapped = false;
// static bool languageSelected = false;

 
// RxBool isDetailsTapped2 = false.obs;

//   PaymentController paymentController = Get.put(PaymentController());
//   Invoice? invoice;
//     bool isCheckingForPayment = false;

// static Future init()async{
//   InitializationSettings settings = InitializationSettings(
//    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//    iOS: DarwinInitializationSettings()

//   );
//   flutterLocalNotificationsPlugin.initialize(settings);
// }
//   @override
//   void initState() {
//     log("\n \n");
//     log("Chat Screen   chatId ${widget.chatId}");
//     log("\n \n");
//     if (widget.chatId != null) {
//       chatController.getChatById(id: widget.chatId!, context: context);
//     }
//     String token = getStorage.read('accessToken');
//     final Token jwtToken = AuthService.jwtForToken(token)!;
//     userId = jwtToken.id;
//     log(userId ?? "");
//         isArabicSelected = AppUtil.rtlDirection(context);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//    width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: lightGreyBackground,
//        body: Column(
//     children: [
//       SafeArea(
        
//             child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             InkWell(
//               onTap: () {
//                 Get.back();
//               },

//             child: Padding(
//               padding: AppUtil.rtlDirection2(context)? const EdgeInsets.only(left:20):const EdgeInsets.only(left:20),
//                 child: AppUtil.rtlDirection2(context)
//                     ? const Icon(
//                         Icons.keyboard_arrow_right,
//                         color: black,
//                         size: 30,
//                       )
//                     : const Icon(
//                         Icons.keyboard_arrow_left_outlined,
//                         color: black,
//                         size: 30,
//                       ),
//              ),
//             ),
//            const SizedBox(width:100),

//            Padding(
//               padding: const EdgeInsets.only(left:10),
              
//            child: widget.chatId != null
//             ? Text(
//               'chat'.tr,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w500,
                
                
//               ),
//             ):Text(
//               'showOffer'.tr,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w500,
                
                
//               ),
//             ),
//             ),
//           ],
//         ),
//       ),
//                       const SizedBox(height: 32),

//   Expanded(
//         child: ListView(
//       padding: const EdgeInsets.only(left:16,right:16,top:12,bottom: 12),
//       children: [
               
//              Column(
//                 children: [
//     Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         child: ListTile(
//           onTap: () {
//             setState(() {
//               isDetailsTapped1 = !isDetailsTapped1;
//             });
//           },
//           title: CustomText(
//             text: 'tripDetails'.tr,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//             textAlign: AppUtil.rtlDirection2(context)
//                 ? TextAlign.right
//                 : TextAlign.left,
//           ),
//           trailing: Icon(
//             isDetailsTapped1
//                 ? Icons.keyboard_arrow_up
//                 : Icons.keyboard_arrow_down,
//             color: darkGrey,
//             size: 24,
//           ),
//         ),
//       ),

//       if (isDetailsTapped1)
//         Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//           padding: EdgeInsets.only(top: 20),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     SvgPicture.asset('assets/icons/guests.svg'),
//                     const SizedBox(width: 10),
//                     CustomText(
//                       text: '${widget.booking?.guestNumber ?? 0} ${'guests'.tr}',
//                       color: almostGrey,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     SvgPicture.asset('assets/icons/date.svg'),
//                     const SizedBox(width: 10),
//                     CustomText(
//                       text: '${intel.DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.booking?.date ?? '2022-01-01'))} - ${widget.booking?.timeToGo}',
//                       color: almostGrey,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
//                       width: 20,
//                     ),
//                     const SizedBox(width: 10),
//                     CustomText(
//                       text: widget.booking?.vehicleType ?? '',
//                       color: almostGrey,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//       const SizedBox(
//         height: 13,
//       ),

//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         child: ListTile(
//           onTap: () {
//             setState(() {
//               isDetailsTapped3 = !isDetailsTapped3;
//             });
//           },
//           title: Row(
//             children: [
//               const CircleAvatar(
//                 backgroundImage: AssetImage('assets/images/ajwadi_image.png'),
//               ),
//               const SizedBox(width: 12),
//               CustomText(
//                 text: AppUtil.rtlDirection2(context) ? 'محمد علي' : 'Mohamed Ali',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Kufam',
//                 textAlign: AppUtil.rtlDirection2(context)
//                 ? TextAlign.right
//                 : TextAlign.left,
//               ),
//             ],
//           ),
//           trailing: Icon(
//             isDetailsTapped3
//                 ? Icons.keyboard_arrow_up
//                 : Icons.keyboard_arrow_down,
//             color: const Color(0xFF454545),
//             size: 24,
//           ),
//         ),
//       ),


//       if (isDetailsTapped3)
//         Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: AppUtil.rtlDirection2(context)
//                       ? 'يسعدني مساعدتك,  هذا هو جدول الرحلة ، تحقق من الأشياء التي تريد القيام بها'
//                       : 'I\'m happy to help you, this is the flight schedule check out the things you want to do',
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: colorDarkGrey,
//                   textAlign: AppUtil.rtlDirection2(context) ? TextAlign.right :  TextAlign.left,

//                 ),
//               ],
//             ),
//           ),
//         ),

//                   const SizedBox(
//                     height: 13,
//                   ),
//                   if (widget.chatId != null &&  (!widget.isAjwadi)) ...[
                    
                  
//                     Visibility(
//                         visible: !languageSelected ,
//                          child:Column(
//                       children: [
//                         Align(
//                           alignment: AppUtil.rtlDirection2(context)?Alignment.centerRight:Alignment.centerLeft,
//                           child: Container(
//                             width: width * double.infinity,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 16, horizontal: 16),
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                             ),
//                             alignment: Alignment.center,
//                             child: CustomText(
//                               text: AppUtil.rtlDirection2(context)
//                                   ? 'ما هي اللغة التي تفضلها ؟'
//                                   : 'What language would you prefer ?',
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: colorDarkGrey,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: width,
//                             alignment: Alignment.center,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         isArabicSelected = false;
//                                     chatController.chat.value.language='English';
//                                         languageSelected = true;

//                                       });
//                                     },
//                                     child: Container(
//                                       height: 40,
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                         border: isArabicSelected
//                                             ? Border.all(
//                                                 color: colorGreen,
//                                                 width: 1.5,
//                                               )
//                                             : null,
//                                         color: isArabicSelected
//                                             ? null
//                                             : colorGreen,
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(10)),
//                                       ),
//                                       child: CustomText(
//                                         text: 'English',
//                                         color: isArabicSelected
//                                             ? colorGreen
//                                             : Colors.white,
//                                         fontFamily: 'Kufam',
//                                         fontSize: isArabicSelected ? 14 : 16,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 8,
//                                 ),
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         isArabicSelected = true;
//                                        languageSelected = true;
//                                        chatController.chat.value.language='العربية';

//                                       });
//                                     },
//                                     child: Container(
//                                       height: 40,
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                         border: !isArabicSelected
//                                             ? Border.all(
//                                                 color: colorGreen,
//                                                 width: 1.5,
//                                               )
//                                             : null,
//                                         color: !isArabicSelected
//                                             ? null
//                                             : colorGreen,
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(10)),
//                                       ),
//                                       child: CustomText(
//                                         text: 'العربية',
//                                         color: !isArabicSelected
//                                             ? colorGreen
//                                             : Colors.white,
//                                         fontFamily: 'Kufam',
//                                         fontSize: !isArabicSelected ? 14 : 16,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                      
                   
//                         // const SizedBox(
//                         //   height: 13,
//                         // ),
//                       ],
//                     ),
//                     ),
//                   ],
//                     // const SizedBox(
//                     //       height: 13,
//                     //     ),

//                        if(widget.chatId != null && languageSelected)
//                         Container(
//                           width: width,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 16, horizontal: 16),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.all(Radius.circular(12)),
//                           ),
//                           alignment: Alignment.center,

//                           child:Column(
//                           children:[
                          
//                           CustomText(
//                             text: isArabicSelected
//                                 ? 'رائع ، سآتي اصطحابك الساعة 10:00 صباحًا في سيارة جي إم سي - سوداء - الرقم: S B A 0 9 9'
//                                 : 'Great, i will come and pick you at 10:00AM in GMC Car  - Black -Number: S B A 0 9 9',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             color: colorDarkGrey,
//                             textAlign: isArabicSelected ?  TextAlign.right :  TextAlign.left,

//                           ),
                          
//                         const SizedBox(
//                           height: 13,
//                         ),
//                              if ((widget.isAjwadi)) ...[

//                             CustomText(
//                             text: chatController.chat.value.language??'ar',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             color: colorDarkGrey,
//                             textAlign: isArabicSelected ?  TextAlign.right :  TextAlign.left,

//                           ),
//                              ]
//                           ]
//                           ),
//                         ),
//                 ],
//               ),
            
//       //  const SizedBox(height: 30),

//                           // Padding(
//               //   padding: const EdgeInsets.all(16.0),
//               //   child: Row(
//               //     crossAxisAlignment: CrossAxisAlignment.center,
//               //     children: [
//               //       Expanded(
//               //         flex: 2,
//               //         child: InkWell(
//               //           onTap: () {
//               //             isDetailsTapped.value = !isDetailsTapped.value;
//               //           },
//               //           child: Container(
//               //             height: 56,
//               //             padding: const EdgeInsets.only(
//               //               left: 11,
//               //               right: 12,
//               //             ),
//               //             decoration: ShapeDecoration(
//               //               color: Colors.white,
//               //               shape: RoundedRectangleBorder(
//               //                 borderRadius: BorderRadius.circular(12),
//               //               ),
//               //             ),
//               //             child: Row(
//               //                 mainAxisAlignment: MainAxisAlignment.start,
//               //                 crossAxisAlignment: CrossAxisAlignment.center,
//               //                 children: [
//               //                   CustomText(
//               //                     text: 'tripDetails'.tr,
//               //                     color: darkBlue,
//               //                   ),
//               //                   const Spacer(),
//               //                   // Obx(
//               //                   //   () =>
//               //                   Icon(
//               //                     isDetailsTapped.value
//               //                         ? Icons.keyboard_arrow_up
//               //                         : Icons.keyboard_arrow_down,
//               //                     color: darkBlue,
//               //                     size: 24,
//               //                   ),
//               //                   // )
//               //                 ]),
//               //           ),
//               //         ),
//               //       ),
//               //       // End Request
//               //       if (widget.isAjwadi)
//               //         Expanded(
//               //           child:
//               //               //  Obx(
//               //               //   () =>
//               //               widget.requestController!.isRequestEndLoading.value
//               //                   ? const Center(
//               //                       child: CircularProgressIndicator(
//               //                           color: Color(0xffD75051)),
//               //                     )
//               //                   : InkWell(
//               //                       onTap: () async {
//               //                         log("requestModel.value.id! ${widget.requestController!.requestModel.value.id!}");
//               //                         bool requestEnd = await widget
//               //                                 .requestController!
//               //                                 .requestEnd(
//               //                                     id: widget.requestController!
//               //                                         .requestModel.value.id!,
//               //                                     context: context) ??
//               //                             false;
//               //                         if (requestEnd) {
//               //                           if (context.mounted) {
//               //                             AppUtil.successToast(
//               //                                 context, 'EndRound'.tr);
//               //                             await Future.delayed(
//               //                                 const Duration(seconds: 1));
//               //                           }
//               //                           Get.offAll(const AjwadiBottomBar());
//               //                         }
//               //                       },
//               //                       child: Container(
//               //                         height: 55,
//               //                         width: 120,
//               //                         padding: const EdgeInsets.symmetric(
//               //                             horizontal: 8),
//               //                         alignment: Alignment.center,
//               //                         decoration: BoxDecoration(
//               //                             border: Border.all(
//               //                                 color: const Color(0xffD75051)),
//               //                             borderRadius:
//               //                                 BorderRadius.circular(12)),
//               //                         child: Row(
//               //                           children: [
//               //                             if (!AppUtil.rtlDirection(context))
//               //                               const Icon(Icons.close,
//               //                                   size: 14,
//               //                                   color: Color(0xffD75051)),
//               //                             if (!AppUtil.rtlDirection(context))
//               //                               const Spacer(),
//               //                             CustomText(
//               //                               text: 'EndRound'.tr,
//               //                               color: const Color(0xffD75051),
//               //                               fontSize: 14,
//               //                             ),
//               //                             if (AppUtil.rtlDirection(context))
//               //                               const Spacer(),
//               //                             if (AppUtil.rtlDirection(context))
//               //                               const Icon(Icons.close,
//               //                                   size: 14,
//               //                                   color: Color(0xffD75051)),
//               //                           ],
//               //                         ),
//               //                       ),
//               //                     ),
//               //           // ),
//               //         ),
//               //     ],
//               //   ),
//               // ),
//               // ?  ============== Request Case =================
//               if ((widget.isAjwadi)) ...[
//                  Obx(() =>
//                 isDetailsTapped2.value
//                     ? widget.chatId == null
//                         ? Expanded(
//                             child: SingleChildScrollView(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 6),
//                               child: ShowRequestWidget(
//                                 requestController: widget.requestController!,
//                               ),
//                             ),
//                           )
//                         : Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 6),
//                             child: ShowRequestWidget(
//                               requestController: widget.requestController!,
//                             ),
//                           )
//                     : const SizedBox()
//                 ),
//               ],
              
//               // ?  ============== Offers Case =================
//               if (widget.chatId == null && (!widget.isAjwadi)) ...[
//                 Expanded(
//                   child: SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 6),
//                       child: Column(
//                         children: [
//                           CheckContainerWidget(
//                               offerController: widget.offerController),

//                               SizedBox(height: 10),
//                                SizedBox(
//                                   width: 358,
//                                         child: Text(
//                                 '*Please note that the prices listed are per person',
//                                            style: TextStyle(
//                                           color: Color(0xFF9392A0),
//                                            fontSize: 12,
//                                            fontFamily: 'SF Pro',
//                                           fontWeight: FontWeight.w400,
//                                                  height: 0,
//                                                   ),
//                                        ),
//                                    ),
//                                                 SizedBox(height: 170),

//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.only(
//                               top: 15,
//                               bottom: 15,
//                             ),
                            
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
                                
//                                 ...List.generate(
//                                     10,
//                                     (index) => Container(
//                                           width: 20,
//                                           decoration: const ShapeDecoration(
//                                             shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                 width: 0.24,
//                                                 strokeAlign: BorderSide
//                                                     .strokeAlignCenter,
//                                                 color: Color(0xFF979797),
//                                               ),
//                                             ),
//                                           ),
//                                         )
                                        
                                        
                                        
                                        
                                        
//                                         )
                                        
//                               ],
                              
//                             ),
                            
//                           ),

//                             //  const AvailableContainerWidget(),
//                           TotalWidget(
//                             offerController: widget.offerController,
//                             place: widget.place!,
//                           ),
//                           paymentController.isPaymenInvoiceLoading.value
//                               ? CircularProgressIndicator(
//                                   color: colorGreen,
//                                 )
                                
//                               : CustomButton(
                                
//                                 title: 'pay'.tr,

                                



//                                 icon: Icon(Icons.keyboard_arrow_right,color: Colors.white),
//                                   onPressed: () async {
//                                     invoice ??=
//                                         await paymentController.paymentInvoice(
//                                             context: context,
//                                             description: 'Book place',
//                                             amount: (widget.place!.price! *
//                                                     widget
//                                                         .offerController!
//                                                         .offerDetails
//                                                         .value
//                                                         .booking!
//                                                         .guestNumber!) +
//                                                 (widget.offerController!
//                                                         .totalPrice.value *
//                                                     widget
//                                                         .offerController!
//                                                         .offerDetails
//                                                         .value
//                                                         .booking!
//                                                         .guestNumber!));

//                                     Get.to(() => PaymentWebView(
//                                         url: invoice!.url!,
//                                         title: 'Payment'))?.then((value) async {
                                    
//                                        setState(() {
//                                                   isCheckingForPayment = true;
//                                                 });

//                                                         final checkInvoice =
//                                                     await paymentController
//                                                         .paymentInvoiceById(
//                                                             context: context,
//                                                             id: invoice!.id);

//                                                             print("checkInvoice!.invoiceStatus");
//                                                             print(checkInvoice!.invoiceStatus);

//                                                                          if (checkInvoice
//                                                         .invoiceStatus !=
//                                                     'faild') {
                                                
//                                                   setState(() {
//                                                     isCheckingForPayment =
//                                                         false;
//                                                   });

//                                                   if (checkInvoice
//                                                               .invoiceStatus ==
//                                                           'failed' ||
//                                                       checkInvoice
//                                                               .invoiceStatus ==
//                                                           'initiated') {
//                                                     //  Get.back();

//                                                     showDialog(
//                                                         context: context,
//                                                         builder: (ctx) {
//                                                           return AlertDialog(
//                                                             backgroundColor:
//                                                                 Colors.white,
//                                                             content: Column(
//                                                               mainAxisSize:
//                                                                   MainAxisSize
//                                                                       .min,
//                                                               children: [
//                                                                 Image.asset(
//                                                                     'assets/images/paymentFaild.gif'),
//                                                                 CustomText(
//                                                                     text:
//                                                                         "paymentFaild"
//                                                                             .tr),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         });
//                                                   } else {
//                                                     print('YES sucssefly the payment');
//                                                     // Get.back();
//                                                     // Get.back();
                                                      
//                                                         final acceptedOffer = await widget
//                                         .offerController!
//                                         .acceptOffer(
//                                       context: context,
//                                       offerId: widget.offerController!.offerDetails.value.id!,
//                                       invoiceId: checkInvoice.id,
//                                       schedules: widget.offerController!
//                                           .offerDetails.value.schedule!,
//                                     );
//                                //     Get.back();
//                                 //    Get.back();

//                                                     showDialog(
//                                                         context: context,
//                                                         builder: (ctx) {
//                                                           return AlertDialog(
//                                                             backgroundColor:
//                                                                 Colors.white,
//                                                             content: Column(
//                                                               mainAxisSize:
//                                                                   MainAxisSize
//                                                                       .min,
//                                                               children: [
//                                                                 Image.asset(
//                                                                     'assets/images/paymentSuccess.gif'),
//                                                                 CustomText(
//                                                                     text:
//                                                                         "paymentSuccess"
//                                                                             .tr),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         });
//                                               // LocalNotification().showNotification(context,widget.booking?.id, widget.booking?.date ,widget.offerController?.offerDetails.value.name ?? "", widget.booking?.place?.nameAr,widget.booking?.place?.nameEn);

//                                                   }
//                                                 }
//                                     });
//                                     // Get.to(
//                                     //   () => CheckOutScreen(
//                                     //     total: (widget.place!.price! *
//                                     //             widget
//                                     //                 .offerController!
//                                     //                 .offerDetails
//                                     //                 .value
//                                     //                 .booking!
//                                     //                 .guestNumber!) +
//                                     //         (widget.offerController!.totalPrice
//                                     //                 .value *
//                                     //             widget
//                                     //                 .offerController!
//                                     //                 .offerDetails
//                                     //                 .value
//                                     //                 .booking!
//                                     //                 .guestNumber!),
//                                     //     offerDetails: widget.offerController!
//                                     //         .offerDetails.value,
//                                     //     offerController: widget.offerController,
//                                     //   ),
//                                     // )?.then((value) async {
//                                     //   final offer = await widget
//                                     //       .offerController!
//                                     //       .getOfferById(
//                                     //           context: context,
//                                     //           offerId: widget.offerController!
//                                     //               .offerDetails.value.id!);

//                                     //   widget.chatId = widget.offerController!
//                                     //       .offerDetails.value.booking!.chatId;

//                                     //   //  Get.back();
//                                     // });

//                                      LocalNotification().showNotification(context,widget.booking?.id, widget.booking?.timeToGo, widget.booking?.date,widget.offerController?.offerDetails.value.name ?? "", widget.booking?.place?.nameAr,widget.booking?.place?.nameEn);
//                                   },
//                                 )
//                         ],
//                       )

//                       // ShowOfferWidget(
//                       //   offerController: widget.offerController!,
//                       //   place: widget.place!,
//                       // ),
//                       ),
//                 ),
//               ],

//               if (widget.chatId != null) ...[
//                 //? ==========  Chat List View  ==========
//                 Expanded(
//                   child: StreamBuilder<ChatModel?>(
//                       stream: chatController.getChatByIdStream(
//                           id: widget.chatId!, context: context),
//                       builder: ((context, snapshot) {
//                         log("snapshot ${snapshot.data}");

//                         return
//                             Obx(
//                              () =>
//                             chatController.isGetChatByIdLoading.value
//                                 ? Center(
//                                     child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 14),
//                                         child: CircularProgressIndicator(
//                                             color: Colors.green[800])),
//                                   )
//                                 : (chatController.chat.value.messages == null ||
//                                         chatController.chat.value.messages ==
//                                             [] ||
//                                         chatController
//                                             .chat.value.messages!.isEmpty)
//                                     ? Center(
//                                         child: CustomText(
//                                             text: 'StartChat'.tr,
//                                             fontSize: 24,
//                                             color: Colors.black87),
//                                       )
//                                     : RefreshIndicator(
//                                         color: Colors.green,
//                                         onRefresh: () async {
//                                           await chatController.getChatById(
//                                               id: widget.chatId!,
//                                               context: context);
//                                         },
//                                         child: ListView.separated(
//                                           shrinkWrap: true,
//                                           reverse: true,
//                                           controller:
//                                               chatController.scrollController,
//                                           // physics: const ScrollPhysics(),
//                                           separatorBuilder: (context, index) {
//                                             return const SizedBox(height: 4);
//                                           },
//                                           itemCount: chatController
//                                               .chat.value.messages!.length,
//                                           itemBuilder: (context, index) {
//                                             ChatMessage message = chatController
//                                                 .chat.value.messages![index];
//                                             log(" message.senderId ${message.senderId}");
//                                             log(" userId $userId");
//                                             String msgSenderId =
//                                                 message.senderId ?? "";
//                                             String senderId = userId!;
//                                             bool isSender =
//                                                 (msgSenderId == senderId);
//                                             log("isSender $isSender");
//                                             message.senderName;
//                                             message.senderImage;

//                                             return ChatBubble(
//                                               name: message.senderName ?? "",
//                                               image: message.senderImage,
//                                               isSender: isSender,
//                                               message: ChatMessage(
//                                                 message: chatController
//                                                     .chat
//                                                     .value
//                                                     .messages![index]
//                                                     .message,
//                                                 created: DateFormat(
//                                                         'dd/MM/yyyy hh:mm a')
//                                                     .format(
//                                                   DateTime.parse(
//                                                     chatController
//                                                         .chat
//                                                         .value
//                                                         .messages![index]
//                                                         .created!,
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                          ),
//                                       );
//                       })),
//                 ),

//                 // // Send Button
               
//               ],
//                 ],
//           ),
//         ),
//          // Send Button
//          if(widget.chatId != null)
//          Container(
//                   width: 390,
// height: 90,
// padding: const EdgeInsets.only(
// top: 14,
// left: 1,
// right: 1,
// bottom: 16,
// ),
// decoration: BoxDecoration(color: Colors.white),

//                   child: Row(
//                     children: [
//                       // Obx(
//                       //   () =>

//                       chatController.isPostMessageLoading.value
//                           ? Center(
//                               child: CircularProgressIndicator(
//                                   color: Colors.green[800]))
//                                   :
//                           // : IconButton(
//                           //   icon: Icon(
//                           //     Icons.send,
//                           //     size: 30,
//                           //     color: Colors.green[800],
//                           //   ),
//                           //   onPressed: () async {
//                           //     if (messageController.text.trim() != '') {
//                           //       bool? send =
//                           //           await chatController.postMessage(
//                           //               chatId: widget.chatId!,
//                           //               message: messageController.text,
//                           //               context: context);
//                           //       if (send == true) {
//                           //         setState(() {
//                           //           chatController.chat.value.messages!.add(
//                           //               ChatMessage(
//                           //                   // senderName: "",
//                           //                   // senderImage: "",
//                           //                   senderId: userId,
//                           //                   message: messageController.text,
//                           //                   created:
//                           //                       DateTime.now().toString()));
//                           //         });
//                           //         messageController.clear();
//                           //         if (chatController.chat.value.messages !=
//                           //                 null &&
//                           //             chatController
//                           //                     .chat.value.messages!.length >
//                           //                 2) {
//                           //           chatController.scrollController.jumpTo(
//                           //               chatController.scrollController
//                           //                       .position.maxScrollExtent *
//                           //                   1.4);
//                           //         }
//                           //       }
//                           //     }
//                           //   },
//                           // ),
//                       Expanded(
//                         child: CustomTextField(
//                           controller: messageController,
//                           hintText: 'HintMessage'.tr,

//                           suffixIcon: !AppUtil.rtlDirection2(context)?
//                            IconButton(
//                             icon: Icon(
//                               Icons.send ,
//                               size: 24,
//                               color: Colors.green[800],
//                             ),
//                             onPressed: () async {
//                               if (messageController.text.trim() != '') {
//                                 bool? send =
//                                     await chatController.postMessage(
//                                         chatId: widget.chatId!,
//                                         message: messageController.text,
//                                         context: context);
//                                 if (send == true) {
//                                   setState(() {
//                                     chatController.chat.value.messages!.add(
//                                         ChatMessage(
//                                             // senderName: "",
//                                             // senderImage: "",
//                                             senderId: userId,
//                                             message: messageController.text,
//                                             created:
//                                                 DateTime.now().toString()));
//                                   });
//                                   messageController.clear();
//                                   if (chatController.chat.value.messages !=
//                                           null &&
//                                       chatController
//                                               .chat.value.messages!.length >
//                                           2) {
//                                     chatController.scrollController.jumpTo(
//                                         chatController.scrollController
//                                                 .position.maxScrollExtent *
//                                             1.4);
//                                   }
//                                 }
//                               }
//                             },
//                           ):null, 
//                           prefixIcon: AppUtil.rtlDirection2(context)?
//                             IconButton(
//                             icon: Icon(
//                               Icons.send ,
//                               size: 24,
//                               color: Colors.green[800],
//                             ),
//                             onPressed: () async {
//                               if (messageController.text.trim() != '') {
//                                 bool? send =
//                                     await chatController.postMessage(
//                                         chatId: widget.chatId!,
//                                         message: messageController.text,
//                                         context: context);
//                                 if (send == true) {
//                                   setState(() {
//                                     chatController.chat.value.messages!.add(
//                                         ChatMessage(
//                                             // senderName: "",
//                                             // senderImage: "",
//                                             senderId: userId,
//                                             message: messageController.text,
//                                             created:
//                                                 DateTime.now().toString()));
//                                   });
//                                   messageController.clear();
//                                   if (chatController.chat.value.messages !=
//                                           null &&
//                                       chatController
//                                               .chat.value.messages!.length >
//                                           2) {
//                                     chatController.scrollController.jumpTo(
//                                         chatController.scrollController
//                                                 .position.maxScrollExtent *
//                                             1.4);
//                                   }
//                                 }
//                               }
//                               }
//                             ): null,
//                           height:  MediaQuery.of(context).size.height * 0.06,
//                            maxLines: 5,
//                            minLines: 1,
//                           onChanged: (String value) {},
//                         ),
//                       ),
//                     ],
//                   ),
//          ),
//               const SizedBox(height: 8)
//         //     ],
//         //   ),
//         // ),
      
//     ],
//   ),
// );
//   }
// }
