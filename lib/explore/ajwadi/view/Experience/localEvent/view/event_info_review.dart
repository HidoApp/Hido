import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/api/translation_api.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/widgets/AlertDialog.dart';
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
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img; // Import the image package

class EventInfoReview extends StatefulWidget {
  final String hospitalityTitleEn;
  // final String hospitalityBioEn;
  final String hospitalityTitleAr;
  final String hospitalityBioAr;
  final String hospitalityLocation;
  final double? adventurePrice;

  const EventInfoReview({
    super.key,
    required this.hospitalityBioAr,
    // required this.hospitalityBioEn,
    required this.hospitalityTitleAr,
    required this.hospitalityTitleEn,
    required this.hospitalityLocation,
    // required this.seats,
    // required this.gender,
    this.adventurePrice,
  });

  @override
  _EventInfoReviewState createState() => _EventInfoReviewState();
}

class _EventInfoReviewState extends State<EventInfoReview> {
  String address = '';
  String startTime = '';
  String endTime = '';
  List<String> imageUrls = [];
  List<Map<String, dynamic>> DaysInfo = [];
  // String ragionAr = '';
  // String ragionEn = '';
  final EventController _EventController = Get.put(EventController());

  String locationUrl = '';

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
        //    if (!regionListEn.contains(ragionEn) || !regionListAr.contains(ragionAr)) {
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
      String result =
          await _getAddressFromLatLng(_EventController.pickUpLocLatLang.value);
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
    //DateTime date = DateTime.parse(_EventController.selectedDate.value);

    for (var date in _EventController.selectedDates) {
      DateTime newStartTime = DateTime(
          date.year,
          date.month,
          date.day,
          _EventController.selectedStartTime.value.hour,
          _EventController.selectedStartTime.value.minute,
          _EventController.selectedStartTime.value.second,
          _EventController.selectedStartTime.value.millisecond);
      DateTime newEndTime = DateTime(
          date.year,
          date.month,
          date.day,
          _EventController.selectedEndTime.value.hour,
          _EventController.selectedEndTime.value.minute,
          _EventController.selectedEndTime.value.second,
          _EventController.selectedEndTime.value.millisecond);

      //startTime = formatter.format(newStartTime);
      //endTime = formatter.format(newEndTime);

      var newEntry = {
        "startTime": formatter.format(newStartTime),
        "endTime": formatter.format(newEndTime),
        "seats": _EventController.seletedSeat.value
      };

      DaysInfo.add(newEntry);
    }

    // Print the new dates list
  }

  //   for (var date in widget.hospitalityController.selectedDates) {
  //     DateTime newStartTime = DateTime(
  //         date.year,
  //         date.month,
  //         date.day,
  //         widget.hospitalityController.selectedStartTime.value.hour,
  //         widget.hospitalityController.selectedStartTime.value.minute,
  //         widget.hospitalityController.selectedStartTime.value.second,
  //         widget.hospitalityController.selectedStartTime.value.millisecond);
  //     DateTime newEndTime = DateTime(
  //         date.year,
  //         date.month,
  //         date.day,
  //         widget.hospitalityController.selectedEndTime.value.hour,
  //         widget.hospitalityController.selectedEndTime.value.minute,
  //         widget.hospitalityController.selectedEndTime.value.second,
  //         widget.hospitalityController.selectedEndTime.value.millisecond);

  //     startTime = formatter.format(newStartTime);
  //     endTime = formatter.format(newEndTime);

  //     var newEntry = {
  //       "startTime": formatter.format(newStartTime),
  //       "endTime": formatter.format(newEndTime),
  //       "seats": widget.hospitalityController.seletedSeat
  //     };

  //     DaysInfo.add(newEntry);
  //   }

  //   // Print the new dates list
  //
  // }

  // Function to generate the Google Maps URL
  String getLocationUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  @override
  void initState() {
    super.initState();
    // _fetchAddress();

    daysInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_EventController.isEventDateSelcted.value) {
        _EventController.newRangeTimeErrorMessage.value =
            AppUtil.areAllDatesTimeBefore(_EventController.selectedDates,
                _EventController.selectedStartTime.value);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        locationUrl = getLocationUrl(_EventController.pickUpLocLatLang.value);
      });
      // _fetchAddress();
    });
  }

  Future<bool> uploadImages() async {
    bool allExtensionsValid = true;
    bool allSizeValid = true;

    // Allowed formats
    final allowedFormats = ['jpg', 'jpeg', 'png'];
    const maxFileSizeInBytes = 2 * 1024 * 1024; //  2 MB

    for (XFile imagePath in _EventController.selectedImages) {
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
      if (fileSize >= maxFileSizeInBytes) {
        allSizeValid = false;
        if (context.mounted) {
          AppUtil.errorToast(context, 'imageSizeValid'.tr);
        }
        return false;
      }
    }

    //If all files passed validation, upload them
    if (allExtensionsValid && allSizeValid) {
      for (XFile imagePath in _EventController.selectedImages) {
        final image = await _EventController.uploadProfileImages(
          file: File(imagePath.path),
          fileType: "event",
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
    }
    return true;
  }

  // Future<bool> uploadImages() async {
  //   //List<String> uploadedImagePaths = [];
  //   bool allExtensionsValid = true;

  //   // Allowed formats
  //   final allowedFormats = ['jpg', 'jpeg', 'png'];

  //   for (XFile imagePath in _EventController.selectedImages) {
  //     String fileExtension = imagePath.path.split('.').last.toLowerCase();
  //     if (!allowedFormats.contains(fileExtension)) {
  //       allExtensionsValid = false;
  //       print(
  //           'File ${imagePath.path} is not in an allowed format (${allowedFormats.join(', ')}).');
  //     }
  //     if (!allExtensionsValid) {
  //       if (context.mounted) {
  //         AppUtil.errorToast(context, 'uploadError'.tr);
  //         await Future.delayed(const Duration(seconds: 3));
  //       }
  //       return false;
  //     } else {
  //       final image = await _EventController.uploadProfileImages(
  //         file: File(imagePath.path),
  //         fileType: "event",
  //         context: context,
  //       );

  //       //  File file = await convertImageToJpg(File(imagePath.path));
  //       //   final image = await _EventController.uploadProfileImages(
  //       //     file:file,
  //       //     fileType: "event",
  //       //     context: context,
  //       //   );

  //       if (image != null) {
  //         log('vaalid');

  //         imageUrls.add(image.filePath);
  //         log(image.filePath);
  //       } else {
  //         log('not vaalid');
  //         return false;
  //       }
  //     }
  //   }
  //   return true;

  //   // Handle the list of uploaded image paths as needed
  // }
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
      _EventController.bioEn.value = translatedBioEn;
      _EventController.bioZh.value = translatedBioZh;
      _EventController.titleZh.value = translatedTitleZh;
    } catch (e) {
      log('Translation failed: $e');
      // Optionally show a snackbar or message here
    } finally {
      TranslationApi.isTranslatingLoading.value = false;
    }
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
                text: 'Reviewevent'.tr,
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
                  text: 'explinationEvent'.tr,
                  color: const Color(0xFF9392A0),
                  fontSize: 15,
                  maxlines: 200,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  fontWeight: FontWeight.w500,
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
                          image:
                              //NetworkImage(imageUrls[0]),
                              FileImage(File(
                                  _EventController.selectedImages[0].path)),
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
                            color: const Color(0xFF070708),
                            fontSize: width * 0.041,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: width * 0.02),
                          Wrap(
                              spacing: width * 0.013, // space between chips
                              runSpacing: width *
                                  0.013, //  space when wrapping to new line
                              children: [
                                TextChip(
                                  text: AppUtil.rtlDirection2(context)
                                      ? _EventController.ragionAr.value
                                      : _EventController.ragionEn.value,
                                  // ? '${_EventController.ragionAr.value}, $address'
                                  // : '${_EventController.ragionEn.value}, $address',
                                ),
                                TextChip(
                                    text: AppUtil.formatSelectedDates(
                                        _EventController.selectedDates,
                                        context)),
                                TextChip(
                                  text:
                                      '${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(_EventController.selectedStartTime.value))} - ${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(_EventController.selectedEndTime.value))}',
                                ),
                              ]),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 35),
                      child: Column(
                        children: [
                          Obx(
                            () => _EventController.isImagesLoading.value ||
                                    TranslationApi.isTranslatingLoading.value ||
                                    _EventController.isEventLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                : CustomButton(
                                    onPressed: _EventController
                                            .newRangeTimeErrorMessage.value
                                        ? () async {
                                            if (context.mounted) {
                                              AppUtil.errorToast(context,
                                                  'StartTimeDuration'.tr);
                                              await Future.delayed(
                                                  const Duration(seconds: 3));
                                            }
                                          }
                                        : () async {
                                            _EventController
                                                    .newRangeTimeErrorMessage
                                                    .value =
                                                AppUtil.areAllDatesTimeBefore(
                                                    _EventController
                                                        .selectedDates,
                                                    _EventController
                                                        .selectedStartTime
                                                        .value);

                                            if (!_EventController
                                                .newRangeTimeErrorMessage
                                                .value) {
                                              uploadImages()
                                                  .then((value) async {
                                                if (!value) {
                                                } else {
                                                  await translateDescriptionFields();

                                                  final isSuccess = await _EventController.createEvent(
                                                      nameAr: _EventController
                                                          .titleAr.value,
                                                      nameEn: _EventController
                                                          .titleEn.value,
                                                      nameZh: _EventController
                                                          .titleZh.value,
                                                      descriptionAr: _EventController
                                                          .bioAr.value,
                                                      descriptionEn: _EventController
                                                          .bioEn.value,
                                                      descriptionZh:
                                                          _EventController
                                                              .bioZh.value,
                                                      longitude: _EventController
                                                          .pickUpLocLatLang
                                                          .value
                                                          .longitude
                                                          .toString(),
                                                      latitude: _EventController
                                                          .pickUpLocLatLang
                                                          .value
                                                          .latitude
                                                          .toString(),
                                                      price: widget
                                                          .adventurePrice!,
                                                      image: imageUrls,
                                                      regionAr: _EventController
                                                          .ragionAr.value,
                                                      locationUrl: locationUrl,
                                                      daysInfo: DaysInfo,
                                                      regionEn: _EventController.ragionEn.value,
                                                      context: context);

                                                  if (isSuccess) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomPublishDialog(
                                                          icon: 'publish.svg',
                                                          title:
                                                              'ExperienceSent'
                                                                  .tr,
                                                          description:
                                                              'ExperienceSentDes'
                                                                  .tr,
                                                          bgIconColor:
                                                              const Color(
                                                                  0xFFEDFCF2),
                                                        );
                                                      },
                                                    ).then((_) {
                                                      AmplitudeService.amplitude
                                                          .track(BaseEvent(
                                                              'Event published successfully',
                                                              eventProperties: {
                                                            'event:':
                                                                _EventController
                                                                    .titleAr
                                                                    .value,
                                                          }));
                                                      Get.offAll(() =>
                                                          const AjwadiBottomBar());
                                                    });
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CustomAlertDialog(
                                                              dialogWidth: 308,
                                                              dialogHight: 196,
                                                              title:
                                                                  'ExperienceNotSent'
                                                                      .tr,
                                                              buttonTitle2:
                                                                  'contactUs'
                                                                      .tr,
                                                              buttonTitle1:
                                                                  'TryAgain'.tr,
                                                              buttonColor2: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.3),
                                                              icon:
                                                                  'Alertsc.svg');
                                                        });
                                                  }
                                                }
                                              });
                                            } else {
                                              if (context.mounted) {
                                                AppUtil.errorToast(context,
                                                    'StartTimeDuration'.tr);
                                                await Future.delayed(
                                                    const Duration(seconds: 3));
                                              }
                                            }
                                          },
                                    title: 'Publish'.tr,
                                    buttonColor: _EventController
                                            .newRangeTimeErrorMessage.value
                                        ? lightGreen
                                        : colorGreen,
                                    borderColor: _EventController
                                            .newRangeTimeErrorMessage.value
                                        ? lightGreen
                                        : colorGreen),
                          ),
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
        ));
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

String extractMonths(context, String datesString) {
  // Remove brackets and split by comma to get individual date strings
  List<String> dateStrings =
      datesString.replaceAll('[', '').replaceAll(']', '').split(', ');

  String locale = AppUtil.rtlDirection2(context) ? 'ar' : 'en';

  // Parse each date string and extract the month
  List<String> monthsList = dateStrings.map((dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.MMMM(locale).format(dateTime);
  }).toList();

  // Check if all months are the same
  bool allSame = monthsList.every((month) => month == monthsList[0]);

  if (allSame) {
    return [monthsList[0]].join(',');
  } else {
    return monthsList.join(', ');
  }
}
