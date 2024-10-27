import 'package:ajwad_v4/auth/view/ajwadi_register/driving_license.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/advertisement_controller.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdCards extends StatefulWidget {
  const AdCards({Key? key}) : super(key: key);

  @override
  _AdCardsState createState() => _AdCardsState();
}

class _AdCardsState extends State<AdCards> {
  int _currentIndex = 0;

  // Example list of images
  final List<String> _images = [
    'assets/images/percent.png',
    'assets/images/holiday.png',
  ];

  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final _srvicesController = Get.put(AdvertisementController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _srvicesController.getAllAdvertisement(context: context);
  }

  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context)!;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 260,
        left: AppUtil.rtlDirection2(context)
            ? MediaQuery.of(context).size.width * 0.332
            : null,
        right: AppUtil.rtlDirection2(context)
            ? null
            : MediaQuery.of(context).size.width * 0.298,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CustomText(
              text: AppUtil.rtlDirection2(context)
                  ? "تم نسخ الكوبون بنجاح"
                  : 'Coupon copied to clipboard',
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

    Future.delayed(Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Obx(
      () => Skeletonizer(
        enabled: _srvicesController.isAdvertisementLoading.value,
        child: _srvicesController.advertisementList.isEmpty
            ? Container()
            : Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.9, // Ensure widt
                        child: SizedBox(
                          height: 133, // Set the desired height for the card
                          child: CarouselSlider.builder(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              // height: 200, // Add explicit height here
                              viewportFraction: 1,
                              autoPlay:
                                  _srvicesController.advertisementList.length ==
                                          1
                                      ? false
                                      : true,
                              // enableInfiniteScroll: true,
                              // animateToClosest: true,
                              onPageChanged: (i, reason) {
                                setState(() {
                                  _currentIndex = i;
                                });
                              },
                            ),
                            itemCount:
                                _srvicesController.advertisementList.length,
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.to();
                                  if (_srvicesController
                                          .advertisementList[index].type ==
                                      'COUPON') {
                                    Clipboard.setData(ClipboardData(
                                        text: _srvicesController
                                            .advertisementList[index].content));
                                    _showOverlay(context);
                                  } else if (_srvicesController
                                          .advertisementList[index].type ==
                                      'EVENT') {
                                    Get.to(() => (LocalEventDetails(
                                        eventId: _srvicesController
                                            .advertisementList[index]
                                            .content)));
                                  } else if (_srvicesController
                                          .advertisementList[index].type ==
                                      'PLACE') {
                                    final TouristExploreController
                                        _touristExploreController =
                                        Get.put(TouristExploreController());

                                    _touristExploreController
                                        .getPlaceById(
                                            id: _srvicesController
                                                .advertisementList[index]
                                                .content,
                                            context: context)
                                        .then((value) {
                                      Get.to(() => (TripDetails(
                                          place: _touristExploreController
                                              .thePlace.value)));
                                    });
                                  } else if (_srvicesController
                                          .advertisementList[index].type ==
                                      'HOSPITALITY') {
                                    Get.to(() => (HospitalityDetails(
                                        hospitalityId: _srvicesController
                                            .advertisementList[index]
                                            .content)));
                                  } else if (_srvicesController
                                          .advertisementList[index].type ==
                                      'HOSPITALITY') {
                                    Get.to(() => (AdventureDetails(
                                        adventureId: _srvicesController
                                            .advertisementList[index]
                                            .content)));
                                  } else if (_srvicesController
                                          .advertisementList[index].type ==
                                      'GENERAL') {}
                                },
                                child: ImagesSliderWidget(
                                    image:AppUtil.rtlDirection2(context)
                                    ? _srvicesController
                                        .advertisementList[index]
                                        .imageUrls!
                                        .last
                                        
                                    :  _srvicesController
                                        .advertisementList[index]
                                        .imageUrls!
                                        .first    
                                        ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.138,
                            bottom: height *
                                0.047), // Set the top padding to control vertical position
                        child: AnimatedSmoothIndicator(
                            effect: WormEffect(
                              // dotColor: starGreyColor,
                              dotWidth: width * 0.0205,
                              dotHeight: width * 0.0205,
                              activeDotColor: Colors.white,
                              dotColor: babyGray,
                            ),
                            activeIndex: _currentIndex,
                            count: _srvicesController.advertisementList.length),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ImagesSliderWidget extends StatelessWidget {
  final String image;

  const ImagesSliderWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: lightGreyBackground),
      child: ImageCacheWidget(
        image: image,
        fit: BoxFit.fill,
      ),
    );
  }
}
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: purple.withOpacity(0.16),
//           borderRadius: const BorderRadius.all(Radius.circular(12)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Stack(
//               children: [
//                 if (!AppUtil.rtlDirection(context))
//                   Image.asset('assets/images/percent.png'),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     right: !AppUtil.rtlDirection(context) ? 22 : 0,
//                     left: !AppUtil.rtlDirection(context) ? 0 : 22,
//                     top: 22,
//                     bottom: 17,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: RichText(
//                           text: TextSpan(children: [
//                             TextSpan(
//                               text: AppUtil.rtlDirection2(context)
//                                   ? 'خصومات حصرية لضيوف\n'
//                                   : 'Exclusive Discounts for\n',
//                               style: TextStyle(
//                                 fontFamily: AppUtil.rtlDirection2(context)
//                                     ? 'Noto Kufi Arabic'
//                                     : 'SF Pro',
//                                 color: Color(0xFF14143E),
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             TextSpan(
//                               text: AppUtil.rtlDirection2(context)
//                                   ? 'هوليداي إن!'
//                                   : 'Holiday Inn ',
//                               style: TextStyle(
//                                 fontFamily: AppUtil.rtlDirection2(context)
//                                     ? 'Noto Kufi Arabic'
//                                     : 'SF Pro',
//                                 color: Color(0xFF9747FF),
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             TextSpan(
//                               text: AppUtil.rtlDirection2(context)
//                                   ? ' '
//                                   : ' Guests!\n',
//                               style: const TextStyle(
//                                 fontFamily: 'Kufam',
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: black,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'happyExploring'.tr,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 color: Color(0xFF0C0C25),
//                                 fontFamily: 'SF Pro',
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Stack(
//               alignment: AlignmentDirectional.center,
//               children: [
//                 if (AppUtil.rtlDirection(context))
//                   Image.asset('assets/images/percent.png'),
//                 Image.asset(
//                   'assets/images/holiday.png',
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
