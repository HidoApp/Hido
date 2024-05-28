import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/share_sheet.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class AdventureDetails extends StatefulWidget {
  const AdventureDetails({
    Key? key,
    required this.adventureId,
  }) : super(key: key);

  final String adventureId;

  @override
  State<AdventureDetails> createState() => _AdventureDetailsState();
}

late double width, height;

class _AdventureDetailsState extends State<AdventureDetails> {
  final _adventureController = Get.put(AdventureController());
  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  List<DateTime> avilableDate = [];
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

  late Adventure? adventure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  initializeDateFormatting(); //very important

    addCustomIcon();
    getAdventureById();
  }

  void getAdventureById() async {
    adventure = (await _adventureController.getAdvdentureById(
        context: context, id: widget.adventureId));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Obx(
      () => _adventureController.isAdventureByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(""),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              bottomNavigationBar: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(top: width * 0.025),
                  child: BottomAdventureBooking(
                    adventure: adventure!,
                  ),
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
                          tripImageUrl: adventure!.image!,
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
                        itemCount: adventure!.image!.length,
                        itemBuilder: (context, index, realIndex) {
                          return ImagesServicesWidget(
                            image: adventure!.image![index],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: width * 0.1,
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
                                    ? adventure!.nameAr!
                                    : adventure!.nameEn!,
                                fontSize: width * 0.07,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/locationHos.svg",
                                color: starGreyColor,
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              CustomText(
                                text: AppUtil.rtlDirection2(context)
                                    ? adventure!.regionAr!
                                    : adventure!.regionEn!,
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/grey_calender.svg',
                                color: starGreyColor,
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              CustomText(
                                text: DateFormat('E-dd-MMM')
                                    .format(DateTime.parse(adventure!.date!)),
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/timeGrey.svg",
                                color: starGreyColor,
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              //time
                              CustomText(
                            text: adventure?.times != null && adventure!.times!.isNotEmpty
                                ? adventure!.times!.join(' - ')
                                : '5:00-8:00 AM',                               
                                 color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          SizedBox(
                            height: width * 0.038,
                          ),
                          Align(
                              alignment: AppUtil.rtlDirection2(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: "about".tr,
                                fontSize: width * 0.046,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          ConstrainedBox(
                            constraints: isExpanded
                                ? const BoxConstraints()
                                : BoxConstraints(maxHeight: width * 0.102),
                            child: CustomText(
                              //   textAlign: AppUtil.rtlDirection(context) ? TextAlign.end : TextAlign.start ,
                              textDirection: AppUtil.rtlDirection2(context)
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              textOverflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.clip,
                              fontFamily: "Noto Kufi Arabic",
                              fontSize: width * 0.035,
                              text: AppUtil.rtlDirection2(context)
                                  ? adventure!.descriptionAr!
                                  : adventure!.descriptionEn!,
                            ),
                          ),
                          SizedBox(
                            height: width * 0.012,
                          ),
                          isExpanded
                              ? Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => isExpanded = false);
                                    },
                                    child: CustomText(
                                      text: AppUtil.rtlDirection2(context)
                                          ? "القليل"
                                          : "Show less",
                                      color: blue,
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => isExpanded = true),
                                    child: CustomText(
                                      text: "readMore".tr,
                                      color: blue,
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
                                text: "whereWeWillBe".tr,
                                fontSize: width * 0.046,
                                fontWeight: FontWeight.w500,
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
                                    target: adventure == null
                                        ? locLatLang
                                        : LatLng(
                                            double.parse(adventure!
                                                .coordinates!.latitude!),
                                            double.parse(adventure!
                                                .coordinates!.longitude!)),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId("marker1"),
                                      position: adventure == null
                                          ? locLatLang
                                          : LatLng(
                                              double.parse(adventure!
                                                  .coordinates!.latitude!),
                                              double.parse(adventure!
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
                      ),
                    )
                  ],
                ),
                // Positioned(
                //     top: height * 0.07,
                //     right: AppUtil.rtlDirection2(context)
                //         ? width * 0.85
                //         : width * 0.05,
                //     child: SvgPicture.asset(
                //       "assets/icons/white_bookmark.svg",
                //       height: width * 0.07,
                //     )),
                Positioned(
                  top: height * 0.06,
                  left: !AppUtil.rtlDirection(context)
                      ? width * 0.85
                      : width * 0.06,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        textDirection: AppUtil.rtlDirection2(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        size: width * 0.061,
                        color: Colors.white),
                    onPressed: () => Get.back(),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                    top: height * 0.265,
                    right: width * 0.1,
                    left: width * 0.1,
                    // local profile
                    child: ServicesProfileCard(
                      onTap: () {
                        Get.to(() =>
                            ServicesLocalInfo(profileId: adventure!.userId));
                      },
                      image: adventure!.user!.profileImage ?? '',
                      name: adventure!.user!.name!,
                    )),
                //indicator
                Positioned(
                  top: height * 0.22,
                  left: width * 0.36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: adventure!.image!.map((imageUrl) {
                      int index = adventure!.image!.indexOf(imageUrl);
                      return Container(
                        width: width * 0.025,
                        height: width * 0.025,
                        margin: EdgeInsets.symmetric(
                            vertical: width * 0.025, horizontal: width * 0.005),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          boxShadow: _currentIndex == index
                              ? [
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
