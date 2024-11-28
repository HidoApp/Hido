import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/AdventureTicketData.dart';
import 'package:ajwad_v4/profile/widget/cancleSheet.dart';
import 'package:ajwad_v4/profile/widget/event_ticket_data.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/profile/widget/HospitalityTicketData.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';

class TicketDetailsScreen extends StatefulWidget {
  TicketDetailsScreen(
      {Key? key,
      this.booking,
      this.icon,
      this.bookTypeText,
      this.hospitality,
      this.adventure,
      this.event,
      this.isTour = false
      // this.femaleGuestNum,
      // this.maleGuestNum
      })
      : super(key: key);

  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;
  final Hospitality? hospitality;
  final Adventure? adventure;
  final Event? event;
  bool? isTour;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  // final int? maleGuestNum;
  // final _offerController = Get.put(OfferController());
  final _touristExploreController = Get.put(TouristExploreController());
  // final _hospitalityController = Get.put(HospitalityController());
  final _profileController = Get.put(ProfileController());

  Booking? profileBooking;
  void getBooking() async {
    profileBooking = await _touristExploreController.getTouristBookingById(
        context: context, bookingId: widget.booking?.id ?? "");
    if (widget.booking!.bookingType == 'hospitality' ||
        widget.booking!.bookingType == 'adventure') {
      getProfile();
    }
  }

  void getProfile() async {
    await _profileController.getProfile(
        context: context, profileId: profileBooking!.localId ?? '');
  }

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      return;
    }
    if (widget.hospitality == null &&
        widget.adventure == null &&
        widget.event == null) {
      if (widget.booking!.bookingType != 'event') {
        getBooking();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log("lkkk");
    // log(widget.booking!.hasPayment.toString());
    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: lightGreyBackground,
      appBar: CustomAppBar(
        'myTickets'.tr,
        // backgroundColor: Colors.red,
      ),
      //CustomAppBar('myTickets'.tr),
      body: SingleChildScrollView(
        child: Container(
          color: lightGreyBackground, // Background color for the Container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: width * 0.051),

              if (widget.adventure == null &&
                  widget.event == null &&
                  widget.hospitality == null &&
                  !widget.isTour!) ...[
                if (widget.booking!.orderStatus == 'ACCEPTED') ...[
                  if (widget.booking!.bookingType != 'event')
                    Obx(
                      () => Skeletonizer(
                        enabled: _touristExploreController
                                .isBookingByIdLoading.value ||
                            _profileController.isProfileLoading.value,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.041),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.booking!.bookingType ==
                                  'hospitality') {
                                if (profileBooking!.localId!.isNotEmpty) {
                                  Get.to(
                                    () => ServicesLocalInfo(
                                      isHospitality: true,
                                      profileId: profileBooking?.localId ?? '',
                                      isFromTicket: true,
                                    ),
                                  );
                                }
                              } else if (widget.booking!.bookingType ==
                                  'adventure') {
                                if (profileBooking!.localId!.isNotEmpty) {
                                  Get.to(
                                    () => ServicesLocalInfo(
                                        profileId:
                                            profileBooking?.localId ?? '',
                                        isFromTicket: true),
                                  );
                                }
                              } else {
                                Get.to(() => LocalOfferInfo(
                                      image: profileBooking?.offers?.first.user!
                                              .profile.image ??
                                          "",
                                      name: profileBooking?.offers?.first.user!
                                              .profile.name ??
                                          "",
                                      price: int.parse(
                                          profileBooking?.cost ?? "0"),
                                      rating: profileBooking?.offers?.first
                                              .user!.profile.tourRating
                                              .toDouble() ??
                                          0.0,
                                      tripNumber: profileBooking?.offers?.first
                                              .user!.profile.tourNumber ??
                                          0,
                                      place: null,
                                      userId:
                                          profileBooking!.offers!.first.userId,
                                      profileId:
                                          profileBooking!.offers!.first.userId,
                                    ));
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: width * 0.041,
                                    horizontal: width * 0.051),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    //border: Border.all(color: lightGrey),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16)),
                                height: 70,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: profileBooking?.offers?.first
                                                        .user!.profile.image !=
                                                    null ||
                                                _profileController
                                                        .profile.profileImage !=
                                                    null
                                            ? ImageCacheWidget(
                                                height: width * 0.093,
                                                width: width * 0.093,
                                                image: (widget.booking!
                                                                .bookingType ==
                                                            'hospitality' ||
                                                        widget.booking!
                                                                .bookingType ==
                                                            'adventure')
                                                    ? _profileController.profile
                                                            .profileImage ??
                                                        ''
                                                    : profileBooking
                                                            ?.offers
                                                            ?.first
                                                            .user!
                                                            .profile
                                                            .image ??
                                                        "",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/profile_image.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.0205,
                                    ),
                                    CustomText(
                                      fontFamily: AppUtil.SfFontType(context),
                                      fontSize: width * 0.038,
                                      fontWeight: FontWeight.w500,
                                      text: widget.booking!.bookingType ==
                                                  'hospitality' ||
                                              widget.booking!.bookingType ==
                                                  'adventure'
                                          ? AppUtil.capitalizeFirstLetter(
                                              _profileController.profile.name ??
                                                  "Name")
                                          : AppUtil.capitalizeFirstLetter(
                                              profileBooking?.offers?.first
                                                      .user!.profile.name ??
                                                  "Name"),
                                    ),
                                    // const Spacer(),
                                    // SizedBox(
                                    //   width: width * 0.233,
                                    //   child: CustomButton(
                                    //     title: 'chat'.tr,
                                    //     onPressed: () {},
                                    //   ),
                                    // )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: width * 0.03,
                  ),
                ]
              ],
              Align(
                alignment: Alignment.topCenter,
                child: TicketWidget(
                  width: width * 0.92,
                  height: height * 0.53,
                  isCornerRounded: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 23),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: getBookingTypeWidget(context, widget.bookTypeText!),

                  //TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText,),
                ),
              ),
              // const Expanded(child: SizedBox()), // Takes up remaining space
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.adventure == null &&
                widget.event == null &&
                widget.hospitality == null &&
                !widget.isTour!) ...[
              if (widget.booking!.orderStatus == 'ACCEPTED' &&
                  widget.booking!.hasPayment == true) ...[
                CustomButton(
                  onPressed: () {
                    Get.bottomSheet(
                        isScrollControlled: true,
                        CancelSheet(
                            bookId: widget.booking!.id ?? '',
                            type: widget.booking!.bookingType ?? ''));

                    AmplitudeService.amplitude.track(BaseEvent(
                      'Click on Cancel booking ',
                    ));
                  },

                  // },
                  title: 'CancelBooking'.tr,
                  buttonColor:
                      lightGreyBackground, // Set the button color to transparent white
                  textColor: colorRed,
                  borderColor: colorRed,
                  // Set the text color to red
                ),
              ]
            ],
          ],
        ),
      ),
    );
  }

  Widget getBookingTypeWidget(BuildContext context, String bookingType) {
    switch (bookingType) {
      case 'place':
      case 'جولة':
        return TicketData(
            booking: widget.booking!,
            icon: widget.icon,
            bookTypeText: widget.bookTypeText);

      case 'adventure':
      case 'نشاط':
        if (widget.adventure == null) {
          return AdventureTicketData(
              booking: widget.booking!,
              icon: widget.icon,
              bookTypeText: widget.bookTypeText);
        } else {
          return AdventureTicketData(
              adventure: widget.adventure,
              icon: widget.icon,
              bookTypeText: widget.bookTypeText);
        }

      case 'hospitality':
      case 'ضيافة':
        if (widget.hospitality == null) {
          return HostTicketData(
              booking: widget.booking!,
              icon: widget.icon,
              bookTypeText: widget.bookTypeText);
        } else {
          return HostTicketData(
              hospitality: widget.hospitality,
              icon: widget.icon,
              bookTypeText: widget.bookTypeText);
        }

      case 'event':
      case 'فعالية':
        if (widget.event == null) {
          return EventTicketData(
              booking: widget.booking,
              icon: widget.icon,
              bookTypeText: widget.bookTypeText);
        } else {
          return EventTicketData(
              event: widget.event,
              icon: widget.icon,
              bookTypeText: widget.bookTypeText);
        }
      default:
        return TicketData(
            booking: widget.booking!,
            icon: widget.icon,
            bookTypeText: widget.bookTypeText);
    }
  }
}

class TicketData extends StatelessWidget {
  final Booking booking;
  final SvgPicture? icon;
  final String? bookTypeText;

  TicketData({
    Key? key,
    required this.booking,
    this.icon,
    this.bookTypeText,
  }) : super(key: key);
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 117,
        left: AppUtil.rtlDirection2(context)
            ? MediaQuery.of(context).size.width * 0.35
            : null,
        right: AppUtil.rtlDirection2(context)
            ? null
            : MediaQuery.of(context).size.width * 0.35,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CustomText(
              text: 'Copied'.tr,
              color: Colors.white,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: booking.id!.substring(0, 7)));
                  _showOverlay(context);
                },
                child: SvgPicture.asset(
                  'assets/icons/Summary.svg',
                  width: 20,
                  height: 20,
                )),
            const SizedBox(width: 8),
            CustomText(
              text: '#${booking.id!.substring(0, 7)}',
              color: const Color(0xFFB9B8C1),
              fontSize: 13,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "BookingDetails".tr,
              color: black,
              fontSize: width * 0.044,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            Row(
              children: [
                RepaintBoundary(
                  child: icon!,
                ),
                CustomText(
                  text:
                      ' ${AppUtil.getBookingTypeText(context, bookTypeText!)}',
                  color: black,
                  fontSize: width * 0.038,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'date'.tr,
              textAlign: TextAlign.center,
              color: starGreyColor,
              fontSize: width * 0.035,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            const SizedBox(height: 5),
            CustomText(
              //'Fri 24 May 2024',
              text: AppUtil.formatBookingDate(context, booking.date),
              textAlign: TextAlign.center,
              color: black,
              fontSize: width * 0.038,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'pickUp1'.tr,
                  textAlign: TextAlign.center,
                  color: const Color(0xFF9392A0),
                  fontSize: 14,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
                const SizedBox(height: 5),
                CustomText(
                  text: formatTimeWithLocale(context, booking.timeToGo),
                  color: black,
                  fontSize: width * 0.038,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ],
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomText(
                      text: 'dropOff1'.tr,
                      color: starGreyColor,
                      fontSize: width * 0.035,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomText(
                      //'3:30 PM',
                      text: formatTimeWithLocale(context, booking.timeToReturn),
                      color: black,
                      fontSize: width * 0.038,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'numberOfPeople'.tr,
              textAlign: TextAlign.center,
              color: starGreyColor,
              fontSize: width * 0.035,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '${booking.guestNumber ?? 0} ${'guests'.tr}',
                  textAlign: TextAlign.center,
                  color: black,
                  fontSize: width * 0.038,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
                // const SizedBox(width: 4),
                // Text(
                //     'Per',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         color: Color(0xFFB9B8C1),
                //         fontSize: 15,
                //         fontFamily: 'SF Pro',
                //         fontWeight: FontWeight.w500,
                //         height: 0,
                //     ),
                // ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const DottedSeparator(
          color: almostGrey,
          height: 1,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'cost'.tr,
                    textAlign: TextAlign.center,
                    color: starGreyColor,
                    fontSize: width * 0.038,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        // '380.00',
                        text: booking.cost.toString(),
                        //booking.place!.price.toString(),
                        textAlign: TextAlign.center,
                        color: black,
                        fontSize: width * 0.044,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        text: AppUtil.rtlDirection2(context) ? 'ريال' : 'SAR',
                        textAlign: TextAlign.center,
                        color: black,
                        fontSize: width * 0.035,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return DateFormat('E dd MMM yyyy').format(dateTime);
    }
  }

  String formatTimeWithLocale(BuildContext context, String dateTimeString) {
    DateTime time = DateFormat("HH:mm").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }

//   Widget getBookingTypeWidget(BuildContext context, String bookingType){
//       switch (bookingType) {
//       case 'place':
//         return TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);

//       case 'adventure':
//         return TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);
//       case 'hospitality':
//         return HostTicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);

//       default:
//         return TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);

//     }
// }
}
