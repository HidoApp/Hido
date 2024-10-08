import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/advertisement_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final CarouselController _carouselController = CarouselController();
 final _srvicesController = Get.put(AdvertisementController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _srvicesController.getAllAdvertisement(context: context);
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: lightGreyBackground),
          child: Column(
            children: [
              // images widget on top of screen
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.9, // Ensure widt
                  child:
                  
                  //  _srvicesController.advertisementList.isEmpty
                  //                 ? Image.asset(
                  //                     'assets/images/Placeholder.png',
                  //                     height: height * 0.3,
                  //                     fit: BoxFit.cover,
                  //                   )
                  
                   CarouselSlider.builder(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      // height: 200, // Add explicit height here
                      viewportFraction: 1,
                      autoPlay:true,
                      enableInfiniteScroll: true,
                      animateToClosest:true,
                      onPageChanged: (i, reason) {
                        setState(() {
                          _currentIndex = i;
                        });
                      },
                    ),
                    itemCount:
                        _images.length, // Using the length of the image list
                        //  _srvicesController.advertisementList.length
                    itemBuilder: (context, index, realIndex) {
                      return  GestureDetector(
                        onTap: () {
                          // Get.to();
                          // if(_srvicesController.advertisementList[index].type=='code')

                          // else{

                          // }
                        },
                        child: ImagesSliderWidget(
                          image:
                              _images[index],
                               // Accessing images from the list
                                // _srvicesController.advertisementList[index].imageUrls
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.17,
              ), // Set the top padding to control vertical position
              child: AnimatedSmoothIndicator(
                  effect: WormEffect(
                    // dotColor: starGreyColor,
                    dotWidth: width * 0.0205,
                    dotHeight: width * 0.0205,
                    activeDotColor: Colors.white,
                    dotColor: babyGray,
                  ),
                  activeIndex: _currentIndex,
                  count: 3),
            ),
          ),
        ),
      ],
    );
  }
}

class ImagesSliderWidget extends StatelessWidget {
  final String image;

  const ImagesSliderWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures the image takes full width

      child: Image.asset(
        image,
        fit: BoxFit.cover, // Adjust the image to cover the container
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
