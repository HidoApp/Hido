import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen_live.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../explore/tourist/model/booking.dart' as book;

import 'package:ajwad_v4/request/tourist/view/about_screen.dart';
import 'package:ajwad_v4/request/tourist/view/expert_screen.dart';
import 'package:ajwad_v4/request/tourist/view/reviews_screen.dart';
import 'package:ajwad_v4/request/widgets/local_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_accept_button.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../chat/controllers/chat_controller.dart';
import '../../chat/model/chat_model.dart';
import '../../chat/view/chat_screen.dart';

class LocalOfferInfo extends StatefulWidget {
  const LocalOfferInfo(
      {super.key,
      required this.image,
      required this.name,
      required this.price,
      required this.rating,
      required this.tripNumber,
      this.place,
      required this.userId,
      required this.profileId,
      this.booking,
      this.fromService = false});
  final String image;
  final String name;
  final String profileId;
  final String userId;
  final int price, tripNumber;
  final double rating;
  final bool fromService;
  final book.Booking? booking;

  final Place? place;
  @override
  State<LocalOfferInfo> createState() => _LocalOfferInfoState();
}

class _LocalOfferInfoState extends State<LocalOfferInfo> {
  late double width, height;
  final _offerController = Get.put(OfferController());
  final _profileController = Get.put(ProfileController());
  final chatController = Get.put(ChatController());
  late ChatMessage? message;
  final getStorage = GetStorage();
  final RequestController _RequestController = Get.put(RequestController());
  late Profile? profile;
  void getProfile() async {
    await _profileController.getProfile(
        context: context, profileId: widget.profileId);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    log(_offerController.acceptedOffer.value.orderStatus ?? "s");

    getProfile();
    // AmplitudeService.initializeAmplitude();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      //animationDuration: Durations.long1
      //,
      length: widget.fromService ? 2 : 3,
      child: Obx(
        () => Skeletonizer(
          enabled: _offerController.isOfferLoading.value ||
              _profileController.isProfileLoading.value,
          // ignoreContainers: true,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar('localProfile'.tr),
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
                      fontSize: width * 0.044,
                      fontFamily: 'HT Rakik',
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
                          subtitle: 'tour'.tr,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        const SizedBox(
                          height: 44,
                          child: VerticalDivider(
                            color: graySubSmallText,
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
                          // tripNumber: widget.rating,
                          tripRate: widget.rating,
                          isRating: true,
                          subtitle: 'review'.tr,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    //view offer button
                    if (widget.place != null)
                      if (!widget.fromService)
                        Obx(() {
                          if (_offerController
                                      .acceptedOffer.value.orderStatus ==
                                  'ACCEPTED' ||
                              widget.booking?.orderStatus == 'ACCEPTED' &&
                                  widget.place!.booking != null) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: CustomAcceptButton(
                                onPressed: () async {
                                  AmplitudeService.amplitude.track(BaseEvent(
                                    'Click on "Chat" button',
                                  ));

                                  Get.to(() => ChatScreen(
                                      chatId: widget.booking?.chatId,
                                      booking2: widget.booking));
                                },
                                title: 'chat'.tr,
                                icon: 'chat',
                              ),
                            );
                          }
                          if (_offerController.isAcceptOfferLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }

                          if (_offerController
                                      .acceptedOffer.value.orderStatus ==
                                  'ACCEPTED' ||
                              widget.booking?.orderStatus == 'ACCEPTED' &&
                                  widget.place!.booking != null) {
                            return Center(
                              child: SizedBox(
                                width: width * 0.5,
                                child: _offerController.isOfferLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: CustomAcceptButton(
                                          onPressed: () async {
                                            OfferDetails? offerDetails =
                                                await _offerController
                                                    .getOfferById(
                                                        context: context,
                                                        offerId:
                                                            _offerController
                                                                .offerDetails
                                                                .value
                                                                .id!);
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
                                                    offerController:
                                                        _offerController,
                                                    booking:
                                                        offerDetails.booking!,
                                                    chatId: offerDetails
                                                        .booking!.chatId!,
                                                    place: widget.place,
                                                  ));
                                            }
                                          },
                                          title: 'chat'.tr,
                                          icon: 'chat',
                                        ),
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
                                    _offerController.offerDetails.value
                                            .payment!['payStatus'] ==
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
                                  Get.back();
                                  AmplitudeService.amplitude.track(BaseEvent(
                                    'View Tour Activities',
                                  ));
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
                              italic:
                                  AppUtil.rtlDirection(context) ? false : true,
                              title: (_offerController
                                              .offerDetails.value.payment !=
                                          null &&
                                      _offerController.offerDetails.value
                                          .payment!.isNotEmpty &&
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
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: colorGreen,
                  unselectedLabelColor: colorDarkGrey,
                  dividerColor: const Color(0xFFB9B8C1),
                  overlayColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 255, 255, 255)),
                  indicatorPadding: const EdgeInsets.only(top: 12),
                  tabs: [
                    Tab(
                      text: "aboutMe".tr,
                    ),
                    if (!widget.fromService)
                      Tab(
                        text: "expertise".tr,
                      ),
                    Tab(
                      text: "reviews".tr,
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                const AboutScreen(),
                ExpertScreen(
                  profileController: _profileController,
                ),
                ReviewsScreen(
                  profileId: widget.userId,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
