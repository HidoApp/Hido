import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/model/local_trip.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/ajwadi/view/Itinerary_screen.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen.dart';
import 'package:ajwad_v4/services/view/widgets/itenrary_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_outlined_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timeago/timeago.dart' as timeago;

class LocalTripCard extends StatefulWidget {
  const LocalTripCard({
    Key? key,
    required this.trip,
    this.isPast=false
  }) : super(key: key);

  final LocalTrip trip;
  final bool isPast;


  @override
  State<LocalTripCard> createState() => _LocalTripCardState();
}

class _LocalTripCardState extends State<LocalTripCard> {
  late ExpandedTileController _controller;
  String address = '';

  @override
  void initState() {
    super.initState();

    _controller = ExpandedTileController(isExpanded: false);

    String latitudeStr = widget.trip.booking?.coordinates?.latitude ?? '';
    String longitudeStr = widget.trip.booking?.coordinates?.longitude ?? '';

    if (latitudeStr.isNotEmpty && longitudeStr.isNotEmpty) {
      try {
        double latitude = double.parse(latitudeStr);
        double longitude = double.parse(longitudeStr);
        getAddressFromCoordinates(latitude, longitude);
      } catch (e) {
        print("Error parsing coordinates: $e");
      }
    } else {
      print("Invalid coordinates: latitude or longitude is empty");
    }
  }

  void getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        address =
            "${placemark.postalCode}, ${placemark.subLocality}, ${placemark.country}";
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      // height: _controller.isExpanded ? width * 0.65 : width * 0.381,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Adjust the radius as needed

        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 13,
            offset: Offset(-5, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CustomText(
              text: AppUtil.formatBookingDate(
                  context, widget.trip.booking!.date!),
              color: Color(0xFF9392A0),
              fontSize: 12,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ImageCacheWidget(
                    image: widget.trip.place!.image.isNotEmpty
                        ? widget.trip.place!.image.first
                        : 'assets/images/Placeholder.png',
                    height: width * 0.12,
                    width: width * 0.12,
                  )),
              SizedBox(width: width * 0.02),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ? widget.trip.place!.nameAr
                          : widget.trip.place!.nameEn,
                      color: black,
                      fontSize: 16,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      text:
                          '${AppUtil.rtlDirection2(context) ? "الحجز من" : 'Booking by'} : ${widget.trip.booking!.touristName}',
                      color: Color(0xFF41404A),
                      fontSize: 12,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
              if (widget.trip.booking!.orderStatus != "FINISHED"|| !widget.isPast) ...[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(ChatScreen(chatId: widget.trip.booking!.chatId));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      minimumSize: Size(81, 32), // Width and height
                    ),
                    child: CustomText(
                      text: 'chat'.tr,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            ],
          ),
          const Divider(
            color: lightGrey,
          ),
          //                              // SizedBox(height: width * 0.03),
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: ExpandedTile(
              contentseparator: 12,
              trailing: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: width * 0.046,
              ),
              disableAnimation: true,
              trailingRotation: 180,
              onTap: () {
                // print(widget.request.date);
                setState(() {});
              },
              title: !_controller.isExpanded
                  ? CustomText(
                      text: 'seeMore'.tr,
                      color: Color(0xFF36B268),
                      fontSize: 13,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    )
                  : Text(''),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItineraryTile(
                    title:
                        ' ${AppUtil.formatStringTimeWithLocale(context, widget.trip.booking!.timeToGo ?? '')} -  ${AppUtil.formatStringTimeWithLocale(context, widget.trip.booking!.timeToReturn ?? '')}',
                    image: "assets/icons/timeGrey.svg",
                  ),
                  //SizedBox(height: width * 0.025),

                  if (address.isNotEmpty) ...[
                    SizedBox(height: 8),
                    ItineraryTile(
                      title: address,
                      image: 'assets/icons/map_pin.svg',
                      imageUrl: AppUtil.getLocationUrl(
                          widget.trip.booking!.coordinates),
                      line: true,
                    ),
                  ],
                  // SizedBox(height: width * 0.025),
                  SizedBox(height: 8),

                  ItineraryTile(
                    title: "${widget.trip.booking!.guestNumber} ${"guests".tr}",
                    image: "assets/icons/guests.svg",
                  ),

                  SizedBox(height: 11),

                  _controller.isExpanded
                      ? CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? 'القليل'
                              : 'See less',
                          color: Color(0xFF36B268),
                          fontSize: 13,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontWeight: FontWeight.w500,
                        )
                      : Text(''),
                ],
              ),
              controller: _controller,
              theme: const ExpandedTileThemeData(
                leadingPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                headerPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                headerSplashColor: Colors.transparent,
                headerColor: Colors.transparent,
                contentBackgroundColor: Colors.transparent,
              ),
            ),
          ),
          // const Spacer(),
          // const Divider(color: lightGrey),
          //const Spacer(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          // Obx(
          //   () => widget.requestController.isRequestRejectLoading.value &&
          //           widget.index ==
          //               widget.requestController.requestIndex.value
          //       ? const CircularProgressIndicator.adaptive()
          //       : SizedBox(
          //           height: width * 0.08,
          //           width: width * 0.4,
          //           child: CustomOutlinedButton(
          //             buttonColor: colorRed,
          //             onTap: widget.onReject,
          //             title: 'reject'.tr,
          //           ),
          //         ),
          // ),
          // SizedBox(
          //   height: width * 0.08,
          //   width: width * 0.4,
          // child: CustomButton(
          //   raduis: 4,
          //   onPressed: () {
          //     Get.to(() => AddItinerary(requestId: widget.request.id!));
          //   },
          //   title: 'accept'.tr,
          // ),
          // ),
          // ],
          // ),
        ],
      ),
    );
  }
}
