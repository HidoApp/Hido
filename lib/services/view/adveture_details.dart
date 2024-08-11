 import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/view/edit_adventure.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/share_sheet.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_aleart_widget.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
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

class AdventureDetails extends StatefulWidget {
  const AdventureDetails({
    Key? key,
    required this.adventureId,
    this.isLocal = false,
    this.address='',
    this.isHasBooking=false,

  }) : super(key: key);

  final String adventureId;
  final bool isLocal;
  final String address;
    final bool isHasBooking;

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
  String address='';
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
   
   if(!widget.isLocal){
     _fetchAddress( adventure!.coordinates!.latitude??'', adventure!.coordinates!.longitude??'');
     }
  }
 Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1, position2);
      print(placemarks);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print(placemarks.first);
        return '${placemark.locality}, ${placemark.subLocality}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress(String position1, String position2) async {
    try {
      String result = await _getAddressFromLatLng(
          double.parse(position1), double.parse(position2));
      setState(() {
      address = result;
      });
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
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
              body: Center(child: CircularProgressIndicator.adaptive()),
            )
          : Scaffold(
              bottomNavigationBar: !widget.isLocal?
              SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(top: width * 0.025),
                  child: BottomAdventureBooking(
                    adventure: adventure!,
                    address:address,
                  ),
                ),
              ) : Padding(
                      padding: EdgeInsets.only(
                          right: 17, left: 17, bottom: width * 0.085),
                      child: Row(
                        children: [
                          CustomText(
                            text: "pricePerPerson".tr,
                            fontSize: width * 0.038,
                            color: colorDarkGrey,
                            fontWeight: FontWeight.w400,
                           fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

                          ),
                          CustomText(
                            text: " /  ",
                            fontWeight: FontWeight.w900,
                            fontSize: width * 0.043,
                            color: Colors.black,
                          ),
                          CustomText(
                            text: '${adventure!.price} ${'sar'.tr}',
                            fontWeight: FontWeight.w900,
                            fontSize: width * 0.043,
                            fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

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
                      height: width * 0.10,
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
                                    ? adventure!.nameAr ?? ''
                                    : adventure!.nameEn ?? '',
                                fontSize: width * 0.07,
                                fontWeight: FontWeight.w500,
                                fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',
                              )),
                          SizedBox(
                            height: width * 0.025,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/map_pin.svg",
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              CustomText(
                                text:!widget.isLocal?
                               address
                                : AppUtil.rtlDirection2(context)
                                           ? '${adventure!.regionAr}, ${widget.address}'
                                            : '${adventure!.regionEn}, ${widget.address}',
                              
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                                fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.01,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/calendar.svg',
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              CustomText(
                                text: AppUtil.formatBookingDate(context, adventure!.date ?? ''),
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                                fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.01,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Clock.svg",
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              //time
                              CustomText(
                                text: adventure?.times != null &&
                                        adventure!.times!.isNotEmpty
                                    ? '${adventure?.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime)).join(', ')} - ${adventure?.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.endTime)).join(', ')}'
                                    : '5:00-8:00 AM',
                                color: colorDarkGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w300,
                                 fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

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
                                      : BoxConstraints(maxHeight: width * 0.097),
                                  child: CustomText(
                                      textDirection: AppUtil.rtlDirection(context)
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                      textOverflow: isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.clip,
                                         
                                   fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',
                                   color:  starGreyColor,
                                fontSize: width * 0.038,
                          
                                text: AppUtil.rtlDirection2(context)
                                    ? adventure!.descriptionAr ?? ''
                                    : adventure!.descriptionEn ?? '',
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
                                     fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

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
                                      fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

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
                                text:!widget.isLocal? "whereWeWillBe".tr:AppUtil.rtlDirection2(context)?'الموقع':'Location',
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
                                  scrollGesturesEnabled: true,
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
                            if (widget.isLocal)...[
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
                                             fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

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
                              color:
                                  Colors.white.withOpacity(0.20000000298023224),
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
                              onTap:widget.isHasBooking?
                               () async {
                                 showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                
                  
                );
              },
            );
                              }:() {
                              Get.to(()=>EditAdventure(adventureObj: adventure!));

                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(0.20000000298023224),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/editPin.svg',
                                  height: 28,
                                  color: Colors.white,
                                ),
                              ))),
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
                      name: adventure!.user!.name ?? '',
                    )),
                //indicator
                Positioned(
                  top: height * 0.22,
                  left: width * 0.4,
                  right:width * 0.4,
                  // left: width * 0.36,
                child: Align(
                          alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                             ?  adventure!.image!.length == 1
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white
                             
                                : Colors.white.withOpacity(0.8),
                          
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ]))),
    );
  }
}
