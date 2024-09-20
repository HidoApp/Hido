import 'dart:developer';

import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/tourist/view/tourist_chat_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_accept_button.dart';
import 'package:ajwad_v4/widgets/custom_reject_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../request/chat/view/chat_screen.dart';

// ignore: must_be_immutable
class CustomRequestItem extends StatelessWidget {
  CustomRequestItem({
    super.key,
    this.isChat = false,
    this.fromAjwady = true,
    required this.senderName,
    required this.requestName,
    required this.time,
    required this.imageUrl,
    required this.chatId,
    required this.requestId,
    required this.onPressedAccept,
    required this.onPressedReject,
    required this.requestController,
    required this.requestModel,
    this.status,
    this.offer,
    required this.index,
  });

  final String? requestId;
  final String? chatId;
  final List<RequestOffer>? offer;
  final bool isChat;
  final void Function() onPressedAccept;
  final void Function() onPressedReject;
  final RequestController? requestController;
  final String? status;
  final bool fromAjwady;
  final String senderName;
  final String requestName;
  final String time;
  final String? imageUrl;
  final int index;
  final RequestModel requestModel;

  var loading = false.obs;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             requestModel.senderImage != null ? 
            CircleAvatar(
                radius: 22.5,
                backgroundImage: CachedNetworkImageProvider(requestModel.senderImage!),
              )
             : const CircleAvatar(
                radius: 22.5,
                backgroundImage: AssetImage("assets/images/profile_image.png",
                               ),
              ),
              SizedBox(
                width: width * 0.5,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: AppUtil.rtlDirection(context)
                          ? senderName
                          : senderName,
                      style: const TextStyle(
                          fontFamily: 'Noto Kufi Arabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          // color: fromAjwady ? Colors.white : black,
                          color: black),
                    ),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: AppUtil.rtlDirection(context)
                          ? ' أرسلت طلب رحلة في '
                          : 'send a request for Trip in ',
                      style: const TextStyle(
                        fontFamily: 'Noto Kufi Arabic',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorDarkGrey,
                      ),
                    ),
                    TextSpan(
                      text: AppUtil.rtlDirection(context)
                          ? requestName
                          : requestName,
                      style: const TextStyle(
                          fontFamily: 'Noto Kufi Arabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkBlue),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: CustomText(
                  text: AppUtil.rtlDirection(context) ? time : time,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: colorDarkGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        if (isChat)
          Center(
            child: SizedBox(
              width: width * 0.5,
              child: Obx(
                () => requestController!.isGetRequestByIdLoading.value &&
                        loading.value
                    ? Center(
                        child:
                            CircularProgressIndicator(color: Colors.green[700]))
                    : CustomAcceptButton(
                       onPressed: () async {
                          if (fromAjwady) {
                            // var userID = offer![0].userId;
                            // log("userId ${userID!}");
                            loading.value = true;
                            RequestModel? requestModel =
                                await requestController!.getRequestById(
                                    requestId: requestId!, context: context);
                            loading.value = false;

                            if (requestModel != null ) {
                              log("chatId ${requestModel.chatId}");
                              Get.to(() => ChatScreen(
                                     chatId: requestModel.chatId,
                                     booking: requestModel.booking!,
                                  ));
                              // Get.to(() => ChatScreenLive(
                              //       isAjwadi: true,
                              //       requestController: requestController,
                              //       // senderId: userID,
                              //       offerController: Get.put(OfferController()),
                              //       chatId: requestModel.chatId,
                              //       booking: requestModel.booking!,
                              //     ));
                            }
                          } else {
                            log("TouristChatScreen");
                            Get.to(() => const TouristChatScreen(isChat: true));
                          }

                       // End Request
    // log("Ending the trip");
    // requestController!.isRequestEndLoading.value = true;
    // bool requestEnd = await requestController!.requestEnd(
    //   id: requestId!,
    //   context: context,
    // ) ?? false;
    // requestController!.isRequestEndLoading.value = false;

    // if (requestEnd) {
    //   if (context.mounted) {
    //     AppUtil.successToast(context, 'EndRound'.tr);
    //     await Future.delayed(const Duration(seconds: 1));
    //     Get.offAll(const AjwadiBottomBar());
    //   }
    // }
  

                    // End Request
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
                       },
                       title: 'chat'.tr,
                       icon: 'chat',
                      ),

                     
              ),
            ),
          )
        else
          // status == "PENDING"
          //     ? Center(
          //         child: SizedBox(
          //             width: width * 0.5, child: const _CustomPendingButton()))
          //     :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAcceptButton(onPressed: onPressedAccept),
              const SizedBox(
                width: 13,
              ),
              Obx(
                () => requestController!.isRequestRejectLoading.value &&
                        (requestController!.requestIndex.value == index)
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    : CustomRejectButton(onPressed: onPressedReject),
              ),
            ],
          ),
      ],
    );
  }
}

class _CustomPendingButton extends StatelessWidget {
  const _CustomPendingButton({
    super.key,
    this.title,
    this.icon,
  });

  final String? title;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.yellow[700]),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
        ),
        fixedSize: MaterialStateProperty.all(const Size.fromHeight(36)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/${'accept'}.svg'),
          const SizedBox(
            width: 12,
          ),
          CustomText(
            text: title ?? 'PENDING'.tr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
