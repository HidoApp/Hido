import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:geocoding/geocoding.dart';

import '../../../../../services/controller/hospitality_controller.dart';

class HostInfoReview extends StatefulWidget {
  final String hospitalityTitleEn;
  final String hospitalityBioEn;
  final String hospitalityTitleAr;
  final String hospitalityBioAr;
  final int? hospitalityPrice;
  final String hospitalityLocation;
  final int? adventurePrice;

  final List<String> hospitalityImages;
  // final int seats;
  final String experienceType;
  final HospitalityController? hospitalityController;
  final AdventureController? adventureController;

  HostInfoReview({
    required this.hospitalityBioAr,
    required this.hospitalityBioEn,
    required this.hospitalityTitleAr,
    required this.hospitalityTitleEn,
    this.hospitalityPrice,
    required this.hospitalityImages,
    required this.hospitalityLocation,
    // required this.seats,
    // required this.gender,
    this.hospitalityController,
    required this.experienceType,
    this.adventureController,
    this.adventurePrice,
  });

  @override
  _HostInfoReviewState createState() => _HostInfoReviewState();
}

class _HostInfoReviewState extends State<HostInfoReview> {
  String address = ''; // State variable to store the fetched address
  String startTime = '';
  String endTime = '';
  List<String> imageUrls = [];
  List<Map<String, dynamic>> DaysInfo = [];

  // String ragionAr = '';
  // String ragionEn = '';
  final EventController _EventController = Get.put(EventController());
  String locationUrl = '';

  List<String> regionListEn = [
    "Riyadh",
    "Mecca",
    "Medina",
    "Dammam",
    "Qassim",
    "Hail",
    "Northern Borders",
    "Jazan",
    "Asir",
    "Tabuk",
    "Najran",
    "Al Baha",
    "Al Jouf"
  ];

  List<String> regionListAr = [
    "الرياض",
    "مكة",
    "المدينة",
    "الدمام",
    "القصيم",
    "حائل",
    "الحدود الشمالية",
    "جازان",
    "عسير",
    "تبوك",
    "نجران",
    "الباحة",
    "الجوف"
  ];

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        // setState(() {
        //   if (AppUtil.rtlDirection2(context)) {
        //     ragionAr = placemark.locality!;
        //     ragionEn = 'Riyadh';
        //   } else {
        //     ragionAr = 'الرياض';
        //     ragionEn = placemark.locality!;
        //   }
        //  if (!regionListEn.contains(ragionEn) || !regionListAr.contains(ragionAr)) {
        //    setState(() {

        //     ragionAr = 'الرياض';
        //     ragionEn = 'Riyadh';

        //   });
        //  }
        // });

        return placemark.subLocality != null &&
                placemark.subLocality!.isNotEmpty
            ? '${placemark.subLocality}'
            : '${placemark.locality}';
      }
    } catch (e) {}
    return '';
  }

  Future<void> _fetchAddress() async {
    try {
      String result = widget.experienceType == 'hospitality'
          ? await _getAddressFromLatLng(
              widget.hospitalityController!.pickUpLocLatLang.value)
          : await _getAddressFromLatLng(
              widget.adventureController!.pickUpLocLatLang.value);
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
    }
  }

  void daysInfo() {
    // Format for combining date and time
    var formatter = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateTime date =
        DateTime.parse(widget.hospitalityController!.selectedDate.value);

    DateTime newStartTime = DateTime(
        date.year,
        date.month,
        date.day,
        widget.hospitalityController!.selectedStartTime.value.hour,
        widget.hospitalityController!.selectedStartTime.value.minute,
        widget.hospitalityController!.selectedStartTime.value.second,
        widget.hospitalityController!.selectedStartTime.value.millisecond);
    DateTime newEndTime = DateTime(
        date.year,
        date.month,
        date.day,
        widget.hospitalityController!.selectedEndTime.value.hour,
        widget.hospitalityController!.selectedEndTime.value.minute,
        widget.hospitalityController!.selectedEndTime.value.second,
        widget.hospitalityController!.selectedEndTime.value.millisecond);

    startTime = formatter.format(newStartTime);
    endTime = formatter.format(newEndTime);

    var newEntry = {
      "startTime": formatter.format(newStartTime),
      "endTime": formatter.format(newEndTime),
      "seats": widget.hospitalityController!.seletedSeat
    };

    DaysInfo.add(newEntry);

    // Print the new dates list
  }

  void advDates() {
    var formatter = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    for (var date in widget.adventureController!.selectedDates) {
      DateTime newStartTime = DateTime(
          date.year,
          date.month,
          date.day,
          widget.adventureController!.selectedStartTime.value.hour,
          widget.adventureController!.selectedStartTime.value.minute,
          widget.adventureController!.selectedStartTime.value.second,
          widget.adventureController!.selectedStartTime.value.millisecond);
      DateTime newEndTime = DateTime(
          date.year,
          date.month,
          date.day,
          widget.adventureController!.selectedEndTime.value.hour,
          widget.adventureController!.selectedEndTime.value.minute,
          widget.adventureController!.selectedEndTime.value.second,
          widget.adventureController!.selectedEndTime.value.millisecond);

      //startTime = formatter.format(newStartTime);
      //endTime = formatter.format(newEndTime);

      var newEntry = {
        "startTime": formatter.format(newStartTime),
        "endTime": formatter.format(newEndTime),
        "seats": widget.adventureController!.seletedSeat
      };

      DaysInfo.add(newEntry);
    }

    // Print the new dates list
  }

  // Function to generate the Google Maps URL
  String getLocationUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  Future<bool> uploadhostImages() async {
    //List<String> uploadedImagePaths = [];
    bool allExtensionsValid = true;

    // Allowed formats
    final allowedFormats = ['jpg', 'jpeg', 'png'];

    for (XFile imagePath in widget.hospitalityController!.selectedImages) {
      String fileExtension = imagePath.path.split('.').last.toLowerCase();
      if (!allowedFormats.contains(fileExtension)) {
        allExtensionsValid = false;
        print(
            'File ${imagePath.path} is not in an allowed format (${allowedFormats.join(', ')}).');
      }
      if (!allExtensionsValid) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'uploadError'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
        return false;
      } else {
        final image = await _EventController.uploadProfileImages(
          file: File(imagePath.path),
          fileType: "hospitality",
          context: context,
        );

        //  File file = await convertImageToJpg(File(imagePath.path));
        //   final image = await _EventController.uploadProfileImages(
        //     file:file,
        //     fileType: "event",
        //     context: context,
        //   );

        if (image != null) {
          log('vaalid');

          imageUrls.add(image.filePath);
          log(image.filePath);
        } else {
          log('not vaalid');
          return false;
        }
      }
    }
    return true;

    // Handle the list of uploaded image paths as needed
  }

  Future<bool> uploadAdveImages() async {
    //List<String> uploadedImagePaths = [];
    bool allExtensionsValid = true;

    // Allowed formats
    final allowedFormats = ['jpg', 'jpeg', 'png'];

    for (XFile imagePath in widget.adventureController!.selectedImages) {
      String fileExtension = imagePath.path.split('.').last.toLowerCase();
      if (!allowedFormats.contains(fileExtension)) {
        allExtensionsValid = false;
        print(
            'File ${imagePath.path} is not in an allowed format (${allowedFormats.join(', ')}).');
      }
      if (!allExtensionsValid) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'uploadError'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
        return false;
      } else {
        final image = await _EventController.uploadProfileImages(
          file: File(imagePath.path),
          fileType: "adventures",
          context: context,
        );

        //  File file = await convertImageToJpg(File(imagePath.path));
        //   final image = await _EventController.uploadProfileImages(
        //     file:file,
        //     fileType: "event",
        //     context: context,
        //   );

        if (image != null) {
          log('vaalid');

          imageUrls.add(image.filePath);
          log(image.filePath);
        } else {
          log('not vaalid');
          return false;
        }
      }
    }
    return true;

    // Handle the list of uploaded image paths as needed
  }

  Future<void> createHospitalityExperience() async {
    final isSuccess = await widget.hospitalityController!.createHospitality(
        titleAr: widget.hospitalityTitleAr,
        titleEn: widget.hospitalityTitleEn,
        bioAr: widget.hospitalityBioAr,
        bioEn: widget.hospitalityBioEn,
        mealTypeAr: widget.hospitalityController!.selectedMealAr.value,
        mealTypeEn: widget.hospitalityController!.selectedMealEn.value,
        longitude: widget
            .hospitalityController!.pickUpLocLatLang.value.longitude
            .toString(),
        latitude: widget.hospitalityController!.pickUpLocLatLang.value.latitude
            .toString(),
        touristsGender: widget.hospitalityController!.selectedGender.value,
        price: widget.hospitalityPrice!,
        images: imageUrls,
        regionAr: widget.hospitalityController!.ragionAr.value,
        regionEn: widget.hospitalityController!.ragionEn.value,
        location: locationUrl,
        daysInfo: DaysInfo,
        start: startTime,
        end: endTime,
        seat: widget.hospitalityController!.seletedSeat.value,
        context: context);

    if (isSuccess) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 350,
              height: 110, // Custom width
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/paymentSuccess.gif', width: 38),
                  const SizedBox(height: 16),
                  CustomText(
                    text: !AppUtil.rtlDirection2(context)
                        ? "Experience published successfully"
                        : "تم نشر تجربتك بنجاح ",
                    textDirection: AppUtil.rtlDirection2(context)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
          AmplitudeService.amplitude.track(BaseEvent(
                                    'Hospitality published successfully',
                                    eventProperties: {
                                      'titleEn:': widget.hospitalityTitleEn,
                                    }));
        Get.offAll(() => const AjwadiBottomBar());
      });
    } else {
       AmplitudeService.amplitude.track(BaseEvent(
                                    'Hospitality published failed',
                                    eventProperties: {
                                      'titleEn:': widget.hospitalityTitleEn,
                                    }));
      AppUtil.errorToast(context, 'somthingWentWrong'.tr);
    }
  }

  Future<void> createAdventureExperience() async {
    final isSuccess = await widget.adventureController!.createAdventure(
      nameAr: widget.hospitalityTitleAr,
      nameEn: widget.hospitalityTitleEn,
      descriptionAr: widget.hospitalityBioAr,
      descriptionEn: widget.hospitalityBioEn,
      longitude: widget.adventureController!.pickUpLocLatLang.value.longitude
          .toString(),
      latitude: widget.adventureController!.pickUpLocLatLang.value.latitude
          .toString(),
      date: widget.adventureController!.selectedDate.value.substring(0, 10),
      price: widget.adventurePrice!,
      image: imageUrls,
      regionAr: widget.adventureController!.ragionAr.value,
      locationUrl: locationUrl,
      regionEn: widget.adventureController!.ragionEn.value,
      start: intl.DateFormat('HH:mm:ss')
          .format(widget.adventureController!.selectedStartTime.value),
      end: intl.DateFormat('HH:mm:ss')
          .format(widget.adventureController!.selectedEndTime.value),
      seat: widget.adventureController!.seletedSeat.value,
      context: context,
    );

    if (isSuccess) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 350,
              height: 110, // Custom width
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/paymentSuccess.gif', width: 38),
                  SizedBox(height: 16),
                  CustomText(
                    text: !AppUtil.rtlDirection2(context)
                        ? "Experience published successfully"
                        : "تم نشر تجربتك بنجاح ",
                    textDirection: AppUtil.rtlDirection2(context)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
         AmplitudeService.amplitude.track(BaseEvent(
                                    'Adventure published successfully',
                                    eventProperties: {
                                      'title:': widget.hospitalityTitleEn,
                                    }));
        Get.offAll(() => const AjwadiBottomBar());
      });
    } else {
      AmplitudeService.amplitude.track(BaseEvent(
                                    'Adventure published Failed',
                                    eventProperties: {
                                      'title:': widget.hospitalityTitleEn,
                                    }));
      AppUtil.errorToast(context, 'somthingWentWrong'.tr);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAddress();
    if (widget.experienceType == 'hospitality') {
      daysInfo();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        locationUrl = widget.experienceType == 'hospitality'
            ? getLocationUrl(
                widget.hospitalityController!.pickUpLocLatLang.value)
            : getLocationUrl(
                widget.adventureController!.pickUpLocLatLang.value);
      });
    });
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        'Review'.tr,
        isAjwadi: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: widget.experienceType == 'hospitality'
                  ? 'Reviewexperience'.tr
                  : 'Reviewadventure'.tr,
              color: Color(0xFF070708),
              fontSize: 17,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                child: CustomText(
                  text: widget.experienceType == 'hospitality'
                      ? 'explination'.tr
                      : 'explinationAdve'.tr,
                  color: Color(0xFF9392A0),
                  fontSize: 15,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3FC7C7C7),
                    blurRadius: 16,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: widget.experienceType == 'hospitality'
                            ? FileImage(File(widget
                                .hospitalityController!.selectedImages[0].path))
                            : FileImage(File(widget
                                .adventureController!.selectedImages[0].path)),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? widget.hospitalityTitleAr
                                  : widget.hospitalityTitleEn,
                              color: Color(0xFF070708),
                              fontSize: 16,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                            // Row(
                            //   children: [
                            //     Icon(Icons.star,
                            //         color: Color(0xFF36B268), size: 14),
                            //     const SizedBox(width: 4),
                            //     CustomText(
                            //       text: '5.0',
                            //       color: Color(0xFF36B268),
                            //       fontSize: 12,
                            //       fontFamily: AppUtil.rtlDirection2(context)
                            //           ? 'SF Arabic'
                            //           : 'SF Pro',
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/map_pin.svg'),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    CustomText(
                                      text: widget.experienceType ==
                                              'hospitality'
                                          ? AppUtil.rtlDirection2(context)
                                              ? '${widget.hospitalityController!.ragionAr.value}, ${address}'
                                              : '${widget.hospitalityController!.ragionEn.value}, ${address}'
                                          : AppUtil.rtlDirection2(context)
                                              ? '${widget.adventureController!.ragionAr.value}, ${address}'
                                              : '${widget.adventureController!.ragionEn.value}, ${address}',
                                      color: Color(0xFF9392A0),
                                      fontSize: 11,
                                      fontFamily: AppUtil.SfFontType(context),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (widget.experienceType == 'hospitality')
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/calendar.svg',
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      CustomText(
                                        text:
                                            '${AppUtil.formatBookingDate(context, widget.hospitalityController!.selectedDate.value)} - ${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(widget.hospitalityController!.selectedStartTime.value))}',
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                if (widget.experienceType == 'adventure')
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/calendar.svg',
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      //'${AppUtil.formatSelectedDates(widget.adventureController!.selectedDates,context,)} ',
                                      CustomText(
                                        text:
                                            '${AppUtil.formatBookingDate(context, widget.adventureController!.selectedDate.value)} ',
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 4),
                                if (widget.experienceType == 'adventure')
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: SvgPicture.asset(
                                          'assets/icons/Clock.svg',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      CustomText(
                                        text:
                                            '${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(widget.adventureController!.selectedStartTime.value))} - ${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(widget.adventureController!.selectedEndTime.value))}',
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                if (widget.experienceType == 'hospitality')
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/meal.svg",
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      CustomText(
                                        text: AppUtil.rtlDirection2(context)
                                            ? widget.hospitalityController!
                                                .selectedMealAr.value
                                            : widget.hospitalityController!
                                                .selectedMealEn.value,
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),

                                      // SizedBox(
                                      //     width:
                                      //         68), // Adjust spacing between text and button
                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 16, vertical: 8),
                                      //   decoration: BoxDecoration(
                                      //     color: Color(0xFFECF9F1),
                                      //     borderRadius:
                                      //         BorderRadius.circular(9999),
                                      //   ),
                                      //   child: Text(
                                      //     'show preview',
                                      //     style: TextStyle(
                                      //       color: Color(0xFF36B268),
                                      //       fontSize: 13,
                                      //       fontFamily: 'SF Pro',
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 35),
                    child: Column(
                      children: [
                        Obx(() {
                          bool isLoading = false;

                          if (widget.experienceType == 'hospitality') {
                            isLoading = _EventController.isImagesLoading.value || widget.hospitalityController!.isSaudiHospitalityLoading.value; 
                          } else if (widget.experienceType == 'adventure') {
                            isLoading = _EventController.isImagesLoading.value||widget.adventureController!.isAdventureLoading.value;
                          }

                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else {
                            return CustomButton(
                                onPressed: () async {
                                  if (widget.experienceType == 'hospitality') {
                                    bool uploadSuccess =
                                        await uploadhostImages();
                                    if (uploadSuccess) {
                                      await createHospitalityExperience();
                                    } else {
                                      // Handle upload failure
                                    }
                                  } else if (widget.experienceType ==
                                      'adventure') {
                                    bool uploadSuccess =
                                        await uploadAdveImages();
                                    if (uploadSuccess) {
                                      await createAdventureExperience();
                                    } else {
                                      // Handle upload failure
                                    }
                                  }
                                },
                                title: 'Publish'.tr);
                          }
                        }),
                        SizedBox(height: 10),
                        CustomButton(
                            onPressed: () {
                              Get.until((route) =>
                                  Get.currentRoute == '/ExperienceType');
                            },
                            title: AppUtil.rtlDirection2(context)
                                ? 'عودة للتجارب'
                                : 'Return to Experiences',
                            buttonColor: Colors.white.withOpacity(0.3),
                            borderColor: Colors.white,
                            textColor: Color(0xFF070708)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String formatSelectedDates(RxList<dynamic> dates, BuildContext context) {
  // Convert dynamic list to List<DateTime>
  List<DateTime> dateTimeList = dates
      .where((date) => date is DateTime)
      .map((date) => date as DateTime)
      .toList();

  if (dateTimeList.isEmpty) {
    return 'DD/MM/YYYY';
  }

  // Sort the dates
  dateTimeList.sort();

  final bool isArabic = AppUtil.rtlDirection2(context);
  final intl.DateFormat dayFormatter =
      intl.DateFormat('d', isArabic ? 'ar' : 'en');
  final intl.DateFormat monthYearFormatter =
      intl.DateFormat('MMMM yyyy', isArabic ? 'ar' : 'en');

  String formattedDates = '';

  for (int i = 0; i < dateTimeList.length; i++) {
    if (i > 0) {
      // If current date's month and year are different from the previous date's, add a comma
      if (dateTimeList[i].month != dateTimeList[i - 1].month ||
          dateTimeList[i].year != dateTimeList[i - 1].year) {
        formattedDates += ', ';
      } else {
        // If same month and year, just add a space
        formattedDates += ', ';
      }
    }

    formattedDates += dayFormatter.format(dateTimeList[i]);

    // If the next date is in a different month or year, add month and year to the current date
    if (i == dateTimeList.length - 1 ||
        dateTimeList[i].month != dateTimeList[i + 1].month ||
        dateTimeList[i].year != dateTimeList[i + 1].year) {
      formattedDates += ' ${monthYearFormatter.format(dateTimeList[i])}';
    }
  }

  return formattedDates;
}
