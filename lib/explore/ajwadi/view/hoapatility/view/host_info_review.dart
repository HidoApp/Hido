import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/api/translation_api.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/widgets/AlertDialog.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/widgets/text_chip.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_publish_widget.dart';
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
  // final String hospitalityBioEn;
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

  const HostInfoReview({
    super.key,
    required this.hospitalityBioAr,
    // required this.hospitalityBioEn,
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
  List<String> priceIncludesEn = [];
  List<String> priceIncludesZh = [];

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

  void hostDaysInfo() {
    // Format for combining date and time
    var formatter = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    for (var date in widget.hospitalityController!.selectedDates) {
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

      // startTime = formatter.format(newStartTime);
      // endTime = formatter.format(newEndTime);

      var newEntry = {
        "startTime": formatter.format(newStartTime),
        "endTime": formatter.format(newEndTime),
        "seats": widget.hospitalityController!.seletedSeat.value
      };

      DaysInfo.add(newEntry);
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
        widget.adventureController!.selectedEndTime.value.millisecond,
      );

      //startTime = formatter.format(newStartTime);
      //endTime = formatter.format(newEndTime);

      var newEntry = {
        "startTime": formatter.format(newStartTime),
        "endTime": formatter.format(newEndTime),
        "seats": widget.adventureController!.seletedSeat.value
      };

      DaysInfo.add(newEntry);
    }
  }

  // Function to generate the Google Maps URL
  String getLocationUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  Future<bool> uploadhostImages() async {
    imageUrls.clear();

    //List<String> uploadedImagePaths = [];
    bool allExtensionsValid = true;
    bool allSizeValid = true;

    // Allowed formats
    final allowedFormats = ['jpg', 'jpeg', 'png'];
    const maxFileSizeInBytes = 2 * 1024 * 1024; // 2 MB

    for (XFile imagePath in widget.hospitalityController!.selectedImages) {
      String fileExtension = imagePath.path.split('.').last.toLowerCase();

      if (!allowedFormats.contains(fileExtension)) {
        allExtensionsValid = false;
        log('File ${imagePath.path} is not in an allowed format (${allowedFormats.join(', ')}).');

        if (context.mounted) {
          AppUtil.errorToast(context, 'uploadError'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
        return false;
      }
      final file = File(imagePath.path);

      final fileSize = await file.length();

      if (fileSize > maxFileSizeInBytes) {
        allSizeValid = false;

        if (context.mounted) {
          AppUtil.errorToast(context, 'imageSizeValid'.tr);
        }
        return false;
      }
    }
    // } else {

    //   final image = await _EventController.uploadProfileImages(
    //     file: File(imagePath.path),
    //     fileType: "hospitality",
    //     context: context,
    //   );

    //   //  File file = await convertImageToJpg(File(imagePath.path));
    //   //   final image = await _EventController.uploadProfileImages(
    //   //     file:file,
    //   //     fileType: "event",
    //   //     context: context,
    //   //   );

    //   if (image != null) {
    //     log('vaalid');

    //     imageUrls.add(image.filePath);
    //     log(image.filePath);
    //   } else {
    //     log('not vaalid');
    //     return false;
    //   }
    // }

    // ✅ If all files passed validation, upload them
    if (allExtensionsValid && allSizeValid) {
      for (XFile imagePath in widget.hospitalityController!.selectedImages) {
        final image = await _EventController.uploadProfileImages(
          file: File(imagePath.path),
          fileType: "hospitality",
          context: context,
        );

        if (image != null) {
          log('Uploaded: ${image.filePath}');
          imageUrls.add(image.filePath);
        } else {
          log('Upload failed for ${imagePath.path}');
          // if (context.mounted) {
          //   AppUtil.errorToast(context, 'Image upload failed.');
          // }
          // return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  Future<bool> uploadAdveImages() async {
    imageUrls.clear();

    bool allExtensionsValid = true;
    bool allSizeValid = true;

    // Allowed formats
    final allowedFormats = ['jpg', 'jpeg', 'png'];
    const maxFileSizeInBytes = 2 * 1024 * 1024; // 2 MB

    for (XFile imagePath in widget.adventureController!.selectedImages) {
      String fileExtension = imagePath.path.split('.').last.toLowerCase();

      if (!allowedFormats.contains(fileExtension)) {
        allExtensionsValid = false;
        log('File ${imagePath.path} is not in an allowed format (${allowedFormats.join(', ')}).');

        if (context.mounted) {
          AppUtil.errorToast(context, 'uploadError'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
        return false;
      }

      final file = File(imagePath.path);
      final fileSize = await file.length();

      if (fileSize > maxFileSizeInBytes) {
        allSizeValid = false;
        if (context.mounted) {
          AppUtil.errorToast(context, 'imageSizeValid'.tr);
        }
        return false;
      }
    }

    // ✅ If all files passed validation, upload them
    if (allExtensionsValid && allSizeValid) {
      for (XFile imagePath in widget.adventureController!.selectedImages) {
        final image = await _EventController.uploadProfileImages(
          file: File(imagePath.path),
          fileType: "adventures",
          context: context,
        );

        if (image != null) {
          log('Uploaded: ${image.filePath}');
          imageUrls.add(image.filePath);
        } else {
          log('Upload failed for ${imagePath.path}');
          // if (context.mounted) {
          //   AppUtil.errorToast(context, 'Image upload failed.');
          // }
          // return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  Future<void> translateReviewIncludeItinerary(dynamic controller) async {
    if (controller!.reviewincludeItenrary.isNotEmpty) {
      for (final item in controller!.reviewincludeItenrary) {
        final translatedEn = await TranslationApi.translate(item, 'en');
        final translatedZh = await TranslationApi.translate(item, 'zh');
        if (translatedEn.trim().isNotEmpty) {
          priceIncludesEn.add(translatedEn);
        }
        if (translatedZh.trim().isNotEmpty) {
          priceIncludesZh.add(translatedZh);
        }
      }
    }
  }

  Future<void> translateDescriptionFields() async {
    try {
      final arabicBioText = widget.hospitalityBioAr;
      final arabicTitleText = widget.hospitalityTitleAr;

      // Translate to English
      final translatedBioEn =
          await TranslationApi.translate(arabicBioText, 'en');
      // Translate to English
      final translatedTitleZh =
          await TranslationApi.translate(arabicTitleText, 'zh');

      // Translate to Chinese (Simplified)
      final translatedBioZh =
          await TranslationApi.translate(arabicBioText, 'zh');

      // Set the translated text
      if (widget.experienceType == 'hospitality') {
        widget.hospitalityController!.bioEn.value = translatedBioEn;
        widget.hospitalityController!.bioZh.value = translatedBioZh;
        widget.hospitalityController!.titleZh.value = translatedTitleZh;
      } else {
        widget.adventureController!.desEn.value = translatedBioEn;
        widget.adventureController!.desZh.value = translatedBioZh;
        widget.adventureController!.titleZh.value = translatedTitleZh;
      }
    } catch (e) {
      log('Translation failed: $e');
      TranslationApi.isTranslatingLoading.value = false;

      // Optionally show a snackbar or message here
    } finally {
      TranslationApi.isTranslatingLoading.value = false;
    }
  }

  Future<void> createHospitalityExperience() async {
    final isSuccess = await widget.hospitalityController!.createHospitality(
        titleAr: widget.hospitalityTitleAr,
        titleEn: widget.hospitalityTitleEn,
        titleZh: widget.hospitalityController!.titleZh.value,
        bioAr: widget.hospitalityBioAr,
        priceIncludesAr: widget.hospitalityController!.reviewincludeItenrary,
        priceIncludesEn: priceIncludesEn,
        priceIncludesZh: priceIncludesZh,
        // bioEn: widget.hospitalityBioEn,
        bioEn: widget.hospitalityController!.bioEn.value,
        bioZh: widget.hospitalityController!.bioZh.value,
        mealTypeAr: widget.hospitalityController!.selectedMealAr.value,
        mealTypeEn: widget.hospitalityController!.selectedMealEn.value,
        mealTypeZh: widget.hospitalityController!.selectedMealZh.value,
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
        //  start: startTime,
        // end: endTime,
        // seat: widget.hospitalityController!.seletedSeat.value,
        context: context);

    if (isSuccess) {
      log('puplished');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomPublishDialog(
            icon: 'publish.svg',
            title: 'ExperienceSent'.tr,
            description: 'ExperienceSentDes'.tr,
            bgIconColor: const Color(0xFFEDFCF2),
          );
        },
      ).then((_) {
        AmplitudeService.amplitude.track(
            BaseEvent('Hospitality published successfully', eventProperties: {
          'titleAr:': widget.hospitalityTitleAr,
        }));
        Get.offAll(() => const AjwadiBottomBar());
      });
    } else {
      AmplitudeService.amplitude
          .track(BaseEvent('Hospitality published failed', eventProperties: {
        'titleAr:': widget.hospitalityTitleAr,
      }));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
                dialogWidth: 308,
                dialogHight: 196,
                title: 'ExperienceNotSent'.tr,
                buttonTitle2: 'contactUs'.tr,
                buttonTitle1: 'TryAgain'.tr,
                buttonColor2: Colors.white.withOpacity(0.3),
                icon: 'Alertsc.svg');
          });
    }
  }

  Future<void> createAdventureExperience() async {
    final isSuccess = await widget.adventureController!.createAdventure(
      nameAr: widget.hospitalityTitleAr,
      nameEn: widget.hospitalityTitleEn,
      nameZh: widget.adventureController!.titleZh.value,
      descriptionAr: widget.hospitalityBioAr,
      descriptionEn: widget.adventureController!.desEn.value,
      descriptionZh: widget.adventureController!.desZh.value,
      priceIncludesAr: widget.adventureController!.reviewincludeItenrary,
      priceIncludesEn: priceIncludesEn,
      priceIncludesZh: priceIncludesZh,
      longitude: widget.adventureController!.pickUpLocLatLang.value.longitude
          .toString(),
      latitude: widget.adventureController!.pickUpLocLatLang.value.latitude
          .toString(),
      daysInfo: DaysInfo,
      //  date: widget.adventureController!.selectedDate.value.substring(0, 10),
      price: widget.adventurePrice!,
      image: imageUrls,
      regionAr: widget.adventureController!.ragionAr.value,
      locationUrl: locationUrl,
      regionEn: widget.adventureController!.ragionEn.value,
      seat: widget.adventureController!.seletedSeat.value,
      context: context,
    );

    if (isSuccess) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomPublishDialog(
            icon: 'publish.svg',
            title: 'ExperienceSent'.tr,
            description: 'ExperienceSentDes'.tr,
            bgIconColor: const Color(0xFFEDFCF2),
          );
        },
      ).then((_) {
        AmplitudeService.amplitude.track(
            BaseEvent('Adventure published successfully', eventProperties: {
          'title:': widget.hospitalityTitleAr,
        }));
        Get.offAll(() => const AjwadiBottomBar());
      });
    } else {
      AmplitudeService.amplitude
          .track(BaseEvent('Adventure published Failed', eventProperties: {
        'title:': widget.hospitalityTitleAr,
      }));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
                dialogWidth: 308,
                dialogHight: 196,
                title: 'ExperienceNotSent'.tr,
                buttonTitle2: 'contactUs'.tr,
                buttonTitle1: 'TryAgain'.tr,
                buttonColor2: Colors.white.withOpacity(0.3),
                icon: 'Alertsc.svg');
          });
    }
  }

  @override
  void initState() {
    super.initState();
    // _fetchAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.experienceType == 'hospitality') {
        // daysInfo();
        hostDaysInfo();
        if (widget.hospitalityController!.isHospatilityDateSelcted.value) {
          widget.hospitalityController!.newRangeTimeErrorMessage.value =
              AppUtil.areAllDatesTimeBefore(
                  widget.hospitalityController!.selectedDates,
                  widget.hospitalityController!.selectedStartTime.value);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.experienceType == 'adventure') {
        advDates();
        if (widget.adventureController!.isAdventureDateSelcted.value) {
          widget.adventureController!.newRangeTimeErrorMessage.value =
              AppUtil.areAllDatesTimeBefore(
                  widget.adventureController!.selectedDates,
                  widget.adventureController!.selectedStartTime.value);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        locationUrl = widget.experienceType == 'hospitality'
            ? getLocationUrl(
                widget.hospitalityController!.pickUpLocLatLang.value)
            : getLocationUrl(
                widget.adventureController!.pickUpLocLatLang.value);
      });
    });
    // log(widget.hospitalityController!.reviewincludeItenrary.last.toString());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

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
              color: const Color(0xFF070708),
              fontSize: 17,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: CustomText(
                text: widget.experienceType == 'hospitality'
                    ? 'explination'.tr
                    : 'explinationAdve'.tr,
                color: const Color(0xFF9392A0),
                fontSize: 15,
                maxlines: 200,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                fontWeight: FontWeight.w400,
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
                shadows: const [
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
                        SizedBox(height: width * 0.01),
                        CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? widget.hospitalityTitleAr
                              : widget.hospitalityTitleEn.isEmpty
                                  ? 'Not title yet'
                                  : widget.hospitalityTitleEn,
                          fontSize: width * 0.041,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: width * 0.02),
                        Wrap(
                          spacing: width * 0.013, // space between chips
                          runSpacing:
                              width * 0.013, //  space when wrapping to new line
                          children: [
                            TextChip(
                              text: widget.experienceType == 'hospitality'
                                  ? AppUtil.rtlDirection2(context)
                                      ? widget
                                          .hospitalityController!.ragionAr.value
                                      : widget
                                          .hospitalityController!.ragionEn.value
                                  : AppUtil.rtlDirection2(context)
                                      ? widget
                                          .adventureController!.ragionAr.value
                                      : widget
                                          .adventureController!.ragionEn.value,
                              // ? AppUtil.rtlDirection2(context)
                              //     ? '${widget.hospitalityController!.ragionAr.value}, $address'
                              //     : '${widget.hospitalityController!.ragionEn.value}, $address'
                              // : AppUtil.rtlDirection2(context)
                              //     ? '${widget.adventureController!.ragionAr.value}, $address'
                              //     : '${widget.adventureController!.ragionEn.value}, $address',
                            ),
                            if (widget.experienceType == 'hospitality')
                              TextChip(
                                text:
                                    '${AppUtil.formatSelectedDates(widget.hospitalityController!.selectedDates, context)} - ${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(widget.hospitalityController!.selectedStartTime.value))}',
                              ),
                            if (widget.experienceType == 'adventure')
                              TextChip(
                                text: AppUtil.formatSelectedDates(
                                    widget.adventureController!.selectedDates,
                                    context),
                              ),
                            if (widget.experienceType == 'adventure')
                              TextChip(
                                text:
                                    '${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(widget.adventureController!.selectedStartTime.value))} - ${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(widget.adventureController!.selectedEndTime.value))}',
                              ),
                            if (widget.experienceType == 'hospitality')
                              TextChip(
                                text: AppUtil.rtlDirection2(context)
                                    ? widget.hospitalityController!
                                        .selectedMealAr.value
                                    : widget.hospitalityController!
                                        .selectedMealEn.value,
                              ),
                            if (widget.experienceType == 'hospitality')
                              TextChip(
                                text: widget
                                    .hospitalityController!.selectedGender.value
                                    .toLowerCase()
                                    .tr,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
                            isLoading =
                                _EventController.isImagesLoading.value ||
                                    TranslationApi.isTranslatingLoading.value ||
                                    widget.hospitalityController!
                                        .isSaudiHospitalityLoading.value;
                          } else if (widget.experienceType == 'adventure') {
                            isLoading =
                                _EventController.isImagesLoading.value ||
                                    TranslationApi.isTranslatingLoading.value ||
                                    widget.adventureController!
                                        .isAdventureLoading.value;
                          }

                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else {
                            return CustomButton(
                                onPressed: () async {
                                  if (widget.experienceType == 'hospitality') {
                                    widget.hospitalityController!
                                            .newRangeTimeErrorMessage.value =
                                        AppUtil.areAllDatesTimeBefore(
                                            widget.hospitalityController!
                                                .selectedDates,
                                            widget.hospitalityController!
                                                .selectedStartTime.value);

                                    if (!widget.hospitalityController!
                                        .newRangeTimeErrorMessage.value) {
                                      bool uploadSuccess =
                                          await uploadhostImages();

                                      if (uploadSuccess) {
                                        await translateDescriptionFields();
                                        await translateReviewIncludeItinerary(
                                            widget.hospitalityController);
                                        await createHospitalityExperience();
                                      } else {
                                        // Handle upload failure
                                      }
                                    } else {
                                      if (context.mounted) {
                                        AppUtil.errorToast(
                                            context, 'StartTimeDuration'.tr);
                                        await Future.delayed(
                                            const Duration(seconds: 3));
                                      }
                                    }
                                  } else if (widget.experienceType ==
                                      'adventure') {
                                    widget.adventureController!
                                            .newRangeTimeErrorMessage.value =
                                        AppUtil.areAllDatesTimeBefore(
                                            widget.adventureController!
                                                .selectedDates,
                                            widget.adventureController!
                                                .selectedStartTime.value);

                                    if (!widget.adventureController!
                                        .newRangeTimeErrorMessage.value) {
                                      bool uploadSuccess =
                                          await uploadAdveImages();
                                      if (uploadSuccess) {
                                        await translateDescriptionFields();
                                        await translateReviewIncludeItinerary(
                                            widget.adventureController);

                                        await createAdventureExperience();
                                      } else {
                                        // Handle upload failure
                                      }
                                    } else {
                                      if (context.mounted) {
                                        AppUtil.errorToast(
                                            context, 'StartTimeDuration'.tr);
                                        await Future.delayed(
                                            const Duration(seconds: 3));
                                      }
                                    }
                                  }
                                },
                                title: 'Publish'.tr,
                                buttonColor:
                                    widget.experienceType == 'hospitality'
                                        ? widget.hospitalityController!
                                                .newRangeTimeErrorMessage.value
                                            ? lightGreen
                                            : colorGreen
                                        : widget.adventureController!
                                                .newRangeTimeErrorMessage.value
                                            ? lightGreen
                                            : colorGreen,
                                borderColor:
                                    widget.experienceType == 'hospitality'
                                        ? widget.hospitalityController!
                                                .newRangeTimeErrorMessage.value
                                            ? lightGreen
                                            : colorGreen
                                        : widget.adventureController!
                                                .newRangeTimeErrorMessage.value
                                            ? lightGreen
                                            : colorGreen);
                          }
                        }),
                        const SizedBox(height: 10),
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
                            textColor: const Color(0xFF070708)),
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
  List<DateTime> dateTimeList =
      dates.whereType<DateTime>().map((date) => date as DateTime).toList();

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
