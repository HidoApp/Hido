import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/view/edit_adventure.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/view/edit_event.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/share_sheet.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';
import 'package:ajwad_v4/services/view/widgets/event_booking.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_aleart_widget.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_succes_dialog.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';

import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';

import 'package:ajwad_v4/services/view/widgets/images_services_widget.dart';

import 'package:ajwad_v4/services/view/widgets/service_profile_card.dart';

import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/floating_booking_button.dart';

import 'package:intl/intl.dart' hide TextDirection;

class LocalEventDetails extends StatefulWidget {
  const LocalEventDetails({
    Key? key,
    required this.eventId,
    this.isLocal = false,
    this.address = '',
    this.isHasBooking = false,
  }) : super(key: key);

  final String eventId;
  final bool isLocal;
  final String address;
  final bool isHasBooking;

  @override
  State<LocalEventDetails> createState() => _LocalEventDetailsState();
}

late double width, height;

class _LocalEventDetailsState extends State<LocalEventDetails> {
  final _eventController = Get.put(EventController());
  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  List<DateTime> avilableDate = [];
  String address = '';
  var locLatLang = const LatLng(24.691846000000012, 46.68552199999999);

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/pin_marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  
  late Event? event;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  initializeDateFormatting(); //very important
     getEventById();
    addCustomIcon();
  }

  void getEventById() async {
    event = (await _eventController.getEventById(
        context: context, id: widget.eventId));
    

    for (var day in event!.daysInfo!) {
      print(day.startTime);
    
     if(AppUtil.isDateTimeBefore24Hours(day.startTime))
      avilableDate.add(
        DateTime.parse(
          day.startTime.substring(0, 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Obx(
      () => _eventController.isEventByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(""),
              body: Center(child: CircularProgressIndicator.adaptive()),
            )
          : Scaffold(
              bottomNavigationBar: !widget.isLocal
                  ? SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(top: width * 0.025),
                        child: BottomEventBooking(
                          event: event!,
                          avilableDate: avilableDate,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          right: 17, left: 17, bottom: width * 0.085),
                      child: Row(
                        children: [
                          CustomText(
                            text: "pricePerPerson".tr,
                            fontSize: width * 0.038,
                            color: colorDarkGrey,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                          ),
                          CustomText(
                            text: " /  ",
                            fontWeight: FontWeight.w900,
                            fontSize: width * 0.043,
                            color: Colors.black,
                          ),
                          CustomText(
                            text: '${event!.price} ${'sar'.tr}',
                            fontWeight: FontWeight.w900,
                            fontSize: width * 0.043,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                          ),
                        ],
                      ),
                    ),
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              persistentFooterAlignment: AlignmentDirectional.bottomCenter,
              body: SingleChildScrollView(
                  child: Stack(children: [
                Column(
                  children: [
                    // images widget on top of screen
                    GestureDetector(
                      onTap: () {
                        Get.to(ViewTripImages(
                          tripImageUrl: event!.image!,
                          fromNetwork: true,
                        ));
                      },
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                            height: height * 0.3,
                            viewportFraction: 1,
                            onPageChanged: (i, reason) {
                              setState(() {
                                _currentIndex = i;
                              });
                            }),
                        itemCount: event!.image!.length,
                        itemBuilder: (context, index, realIndex) {
                          return ImagesServicesWidget(
                            image: event!.image![index],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        children: [
                          Align(
                              alignment: AppUtil.rtlDirection2(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: AppUtil.rtlDirection2(context)
                                    ? event!.nameAr ?? ''
                                    : event!.nameEn ?? '',
                                fontSize: width * 0.07,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                              )),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: AppUtil.rtlDirection2(context)
                                    ? const EdgeInsets.only(right: 1)
                                    : const EdgeInsets.only(left: 1),
                                child: SvgPicture.asset(
                                  "assets/icons/locationHos.svg",
                                  color: starGreyColor,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              CustomText(
                                text: !widget.isLocal
                                    ? _eventController.address.value
                                    :AppUtil.rtlDirection2(context)
                                           ? '${event!.regionAr}, ${widget.address}'
                                            : '${event!.regionEn}, ${widget.address}',
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.01,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: AppUtil.rtlDirection2(context)
                                    ? const EdgeInsets.only(right: 2)
                                    : const EdgeInsets.only(left: 2),
                                child: SvgPicture.asset(
                                  'assets/icons/grey_calender.svg',
                                  color: starGreyColor,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              CustomText(
                                text: AppUtil.formatSelectedDaysInfo(
                                    event!.daysInfo!, context),
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.01,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/timeGrey.svg",
                                color: starGreyColor,
                              ),
                              SizedBox(
                                width: width * 0.011,
                              ),
                              //time
                              CustomText(
                                text:
                                    '${AppUtil.formatTimeOnly(context, event!.daysInfo!.first.startTime)} -  ${AppUtil.formatTimeOnly(context, event!.daysInfo!.first.endTime)}',
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          SizedBox(
                            height: width * 0.012,
                          ),
                          Align(
                              alignment: AppUtil.rtlDirection2(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: "about".tr,
                                fontSize: width * 0.046,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'HT Rakik',
                              )),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Align(
                            alignment: AppUtil.rtlDirection2(context)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: isExpanded
                                  ? const BoxConstraints()
                                  : BoxConstraints(maxHeight: width * 0.09),
                              child: CustomText(
                                textDirection: AppUtil.rtlDirection(context)
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                textOverflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.clip,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                color: Color(0xFF9392A0),
                                fontSize: width * 0.035,
                                text: AppUtil.rtlDirection2(context)
                                    ? event!.descriptionAr ?? ''
                                    : event!.descriptionEn ?? '',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.012,
                          ),
                          isExpanded
                              ? Align(
                                  alignment: AppUtil.rtlDirection2(context)
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => isExpanded = false);
                                    },
                                    child: CustomText(
                                      text: AppUtil.rtlDirection2(context)
                                          ? "القليل"
                                          : "Show less",
                                      color: blue,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: AppUtil.rtlDirection2(context)
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => isExpanded = true),
                                    child: CustomText(
                                      text: "readMore".tr,
                                      color: blue,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          const Divider(
                            color: lightGrey,
                          ),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Align(
                              alignment: !AppUtil.rtlDirection(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: !widget.isLocal
                                    ? "whereWeWillBe".tr
                                    : AppUtil.rtlDirection2(context)
                                        ? 'الموقع'
                                        : 'Location',
                                fontSize: width * 0.046,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'HT Rakik',
                              )),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: almostGrey.withOpacity(0.2),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(width * 0.051)),
                                ),
                                height: width * 0.5,
                                width: width * 0.9,
                                child: GoogleMap(
                                  scrollGesturesEnabled: false,
                                  zoomControlsEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: event == null
                                        ? locLatLang
                                        : LatLng(
                                            double.parse(
                                                event!.coordinates!.latitude!),
                                            double.parse(event!
                                                .coordinates!.longitude!)),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId("marker1"),
                                      position: event == null
                                          ? locLatLang
                                          : LatLng(
                                              double.parse(event!
                                                  .coordinates!.latitude!),
                                              double.parse(event!
                                                  .coordinates!.longitude!)),
                                      draggable: true,
                                      onDragEnd: (value) {
                                        // value is the new position
                                      },
                                      icon: markerIcon,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (widget.isLocal) ...[
                            SizedBox(
                              height: width * 0.028,
                            ),
                            const Divider(
                              color: lightGrey,
                            ),
                            SizedBox(
                              height: width * 0.038,
                            ),
                          ],
                          if (!widget.isLocal) ...[
                            SizedBox(
                              height: width * 0.025,
                            ),
                            const Divider(
                              color: lightGrey,
                            ),
                            SizedBox(
                              height: width * 0.05,
                            ),
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  const CustomPloicySheet(),
                                );
                              },
                              child: Align(
                                  alignment: !AppUtil.rtlDirection(context)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: "cancellationPolicy".tr,
                                            fontSize: width * 0.046,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(
                                            height: width * 0.01,
                                          ),
                                          SizedBox(
                                            width: width * 0.8,
                                            child: CustomText(
                                              text:
                                                  "cancellationPolicyBreifAdventure"
                                                      .tr,
                                              fontSize: width * 0.03,
                                              fontWeight: FontWeight.w400,
                                              maxlines: 2,
                                              color: tileGreyColor,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: tileGreyColor,
                                        size: width * 0.046,
                                      )
                                    ],
                                  )),
                            ),
                            const Divider(
                              color: lightGrey,
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
                if (!widget.isLocal)
                  Positioned(
                    top: height * 0.066,
                    right: AppUtil.rtlDirection2(context)
                        ? width * 0.82
                        : width * 0.072,
                    child: Container(
                        width: 35,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20000000298023224),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icons/white_bookmark.svg",
                          height: 28,
                        )),
                  ),
                Positioned(
                  top: height * 0.06,
                  left: AppUtil.rtlDirection2(context)
                      ? width * 0.82
                      : width * 0.06,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        textDirection: AppUtil.rtlDirection2(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        size: 20,
                        color: Colors.white),
                    onPressed: () => Get.back(),
                    color: Colors.white,
                  ),
                ),
                if (widget.isLocal)
                  Positioned(
                      top: height * 0.066,
                      right: AppUtil.rtlDirection2(context)
                          ? width * 0.82
                          : width * 0.072,
                      child: GestureDetector(
                          onTap: widget.isHasBooking
                              ? () async {
                                 showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                
                  
                );
              },
            );
         
                                }
                              : () {
                                  Get.to(EditEvent(eventObj: event!));
                                },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(0.20000000298023224),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/editPin.svg',
                              height: 28,
                              color: Colors.white,
                            ),
                          ))),
                // Positioned(
                //     top: height * 0.265,
                //     right: width * 0.1,
                //     left: width * 0.1,
                //     // local profile
                //     child: ServicesProfileCard(
                //       onTap: () {
                //         Get.to(() => ServicesLocalInfo(profileId: event!.id));
                //       },
                //       image: event!.user!.profileImage ?? '',
                //       name: event!.user!.name ?? '',
                //     )),
                //indicator
                Positioned(
                  top: height * 0.22,
                  left: width * 0.44,

                  // left: width * 0.36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: event!.image!.map((imageUrl) {
                      int index = event!.image!.indexOf(imageUrl);
                      return Container(
                        width: width * 0.025,
                        height: width * 0.025,
                        margin: EdgeInsets.symmetric(
                            vertical: width * 0.025, horizontal: width * 0.005),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? event!.image!.length == 1
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white
                              : Colors.white.withOpacity(0.8),
                          boxShadow: _currentIndex == index
                              ? event?.image!.length == 1
                                  ? []
                                  : [
                                      const BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ]
                              : [],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]))),
    );
  }
}
