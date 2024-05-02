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
import 'package:intl/intl.dart' ;
import 'package:ajwad_v4/request/widgets/CansleDialog.dart';


class ChatScreenLive extends StatefulWidget {
  // final String senderId;
  String? chatId;
  final RequestController? requestController;
  final OfferController? offerController;
  final bool isAjwadi;
  final Booking ?booking;
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
  final TextEditingController messageController = TextEditingController();
  final chatController = Get.put(ChatController());
  final _offerController = Get.put(OfferController());

  final getStorage = GetStorage();
  String? userId;
    bool isDetailsTapped = false;
  late double width, height;


RxBool isDetailsTapped2 = false.obs;

  PaymentController paymentController = Get.put(PaymentController());
  Invoice? invoice;
    bool isCheckingForPayment = false;

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
      body: Obx(
        () => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  const SizedBox(height: 10),

                  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: AppUtil.rtlDirection2(context)
                      ? const Icon(
                          Icons.keyboard_arrow_right,
                          color: black,
                          size: 30,
                        )
                      : const Icon(
                          Icons.keyboard_arrow_left_outlined,
                          color: black,
                          size: 30,
                        ),
                ),
              ),
                Text(
                  'showOffer'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CancelBookingDialog(
                        dialogWidth:
                            MediaQuery.of(context).size.width * 0.588,
                        buttonWidth:
                            MediaQuery.of(context).size.width * 1.191,
                        // booking: widget.booking,
                        offerController: _offerController,
                      );
                    },
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/more.svg',
                   color: black,

                ),
              ),
          


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
                ],
              ),
              const SizedBox(height: 10),
              Padding(padding: const EdgeInsets.only(left: 90)),
       Center(
          child:  Container(
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
          textAlign: AppUtil.rtlDirection2(context) ? TextAlign.right : TextAlign.left,

          
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
                    text: '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.booking?.date ?? ''))} - ${widget.booking?.timeToGo}',
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
    ],
  ),
),
       ),         
          
       const SizedBox(height: 30),

                          // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: InkWell(
              //           onTap: () {
              //             isDetailsTapped.value = !isDetailsTapped.value;
              //           },
              //           child: Container(
              //             height: 56,
              //             padding: const EdgeInsets.only(
              //               left: 11,
              //               right: 12,
              //             ),
              //             decoration: ShapeDecoration(
              //               color: Colors.white,
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //             ),
              //             child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   CustomText(
              //                     text: 'tripDetails'.tr,
              //                     color: darkBlue,
              //                   ),
              //                   const Spacer(),
              //                   // Obx(
              //                   //   () =>
              //                   Icon(
              //                     isDetailsTapped.value
              //                         ? Icons.keyboard_arrow_up
              //                         : Icons.keyboard_arrow_down,
              //                     color: darkBlue,
              //                     size: 24,
              //                   ),
              //                   // )
              //                 ]),
              //           ),
              //         ),
              //       ),
              //       // End Request
              //       if (widget.isAjwadi)
              //         Expanded(
              //           child:
              //               //  Obx(
              //               //   () =>
              //               widget.requestController!.isRequestEndLoading.value
              //                   ? const Center(
              //                       child: CircularProgressIndicator(
              //                           color: Color(0xffD75051)),
              //                     )
              //                   : InkWell(
              //                       onTap: () async {
              //                         log("requestModel.value.id! ${widget.requestController!.requestModel.value.id!}");
              //                         bool requestEnd = await widget
              //                                 .requestController!
              //                                 .requestEnd(
              //                                     id: widget.requestController!
              //                                         .requestModel.value.id!,
              //                                     context: context) ??
              //                             false;
              //                         if (requestEnd) {
              //                           if (context.mounted) {
              //                             AppUtil.successToast(
              //                                 context, 'EndRound'.tr);
              //                             await Future.delayed(
              //                                 const Duration(seconds: 1));
              //                           }
              //                           Get.offAll(const AjwadiBottomBar());
              //                         }
              //                       },
              //                       child: Container(
              //                         height: 55,
              //                         width: 120,
              //                         padding: const EdgeInsets.symmetric(
              //                             horizontal: 8),
              //                         alignment: Alignment.center,
              //                         decoration: BoxDecoration(
              //                             border: Border.all(
              //                                 color: const Color(0xffD75051)),
              //                             borderRadius:
              //                                 BorderRadius.circular(12)),
              //                         child: Row(
              //                           children: [
              //                             if (!AppUtil.rtlDirection(context))
              //                               const Icon(Icons.close,
              //                                   size: 14,
              //                                   color: Color(0xffD75051)),
              //                             if (!AppUtil.rtlDirection(context))
              //                               const Spacer(),
              //                             CustomText(
              //                               text: 'EndRound'.tr,
              //                               color: const Color(0xffD75051),
              //                               fontSize: 14,
              //                             ),
              //                             if (AppUtil.rtlDirection(context))
              //                               const Spacer(),
              //                             if (AppUtil.rtlDirection(context))
              //                               const Icon(Icons.close,
              //                                   size: 14,
              //                                   color: Color(0xffD75051)),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //           // ),
              //         ),
              //     ],
              //   ),
              // ),
              // ?  ============== Request Case =================
              if ((widget.isAjwadi)) ...[
                 Obx(() =>
                isDetailsTapped2.value
                    ? widget.chatId == null
                        ? Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              child: ShowRequestWidget(
                                requestController: widget.requestController!,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: ShowRequestWidget(
                              requestController: widget.requestController!,
                            ),
                          )
                    : const SizedBox()
                ),
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...List.generate(
                                    10,
                                    (index) => Container(
                                          width: 20,
                                          decoration: const ShapeDecoration(
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
                          //  const AvailableContainerWidget(),
                          TotalWidget(
                            offerController: widget.offerController,
                            place: widget.place!,
                          ),
                          paymentController.isPaymenInvoiceLoading.value
                              ? CircularProgressIndicator(
                                  color: colorGreen,
                                )
                              : CustomButton(
                                
                                title: 'pay'.tr,





                                icon: Icon(Icons.keyboard_arrow_right,color: Colors.white),
                                  onPressed: () async {
                                    invoice ??=
                                        await paymentController.paymentInvoice(
                                            context: context,
                                            description: 'Book place',
                                            amount: (widget.place!.price! *
                                                    widget
                                                        .offerController!
                                                        .offerDetails
                                                        .value
                                                        .booking!
                                                        .guestNumber!) +
                                                (widget.offerController!
                                                        .totalPrice.value *
                                                    widget
                                                        .offerController!
                                                        .offerDetails
                                                        .value
                                                        .booking!
                                                        .guestNumber!));

                                    Get.to(() => PaymentWebView(
                                        url: invoice!.url!,
                                        title: 'Payment'))?.then((value) async {
                                    
                                       setState(() {
                                                  isCheckingForPayment = true;
                                                });

                                                        final checkInvoice =
                                                    await paymentController
                                                        .paymentInvoiceById(
                                                            context: context,
                                                            id: invoice!.id);

                                                            print("checkInvoice!.invoiceStatus");
                                                            print(checkInvoice!.invoiceStatus);

                                                                         if (checkInvoice
                                                        .invoiceStatus !=
                                                    'faild') {
                                                
                                                  setState(() {
                                                    isCheckingForPayment =
                                                        false;
                                                  });

                                                  if (checkInvoice
                                                              .invoiceStatus ==
                                                          'failed' ||
                                                      checkInvoice
                                                              .invoiceStatus ==
                                                          'initiated') {
                                                    //  Get.back();

                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/paymentFaild.gif'),
                                                                CustomText(
                                                                    text:
                                                                        "paymentFaild"
                                                                            .tr),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    print('YES');
                                                    // Get.back();
                                                    // Get.back();

                                                        final acceptedOffer = await widget
                                        .offerController!
                                        .acceptOffer(
                                      context: context,
                                      offerId: widget.offerController!.offerDetails.value.id!,
                                      invoiceId: checkInvoice.id,
                                      schedules: widget.offerController!
                                          .offerDetails.value.schedule!,
                                    );
                               //     Get.back();
                                //    Get.back();

                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/paymentSuccess.gif'),
                                                                CustomText(
                                                                    text:
                                                                        "paymentSuccess"
                                                                            .tr),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  }
                                                }
                                    });
                                    // Get.to(
                                    //   () => CheckOutScreen(
                                    //     total: (widget.place!.price! *
                                    //             widget
                                    //                 .offerController!
                                    //                 .offerDetails
                                    //                 .value
                                    //                 .booking!
                                    //                 .guestNumber!) +
                                    //         (widget.offerController!.totalPrice
                                    //                 .value *
                                    //             widget
                                    //                 .offerController!
                                    //                 .offerDetails
                                    //                 .value
                                    //                 .booking!
                                    //                 .guestNumber!),
                                    //     offerDetails: widget.offerController!
                                    //         .offerDetails.value,
                                    //     offerController: widget.offerController,
                                    //   ),
                                    // )?.then((value) async {
                                    //   final offer = await widget
                                    //       .offerController!
                                    //       .getOfferById(
                                    //           context: context,
                                    //           offerId: widget.offerController!
                                    //               .offerDetails.value.id!);

                                    //   widget.chatId = widget.offerController!
                                    //       .offerDetails.value.booking!.chatId;

                                    //   //  Get.back();
                                    // });
                                  },
                                )
                        ],
                      )

                      // ShowOfferWidget(
                      //   offerController: widget.offerController!,
                      //   place: widget.place!,
                      // ),
                      ),
                ),
              ],

              if (widget.chatId != null) ...[
                //? ==========  Chat List View  ==========
                Expanded(
                  child: StreamBuilder<ChatModel?>(
                      stream: chatController.getChatByIdStream(
                          id: widget.chatId!, context: context),
                      builder: ((context, snapshot) {
                        log("snapshot ${snapshot.data}");

                        return
                            // Obx(
                            //   () =>
                            chatController.isGetChatByIdLoading.value
                                ? Center(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 14),
                                        child: CircularProgressIndicator(
                                            color: Colors.green[800])),
                                  )
                                : (chatController.chat.value.messages == null ||
                                        chatController.chat.value.messages ==
                                            [] ||
                                        chatController
                                            .chat.value.messages!.isEmpty)
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
                                              id: widget.chatId!,
                                              context: context);
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
                                                created: DateFormat(
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
                                        // ),
                                      );
                      })),
                ),

                // Send Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Obx(
                      //   () =>

                      chatController.isPostMessageLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green[800]))
                          : IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 30,
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
              ],
              const SizedBox(height: 4)
            ],
          ),
        ),
      ),
    );
  }
}
