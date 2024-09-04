import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen_live.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_accept_button.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart' as book;

import '../../chat/view/chat_screen.dart';

class ShowAjwadiInfoSheet extends StatefulWidget {
  const ShowAjwadiInfoSheet({
    Key? key,
    required this.image,
    required this.name,
    required this.rating,
    required this.price,
    required this.tripNumber,
    // required this.booking,
    required this.place,
  }) : super(key: key);
  final String image;
  final String name;
  final price,  tripNumber;
  final double rating;
  // final Booking booking;
  final Place place;

  @override
  State<ShowAjwadiInfoSheet> createState() => _ShowAjwadiInfoSheetState();
}

class _ShowAjwadiInfoSheetState extends State<ShowAjwadiInfoSheet>
    with SingleTickerProviderStateMixin {
  final _offerController = Get.put(OfferController());
  // late TabController _tabController;
  // int tabIndex = 0;

  late double width, height;

  // var interestList = [
  //   "gamesOnline".tr,
  //   "concert".tr,
  //   "music".tr,
  //   "art".tr,
  //   "movie".tr,
  //   "others".tr,
  // ];

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 2, vsync: this);
  // }

  final getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onDoubleTap: () {
        Get.back();
      },
      child: Container(
        height: 0.7 * height,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child:
            ListView(physics: const NeverScrollableScrollPhysics(), children: [
          const Icon(
            Icons.keyboard_arrow_up,
            size: 30,
          ),
          const SizedBox(
            height: 20,
          ),
          widget.image.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    widget.image,
                  ),
                  radius: 40,
                )
              : CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/profile_image.png',
                  ),
                  radius: 50,
                ),

          // Image.network(
          //   widget.image,
          //   height: 100,
          //   width: 100,
          //   // fit: BoxFit.cover,
          // ),
          if (widget.image.isNotEmpty)
            const SizedBox(
              height: 20,
            ),
          Center(
            child: CustomText(
              text: widget.name,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: widget.tripNumber.toString(),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    text: "trips2".tr,
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                    color: almostGrey,
                  ),
                ],
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const VerticalDivider(
                  color: tileGreyColor,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  //width: 20,
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: '${widget.rating.toString()} ',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      SvgPicture.asset("assets/icons/star.svg")
                    ],
                  ),
                  CustomText(
                    text: "review".tr,
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                    color: almostGrey,
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          // ?  ==== Already Accepted ====
          Obx(() {
            if (_offerController.offerDetails.value.orderStatus == 'ACCEPTED') {
              return CustomAcceptButton(
                onPressed: () {
                  // OfferDetails? offerDetails =
                  //     await _offerController.getOfferById(
                  //         context: context,
                  //         offerId: _offerController.offerDetails.value.id!);
                  // offerDetails

                  // if (offerDetails != null) {
                  // String userId = getStorage.read('userId');
                  // log("chatId ${offerDetails.booking!.chatId!}");
                  // log("userId $userId");
                  // Get.to(() => ChatScreen(
                  //       senderId: userId,
                  //       chatId: offerDetails.chatId!,
                  //     ));
                  // Get.to(() => ChatScreenLive(
                  //       isAjwadi: false,
                  //       offerController: _offerController,
                  //       booking: _offerController.offerDetails.value.booking!,
                  //       chatId: _offerController
                  //           .offerDetails.value.booking!.chatId!,
                  //       place: widget.place,
                  //     ));
                  
                          Get.to(() => ChatScreen(
                                chatId: _offerController
                                    .offerDetails.value.booking!.chatId!,
                                 booking: _offerController
                                      .offerDetails.value.booking!,

                              ));
                  // }
                },
                title: 'chat'.tr,
                icon: 'chat',
              );
            }
            if (_offerController.isAcceptOfferLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_offerController.acceptedOffer.value.orderStatus ==
                'ACCEPTED') {
              return Center(
                child: SizedBox(
                  width: width * 0.5,
                  child: _offerController.isOfferLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Colors.green[700]))
                      : CustomAcceptButton(
                          onPressed: () async {
                            OfferDetails? offerDetails =
                                await _offerController.getOfferById(
                                    context: context,
                                    offerId: _offerController
                                        .offerDetails.value.id!);
                            // offerDetails

                            if (offerDetails != null) {
                              // String userId = getStorage.read('userId');
                              // log("chatId ${offerDetails.booking!.chatId!}");
                              // log("userId $userId");
                              // Get.to(() => ChatScreen(
                              //       senderId: userId,
                              //       chatId: offerDetails.chatId!,
                              //     ));
                              // Get.to(() => ChatScreenLive(
                              //       isAjwadi: false,
                              //       offerController: _offerController,
                              //       booking: offerDetails.booking!,
                              //       chatId: offerDetails.booking!.chatId!,
                              //       place: widget.place,
                              //     ));

                              
                          Get.to(() => ChatScreen(
                                chatId: _offerController
                                    .offerDetails.value.booking!.chatId!,
                                 booking: _offerController
                                      .offerDetails.value.booking!,

                              ));
                            }
                          },
                          title: 'chat'.tr,
                          icon: 'chat',
                        ),
                ),
              );
            }

            return CustomButton(
                onPressed: () async {
                  log("CustomButton");
                  var payment = _offerController.offerDetails.value.payment;
                  log("payment $payment");
                  log("payment ${payment.runtimeType}");
                  if (payment != null &&
                      payment.isNotEmpty &&
                      // paid
                      _offerController
                              .offerDetails.value.payment!['payStatus'] ==
                          "paid") {
                    log("acceptOffer");
                    // final acceptedOffer = await _offerController.acceptOffer(
                    //   context: context,
                    //   offerId: _offerController.offerDetails.value.id!,
                    //   schedules: _offerController.offerDetails.value.schedule!,
                    // );

                    // if (acceptedOffer!.orderStatus == 'ACCEPTED' &&
                    //     context.mounted) {
                    //   AppUtil.successToast(
                    //     context,
                    //     acceptedOffer.orderStatus,
                    //   );

                    //   // Get.to(() => const TouristChatScreen(
                    //   //       isChat: true,
                    //   //     ));
                    // }
                  } else {
                    log("ChatScreenLive 33");
                    Get.back();
                    Get.to(() => ChatScreenLive(
                          isAjwadi: false,
                          offerController: _offerController,
                          booking: _offerController.offerDetails.value.booking!,
                          chatId: _offerController
                              .offerDetails.value.booking?.chatId,
                          place: widget.place,
                        ));
                  }
                },
                iconColor: colorDarkGreen,
                italic: AppUtil.rtlDirection(context) ? false : true,
                title: (_offerController.offerDetails.value.payment != null &&
                        _offerController
                            .offerDetails.value.payment!.isNotEmpty &&
                        //paid
                        _offerController
                                .offerDetails.value.payment!['payStatus'] ==
                            "paid")
                    ? "acceptOffer".tr
                    : "showOffer".tr,
                icon: const Icon(Icons.check)

                // SvgPicture.asset("assets/icons/user-plus.svg"),
                );
          }),
          const SizedBox(
            height: 30,
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             tabIndex = 0;
          //           });
          //         },
          //         child: Column(
          //           children: [
          //             CustomText(
          //               text: "about".tr,
          //               color: tabIndex == 0 ? colorGreen : almostGrey,
          //               fontWeight:
          //                   tabIndex == 0 ? FontWeight.w700 : FontWeight.w300,
          //               fontSize: 15,
          //             ),
          //             const SizedBox(
          //               height: 3,
          //             ),
          //             tabIndex == 0
          //                 ? Container(
          //                     color: colorGreen,
          //                     height: 2,
          //                     width: 50,
          //                   )
          //                 : Container()
          //           ],
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             tabIndex = 1;
          //           });
          //         },
          //         child: Column(
          //           children: [
          //             CustomText(
          //               text: "expert".tr,
          //               color: tabIndex == 1 ? colorGreen : almostGrey,
          //               fontWeight:
          //                   tabIndex == 1 ? FontWeight.w700 : FontWeight.w300,
          //               fontSize: 15,
          //             ),
          //             const SizedBox(
          //               height: 3,
          //             ),
          //             tabIndex == 1
          //                 ? Container(
          //                     color: colorGreen,
          //                     height: 2,
          //                     width: 50,
          //                   )
          //                 : Container()
          //           ],
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             tabIndex = 2;
          //           });
          //         },
          //         child: Column(
          //           children: [
          //             CustomText(
          //               text: "reviews".tr,
          //               color: tabIndex == 2 ? colorGreen : almostGrey,
          //               fontWeight:
          //                   tabIndex == 2 ? FontWeight.w700 : FontWeight.w300,
          //               fontSize: 15,
          //             ),
          //             const SizedBox(
          //               height: 3,
          //             ),
          //             tabIndex == 2
          //                 ? Container(
          //                     color: colorGreen,
          //                     height: 2,
          //                     width: 50,
          //                   )
          //                 : Container()
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(
          //   height: 5,
          // ),
          // Container(
          //     height: height * 0.4,
          //     child: tabIndex == 0
          //         ? ListView(
          //             physics: NeverScrollableScrollPhysics(),
          //             children: [
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               CustomText(
          //                 text: "aboutMeBreif".tr,
          //                 color: black,
          //                 fontSize: 14,
          //                 height: 1.785,
          //                 fontWeight: FontWeight.w400,
          //               ),
          //               const SizedBox(
          //                 height: 20,
          //               ),
          //               CustomText(
          //                 text: "interest".tr,
          //                 color: black,
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w400,
          //               ),
          //               const SizedBox(
          //                 height: 20,
          //               ),
          //               Wrap(
          //                   direction: Axis.horizontal,
          //                   spacing: 10.0,
          //                   runSpacing: 5.0,
          //                   children:
          //                       List.generate(interestList.length, (index) {
          //                     return CustomOvalText(
          //                       index: index % 4,
          //                       title: interestList[index],
          //                     );
          //                   })),
          //             ],
          //           )
          //         : tabIndex == 1
          //             ? ListView.separated(
          //                 itemBuilder: (context, index) {
          //                   return const CustomExpertCard();
          //                 },
          //                 separatorBuilder: (context, index) {
          //                   return const SizedBox(
          //                     height: 10,
          //                   );
          //                 },
          //                 itemCount: 10)

          // Container(),
          // Container(
          //       //   padding: EdgeInsets.all(10),
          //   child: ListView.separated(
          //    //   shrinkWrap: true,
          //       padding: EdgeInsets.zero,
          //       //  physics: NeverScrollableScrollPhysics(),
          //       itemCount: 10,
          //       separatorBuilder: (context, index) {
          //         return const SizedBox(
          //           height: 10,
          //         );
          //       },
          //       itemBuilder: (context, index) {
          //       //  return CustomExpertCard();
          //       }),
          // ),

          // : tabIndex == 2
          //     ? ListView.separated(
          //         itemBuilder: (context, index) {
          //           return CustomReviewCard();
          //         },
          //         separatorBuilder: (context, index) {
          //           return const SizedBox(
          //             height: 30,
          //           );
          //         },
          //         itemCount: 10)
          //     : Container()),

          //        Container(
          //child:
          //
          // ListView.separated(itemBuilder: (context, index) {
          //         return SizedBox(
          //           width: width*.5,
          //           child: const CustomExpertCard());
          //        }, separatorBuilder:  (context, index) {return const SizedBox(height: 2,);}, itemCount: 3),),
          //       // Container(),
          //       // Container(
          //       //       //   padding: EdgeInsets.all(10),
          //       //   child: ListView.separated(
          //       //    //   shrinkWrap: true,
          //       //       padding: EdgeInsets.zero,
          //       //       //  physics: NeverScrollableScrollPhysics(),
          //       //       itemCount: 10,
          //       //       separatorBuilder: (context, index) {
          //       //         return const SizedBox(
          //       //           height: 10,
          //       //         );
          //       //       },
          //       //       itemBuilder: (context, index) {
          //       //       //  return CustomExpertCard();
          //       //       }),
          //       // ),
          //       // Padding(
          //       //   padding: EdgeInsets.only(top: height * 0.03),
          //       //   child: Container(
          //       //     child:
          // ListView.separated(
          //       //         itemBuilder: (context, index) {
          //       //           return CustomReviewCard();
          //       //         },
          //       //         separatorBuilder: (context, index) {
          //       //           return const SizedBox(
          //       //             height: 30,
          //       //           );
          //       //         },
          //       //         itemCount: 10),
          //       //   ),
          //       // )
          //     ],
          //   ),
          //  )
        ]),
      ),
    );
  }
}
