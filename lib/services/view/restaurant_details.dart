import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/share_sheet.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/services/view/restaurant_reservation.dart';

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

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

late double width, height;

class _RestaurantDetailsState extends State<RestaurantDetails> {
  final List<String> _AdventureUrlImages = [
    'assets/images/restaurant.png',
    'assets/images/event_Image.png',
    'assets/images/twaik_image5.png'
  ];

  final List<String> _ajwadiUrlImages = [
    'assets/images/ajwadi1.png',
    'assets/images/ajwadi2.png',
    'assets/images/ajwadi3.png',
    'assets/images/ajwadi4.png',
    'assets/images/ajwadi5.png',
  ];

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  int _currentIndex = 0;
  var locLatLang = const LatLng(24.9470921, 45.9903698);
  bool isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          AppUtil.rtlDirection(context)
              ? 'مطعم الركن السعودي'
              : 'Saudi Corner Restaurant',
          color: Colors.white,
          iconColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(ViewTripImages(tripImageUrl: _AdventureUrlImages));
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
                  itemCount: _AdventureUrlImages.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        _AdventureUrlImages[0],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: height*0.6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Align(
                          alignment: AppUtil.rtlDirection(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            text: AppUtil.rtlDirection(context)
                                ? 'مطعم الركن السعودي'
                                : 'Saudi Corner Restaurant',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Pin icon.svg",
                            color: reddishOrange,
                          ),
                          CustomText(
                            text: " riyadhSaudiArabia".tr,
                            color: colorDarkGrey,
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/call_icon.svg",
                            color: reddishOrange,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          CustomText(
                            text: "05644774444",
                              color: colorDarkGrey,
                            fontWeight: FontWeight.w300,
                          ),
                          Spacer(),
                          SvgPicture.asset("assets/icons/global.svg"),
                          SizedBox(
                            width: 3,
                          ),
                          CustomText(
                            text: "Saudi Corner Restaurant",
                              color: colorDarkGrey,
                            fontWeight: FontWeight.w300,
                            textDecoration: TextDecoration.underline,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                     Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(2, 3),
                                                    blurRadius: 3,
                                                    color: dotGreyColor
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1)
                                              ]),
                                          child: SvgPicture.asset(
                                              "assets/icons/visit_icon.svg")),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text: "visit".tr,
                                            color: colorDarkGrey,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          CustomText(
                                            text: "108 ",
                                            fontWeight: FontWeight.w300,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(2, 3),
                                                    blurRadius: 3,
                                                    color: dotGreyColor
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1)
                                              ]),
                                          child: SvgPicture.asset(
                                              "assets/icons/distance_icon.svg")),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text: "distance".tr,
                                            color: colorDarkGrey,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          CustomText(
                                            text: "3000 km",
                                            fontWeight: FontWeight.w300,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(2, 3),
                                                    blurRadius: 3,
                                                    color: dotGreyColor
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1)
                                              ]),
                                          child: SvgPicture.asset(
                                              "assets/icons/rate_icon.svg")),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text: "rating".tr,
                                            color: colorDarkGrey,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          CustomText(
                                            text: "4.8 (3.2k)",
                                            fontWeight: FontWeight.w300,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: AppUtil.rtlDirection(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            text: "aboutTheTrip".tr,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: isExpanded
                            ? new BoxConstraints()
                            : new BoxConstraints(maxHeight: 50.0),
                        child: CustomText(
                
                            //   textAlign: AppUtil.rtlDirection(context) ? TextAlign.end : TextAlign.start ,
                            textDirection: AppUtil.rtlDirection(context)
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            textOverflow: TextOverflow.fade,
                            fontFamily: "Noto Kufi Arabic",
                            fontSize: 14,
                            text: "aboutTheTripBrief".tr),
                      ),
                      isExpanded
                          ? new Container()
                          : Align(
                              alignment: Alignment.bottomLeft,
                              child: new TextButton(
                                  child: CustomText(
                                    text: "readMore".tr,
                                    color: reddishOrange,
                                  ),
                                  onPressed: () =>
                                      setState(() => isExpanded = true)),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "startFrom".tr,
                            fontSize: 12,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            text: " /  ",
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                          CustomText(
                            text: " 150 SAR",
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Spacer(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: CustomButton(
                          onPressed: () {
                            Get.to(() => RestaurantReservation());
                          },
                          title: "startBook".tr.toUpperCase(),
                          icon: AppUtil.rtlDirection(context)
                              ? const Icon(Icons.arrow_back)
                              : const Icon(Icons.arrow_forward),
                          buttonColor: reddishOrange,
                          iconColor: darkReddishOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
              top: height * 0.06,
              right:
                  AppUtil.rtlDirection(context) ? width * 0.85 : width * 0.05,
              //  left: AppUtil.rtlDirection(context) ?  width *0.05: 0,
              child: SvgPicture.asset(
                "assets/icons/white_bookmark.svg",
                height: 40,
              )),
          Positioned(
              top: height * 0.265,
              right: width * 0.1,
              left: width * 0.1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: almostGrey.withOpacity(0.2),
                        spreadRadius: -3,
                        blurRadius: 5,
                        offset: Offset(4, 6))
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
                            context: context,
                            builder: (context) {
                              return ShareSheet(
                                fromAjwady: false,
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        height: 28,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: reddishOrange,
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Row(
                          children: [
                            CustomText(
                              text: "invite".tr,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            Spacer(),
                            SvgPicture.asset("assets/icons/share_icon.svg"),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    ajwadiImages()
                  ],
                ),
              )),
          Positioned(
            top: height * 0.22,
            left: width * 0.45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _AdventureUrlImages.map((imageUrl) {
                int index = _AdventureUrlImages.indexOf(imageUrl);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    boxShadow: _currentIndex == index
                        ? [
                            BoxShadow(
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
        ])));
  }

  Widget ajwadiImages() {
    var items = _ajwadiUrlImages.map((url) => buildImage(url)).toList();
    final emptyUrl = " ";
    items = items + [buildImage(emptyUrl)];
    return StackWidgets(
      items: items,
      size: 30,
    );
  }

  buildImage(String url) {
    return url == " "
        ? ClipOval(
            child: Container(
              color: reddishOrange,
              child: Center(
                child: CustomText(
                  text: "23+",
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          )
        : ClipOval(
            child: Image.asset(
            url,
            fit: BoxFit.fill,
          ));
  }
}
