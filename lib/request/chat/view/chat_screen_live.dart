import 'dart:developer';
import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/controllers/chat_controller.dart';
import 'package:ajwad_v4/request/chat/view/widgets/show_request_widget.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/check_container_widget.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/total_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../services/view/review_request_screen.dart';
import '../../../widgets/custom_app_bar.dart';

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
        appBar: CustomAppBar(
          'showOffer'.tr,
        ),
        body: SafeArea(
          child: Obx(
            () => widget.offerController!.isOfferLoading.value
                ? CircularProgressIndicator.adaptive()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //const SizedBox(height: 10),

                      // Padding(padding: const EdgeInsets.only(left: 90)),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 0.90 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            isDetailsTapped = !isDetailsTapped;
                                          });
                                        },
                                        title: CustomText(
                                          text: 'tripDetails'.tr,
                                          fontSize: width * 0.044,
                                          fontFamily: 'HT Rakik',
                                          fontWeight: FontWeight.w500,
                                          color: black,
                                          textAlign:
                                              AppUtil.rtlDirection2(context)
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                        ),
                                        trailing: Icon(
                                          isDetailsTapped
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: black,
                                          size: 24,
                                        ),
                                      ),
                                      if (isDetailsTapped)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                        '${AppUtil.formatBookingDate(context, widget.booking!.date!)}',
                                                    color: starGreyColor,
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
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
                                                    text: AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'من ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)} إلى ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)} '
                                                        : 'Pick up: ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)}, Drop off: ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)}',
                                                    color: starGreyColor,
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
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
                                                    color: starGreyColor,
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  RepaintBoundary(
                                                    child: SvgPicture.asset(
                                                      'assets/icons/unselected_${widget.booking?.vehicleType!}_icon.svg',
                                                      width: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    text: widget
                                                        .booking!.vehicleType!,
                                                    color: starGreyColor,
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 6),
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
                              if (widget.chatId == null &&
                                  (!widget.isAjwadi)) ...[
                                Column(
                                  children: [
                                    CheckContainerWidget(
                                        offerController:
                                            widget.offerController),

                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 358,
                                      child: CustomText(
                                        text: 'notePrice'.tr,
                                        color: starGreyColor,
                                        fontSize: width * 0.029,
                                        fontFamily: AppUtil.SfFontType(context),
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),

                                    // SizedBox(height: 100),

                                    //  const AvailableContainerWidget(),
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          width: 0.24,
                                                          strokeAlign: BorderSide
                                                              .strokeAlignCenter,
                                                          color:
                                                              Color(0xFF979797),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (widget.chatId == null && (!widget.isAjwadi)) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: Column(
                            children: [
                              TotalWidget(
                                offerController: widget.offerController,
                                place: widget.place!,
                              ),

                              Obx(
                                () => IgnorePointer(
                                  ignoring: widget
                                      .offerController!.scheduleState.value,
                                  child: CustomButton(
                                    onPressed: () {
                                      if (widget.offerController!
                                              .updateScheduleList !=
                                          null) {
                                        for (var item in widget.offerController!
                                            .updateScheduleList) {}
                                      } else {
                                        print(
                                            'The schedule list is null or does not exist.');
                                      }
                                      Get.to(() => ReviewRequest(
                                            booking: widget.booking,
                                            scheduleList: widget.offerController
                                                ?.offerDetails.value.schedule,
                                            offerController:
                                                widget.offerController,
                                            place: widget.place!,
                                          ));

                                      AmplitudeService.amplitude
                                          .track(BaseEvent(
                                        'Click on "Review Request" button',
                                      ));
                                    },
                                    buttonColor: widget.offerController!
                                            .scheduleState.value
                                        ? colorlightGreen
                                        : colorGreen,
                                    borderColor: widget.offerController!
                                            .scheduleState.value
                                        ? colorlightGreen
                                        : colorGreen,
                                    title: 'ReviewRequest'.tr,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              CustomButton(
                                  onPressed: () {
                                    Get.until((route) =>
                                        Get.currentRoute == '/FindAjwady');

                                    AmplitudeService.amplitude.track(BaseEvent(
                                      'Return to Offers',
                                    ));
                                  },
                                  title: AppUtil.rtlDirection2(context)
                                      ? 'عودة للعروض'
                                      : 'Return to Offers'.tr,
                                  buttonColor: Colors.white.withOpacity(0.3),
                                  borderColor: Colors.white.withOpacity(0.3),
                                  textColor: black),

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

                              //
                              //

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
                              //
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

                              const SizedBox(height: 4)
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      
    );
  }
}
