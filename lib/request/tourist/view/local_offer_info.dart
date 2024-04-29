import 'dart:math';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen_live.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/request/widgets/local_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_accept_button.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalOfferInfo extends StatefulWidget {
  const LocalOfferInfo(
      {super.key,
      required this.image,
      required this.name,
      required this.price,
      required this.rating,
      required this.tripNumber,
      required this.place, required this.profileId});
  final String image;
  final String name;
  final String profileId;
  final int price, rating, tripNumber;

  final Place place;
  @override
  State<LocalOfferInfo> createState() => _LocalOfferInfoState();
}

class _LocalOfferInfoState extends State<LocalOfferInfo> {
  late double width, height;
  final _offerController = Get.put(OfferController());
    final _profileController = Get.put(ProfileController());
      late Profile? profile;
  void getProfile() async {
    await _profileController.getProfile(context: context,profileId:widget.profileId);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    
     
  }
  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      // animationDuration: Durations.long1,
      length: 3,
      child: Scaffold(
        appBar:  CustomAppBar("profile!.name??"""),
        body: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            toolbarHeight: 300,
            title: Column(
              children: [
                widget.image.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          widget.image,
                        ),
                        radius: 40,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/profile_image.png',
                        ),
                        radius: 50,
                      ),
                const SizedBox(
                  height: 14,
                ),
                CustomText(
                  text: widget.name,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 14,
                ),
                //local details
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //number of tours tile
                    LocalTile(
                      tripNumber: widget.tripNumber,
                      subtitle: 'Tour',
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    const SizedBox(
                      height: 44,
                      child: VerticalDivider(
                        color: tileGreyColor,
                        thickness: 1,
                        indent: 10,
                        width: 0,
                        endIndent: 0,
                        //width: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //review tile
                    LocalTile(
                      tripNumber: widget.rating,
                      isRating: true,
                      subtitle: 'Review ',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 21,
                ),
                //view offer button
                Obx(() {
                  if (_offerController.offerDetails.value.orderStatus ==
                      'ACCEPTED') {
                    return CustomAcceptButton(
                      onPressed: () {
                        Get.to(() => ChatScreenLive(
                              isAjwadi: false,
                              offerController: _offerController,
                              booking:
                                  _offerController.offerDetails.value.booking!,
                              chatId: _offerController
                                  .offerDetails.value.booking!.chatId!,
                              place: widget.place,
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
                                    Get.to(() => ChatScreenLive(
                                          isAjwadi: false,
                                          offerController: _offerController,
                                          booking: offerDetails.booking!,
                                          chatId: offerDetails.booking!.chatId!,
                                          place: widget.place,
                                        ));
                                  }
                                },
                                title: 'chat'.tr,
                                icon: 'chat',
                              ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 47),
                    child: CustomButton(
                      onPressed: () async {
                        // log("CustomButton");
                        var payment =
                            _offerController.offerDetails.value.payment;
                        // log("payment $payment");
                        // log("payment ${payment.runtimeType}");
                        if (payment != null &&
                            payment.isNotEmpty &&
                            // paid
                            _offerController
                                    .offerDetails.value.payment!['payStatus'] ==
                                "paid") {
                          // log("acceptOffer");
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
                          // log("ChatScreenLive 33");
                          Get.back();
                          Get.to(() => ChatScreenLive(
                                isAjwadi: false,
                                offerController: _offerController,
                                booking: _offerController
                                    .offerDetails.value.booking!,
                                chatId: _offerController
                                    .offerDetails.value.booking?.chatId,
                                place: widget.place,
                              ));
                        }
                      },
                      italic: AppUtil.rtlDirection(context) ? false : true,
                      title: (_offerController.offerDetails.value.payment !=
                                  null &&
                              _offerController
                                  .offerDetails.value.payment!.isNotEmpty &&
                              //paid
                              _offerController.offerDetails.value
                                      .payment!['payStatus'] ==
                                  "paid")
                          ? "acceptOffer".tr
                          : "showOffer".tr,

                      // SvgPicture.asset("assets/icons/user-plus.svg"),
                    ),
                  );
                }),
              ],
            ),
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: black,
              unselectedLabelColor: almostGrey,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 14),
              tabs: [
                Tab(
                  text: "About",
                ),
                Tab(
                  text: "Expert",
                ),
                Tab(
                  text: "Reviews",
                ),
              ],
            ),
          ),
          body: const TabBarView(children: [
            CustomText(text: 'about'),
            CustomText(text: 'Expert'),
            CustomText(text: 'Review')
          ]),
        ),
      ),
    );
  }
}
