import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/api/translation_api.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/local/controllers/local_explore_controller.dart';
import 'package:ajwad_v4/explore/local/view/add_event_calender_dialog.dart';
import 'package:ajwad_v4/explore/local/view/hoapatility/widget/image_slider.dart';
import 'package:ajwad_v4/request/local/view/view_experience_images.dart';
import 'package:ajwad_v4/request/local/view/widget/include_card.dart';
import 'package:ajwad_v4/request/local/view/widget/review_include_card.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:intl/intl.dart' as intl;

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditAdventure extends StatefulWidget {
  const EditAdventure({
    Key? key,
    required this.adventureObj,
    // this.experienceType,
  }) : super(key: key);

  final Adventure adventureObj;
  // final String? experienceType;

  @override
  State<EditAdventure> createState() => _EditAdventureState();
}

late double width, height;

class _EditAdventureState extends State<EditAdventure> {
  final _servicesController = Get.put(AdventureController());
  List<Map<String, dynamic>> daysInfo = [];

  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN
  bool _isLoading = true;

  List<DateTime> avilableDate = [];
  var locLatLang = const LatLng(24.691846000000012, 46.68552199999999);
  final TextEditingController adventureTitleControllerEn =
      TextEditingController();
  final TextEditingController adventureBioControllerEn =
      TextEditingController();

  final TextEditingController adventureTitleControllerAr =
      TextEditingController();
  final TextEditingController adventureBioControllerAr =
      TextEditingController();
  List<String> imageUrls = [];
  final _eventController = Get.put(EventController());

  String address = '';
  // String ragionAr = '';
  // String ragionEn = '';

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
  late LatLng _currentPosition;
  var hideLocation = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //addCustomIcon();

    _servicesController.isAdventureDateSelcted(false);
    _servicesController.selectedDate('');
    _servicesController.selectedDateIndex(-1);
    _servicesController.reviewincludeItenrary([]);

    _loadImages();

    updateData();
    _currentPosition = LatLng(
      _servicesController.pickUpLocLatLang.value.latitude,
      _servicesController.pickUpLocLatLang.value.longitude,
    );
    _fetchAddress();
  }

  Future<void> _loadImages() async {
    List<dynamic> images = [];
    _servicesController.images.clear();
    for (var path in widget.adventureObj.image!) {
      images.add(
          path); // Add all paths to the list, they can be URLs or File paths.
    }

    setState(() {
      _servicesController.images.addAll(images);
    });
  }

  Future<bool> uploadImages() async {
    imageUrls.clear();

    for (int i = 0; i < _servicesController.images.length; i++) {
      var image = _servicesController.images[i];
      if (image is String && Uri.parse(image).isAbsolute) {
        imageUrls.add(image);
      } else {
        final imageFile = await _eventController.uploadProfileImages(
          file: File(image.path),
          fileType: "adventures",
          context: context,
        );

        if (imageFile != null) {
          log('Uploaded: ${imageFile.filePath}');
          imageUrls.add(imageFile.filePath);
        } else {
          log('Upload failed for ${image.path}');
        }
      }
    }

    return true;
  }

  void addDaysInfo() {
    var formatter = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    for (var date in _servicesController.selectedDates) {
      DateTime newStartTime = DateTime(
          date.year,
          date.month,
          date.day,
          newTimeToGo.hour,
          newTimeToGo.minute,
          newTimeToGo.second,
          newTimeToGo.millisecond);
      DateTime newEndTime = DateTime(
          date.year,
          date.month,
          date.day,
          newTimeToReturn.hour,
          newTimeToReturn.minute,
          newTimeToReturn.second,
          newTimeToReturn.millisecond);

      //startTime = formatter.format(newStartTime);
      //endTime = formatter.format(newEndTime);

      var newEntry = {
        "startTime": formatter.format(newStartTime),
        "endTime": formatter.format(newEndTime),
        "seats": guestNum
      };

      daysInfo.add(newEntry);
    }

    // Print the new dates list
  }

  Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1, position2);

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
        //   if (!regionListEn.contains(ragionEn) ||
        //       !regionListAr.contains(ragionAr)) {
        //     setState(() {
        //       ragionAr = 'الرياض';
        //       ragionEn = 'Riyadh';
        //     });
        //   }
        // });
        return '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
      }
    } catch (e) {}
    return '';
  }

  Future<void> _fetchAddress() async {
    double latitude = _currentPosition.latitude;
    double longitude = _currentPosition.longitude;
    String fetchedAddress = await _getAddressFromLatLng(latitude, longitude);
    setState(() {
      address = fetchedAddress;
      _isLoading = false;
    });
  }

  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();

  final int? _selectedRadio1 = 1;
  int guestNum = 0;
  String startTime = '';
  String endTime = '';

  int? _selectedRadio2;
  String mealTypeEn = '';
  String mealTypeAr = '';
  bool titleENEmpty = false;
  bool titleArEmpty = false;
  String locationUrl = '';
  bool bioArEmpty = false;
  bool bioEnEmpty = false;

  bool guestEmpty = false;
  bool PriceEmpty = false;
  bool PriceLarger = false;
  bool PriceDouble = false;

  List<String> priceIncludesEn = [];
  List<String> priceIncludesZh = [];
  bool? DateDurationError;

  LocalExploreController ajwadiExploreController =
      Get.put(LocalExploreController());

  String gender = '';

  Future<void> translateIncludesList() async {
    final current = _servicesController.reviewincludeItenrary;

    if (current.isNotEmpty) {
      for (int i = 0; i < current.length; i++) {
        final isNew = i >= widget.adventureObj.priceIncludesAr!.length;
        final isChanged = !isNew &&
            current[i].trim() != widget.adventureObj.priceIncludesAr![i].trim();

        if ((isNew || isChanged) && current[i].trim().isNotEmpty) {
          final translatedEn = await TranslationApi.translate(current[i], 'en');
          final translatedZh = await TranslationApi.translate(current[i], 'zh');
          if (translatedEn.trim().isNotEmpty) {
            if (isNew) {
              widget.adventureObj.priceIncludesEn!.add(translatedEn.trim());
            } else {
              widget.adventureObj.priceIncludesEn![i] = translatedEn.trim();
            }
          }
          if (translatedZh.trim().isNotEmpty) {
            if (isNew) {
              widget.adventureObj.priceIncludesZh!.add(translatedZh.trim());
            } else {
              widget.adventureObj.priceIncludesZh![i] = translatedZh.trim();
            }
          }
        }
      }
    } else {
      widget.adventureObj.priceIncludesEn!.clear();
      widget.adventureObj.priceIncludesZh!.clear();
    }
  }

  Future<void> translateDescriptionFields() async {
    try {
      final currentTitleArValue = adventureTitleControllerAr.text;
      final currentBioeArValue = adventureBioControllerAr.text;

      final currentTitleEnValue = adventureTitleControllerEn.text;
      final currentBioEnValue = adventureBioControllerEn.text;

      if ((currentTitleArValue != widget.adventureObj.nameAr &&
          currentTitleArValue.isNotEmpty)) {
        final translatedTitleZh =
            await TranslationApi.translate(currentTitleArValue, 'zh');

        if (translatedTitleZh.isNotEmpty) {
          _servicesController.titleZh.value = translatedTitleZh;
        }
      } else if ((currentTitleEnValue != widget.adventureObj.nameEn &&
          currentTitleEnValue.isNotEmpty)) {
        final translatedTitleZh =
            await TranslationApi.translate(currentTitleEnValue, 'zh');

        if (translatedTitleZh.isNotEmpty) {
          _servicesController.titleZh.value = translatedTitleZh;
        }
      }
      if ((currentBioeArValue != widget.adventureObj.descriptionAr &&
          currentBioeArValue.isNotEmpty)) {
        final translatedBioZh =
            await TranslationApi.translate(currentBioeArValue, 'zh');
        if (translatedBioZh.isNotEmpty) {
          _servicesController.desZh.value = translatedBioZh;
        }
      } else if ((currentBioEnValue != widget.adventureObj.descriptionEn &&
          currentBioEnValue.isNotEmpty)) {
        final translatedBioZh =
            await TranslationApi.translate(currentBioEnValue, 'zh');
        if (translatedBioZh.isNotEmpty) {
          _servicesController.desZh.value = translatedBioZh;
        }
      }
    } catch (e) {
      log('Translation failed: $e');
      TranslationApi.isTranslatingLoading.value = false;
    } finally {
      TranslationApi.isTranslatingLoading.value = false;
    }
  }

  Future<void> validateAndSave() async {
    setState(() {
      titleArEmpty = adventureTitleControllerAr.text.isEmpty;
      bioArEmpty = adventureBioControllerAr.text.isEmpty;

      titleENEmpty = adventureTitleControllerEn.text.isEmpty;
      bioEnEmpty = adventureBioControllerEn.text.isEmpty;

      _selectedLanguageIndex =
          (titleArEmpty || bioArEmpty) && !(titleENEmpty && bioEnEmpty) ? 0 : 1;

      guestEmpty = guestNum == 0;

      // DateErrorMessage = !_servicesController.isAdventureDateSelcted.value;
      // TimeErrorMessage = !_servicesController.isAdventureTimeSelcted.value;
      _servicesController.EmptyDateErrorMessage.value =
          !_servicesController.isAdventureDateSelcted.value ||
              _servicesController.selectedDates.isEmpty;
      _servicesController.EmptyTimeErrorMessage.value =
          !_servicesController.isAdventureTimeSelcted.value;
      _servicesController.DateErrorMessage.value =
          !AppUtil.areAllDatesAfter24Hours(_servicesController.selectedDates);
      _servicesController.newRangeTimeErrorMessage.value =
          AppUtil.areAllDatesTimeBefore(_servicesController.selectedDates,
              _servicesController.selectedStartTime.value);

      // _servicesController.DateErrorMessage.value =
      //     AppUtil.isDateBefore24Hours(_servicesController.selectedDate.value);
      // _servicesController.newRangeTimeErrorMessage.value =
      //     AppUtil.isDateTimeBefore(_servicesController.selectedDate.value,
      //         _servicesController.selectedStartTime.value);

      PriceEmpty = _priceController.text.isEmpty;
      if (_priceController.text.isNotEmpty) {
        int? price = int.tryParse(_priceController.text);
        PriceLarger = price == null || price < 150;

        //check if price not int
        String priceText = _priceController.text;
        RegExp doubleRegex = RegExp(r'^[0-9]*\.[0-9]+$');
        PriceDouble = doubleRegex.hasMatch(priceText);
      }
    });

    if (!titleArEmpty &&
        !bioArEmpty &&
        !titleENEmpty &&
        !bioEnEmpty &&
        !guestEmpty &&
        // !DateErrorMessage! &&
        // !TimeErrorMessage! &&
        !_servicesController.EmptyDateErrorMessage.value &&
        !_servicesController.EmptyTimeErrorMessage.value &&
        !PriceEmpty &&
        !PriceLarger &&
        !PriceDouble &&
        !_servicesController.DateErrorMessage.value &&
        !_servicesController.TimeErrorMessage.value &&
        !_servicesController.newRangeTimeErrorMessage.value && //new srs
        _servicesController.images.length >= 3) {
      // if (await uploadImages()) {
      imageUrls = await AppUtil.uploadImagesHelper(
          PickedImages: _servicesController.images,
          imageUrl: imageUrls,
          controller: _eventController,
          fileType: 'adventures',
          context: context);
      addDaysInfo();
      await translateDescriptionFields();
      await translateIncludesList();
      await _updateAdventure();
      // }
      // else {
      //   if (context.mounted) {
      //     AppUtil.errorToast(context, 'uploadError'.tr);
      //     await Future.delayed(const Duration(seconds: 3));
      //   }
      // }
    } else {
      if (_servicesController.DateErrorMessage.value) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'DateDuration'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
      } // new srs
      else if (_servicesController.newRangeTimeErrorMessage.value) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'StartTimeDuration'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
      } else if (_servicesController.TimeErrorMessage.value) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'TimeDuration'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
      } else if (_servicesController.images.length < 3) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'imageError'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
      } else {}
    }
  }

  void updateData() {
    setState(() {
      adventureTitleControllerAr.text = widget.adventureObj.nameAr!;
      adventureBioControllerAr.text = widget.adventureObj.descriptionAr!;

      adventureTitleControllerEn.text = widget.adventureObj.nameEn!;
      adventureBioControllerEn.text = widget.adventureObj.descriptionEn!;

      _servicesController.titleZh.value = widget.adventureObj.nameZh!;
      _servicesController.desZh.value = widget.adventureObj.descriptionZh!;

      guestNum = widget.adventureObj.daysInfo!.isNotEmpty
          ? widget.adventureObj.daysInfo!.first.seats
          : 0;

      newTimeToGo = widget.adventureObj.daysInfo!.isNotEmpty
          ? DateTime.parse(widget.adventureObj.daysInfo!.first.startTime)
          : DateTime.now();

      newTimeToReturn = widget.adventureObj.daysInfo!.isNotEmpty
          ? DateTime.parse(widget.adventureObj.daysInfo!.first.endTime)
          : DateTime.now();

      _servicesController.selectedStartTime.value = newTimeToGo; //new
      _servicesController.selectedEndTime.value = newTimeToReturn; //new

      if (widget.adventureObj.daysInfo!.isNotEmpty) {
        bool allDatesInPast =
            true; // Flag to check if all dates are in the past

        for (var info in widget.adventureObj.daysInfo!) {
          DateTime startDateTime = DateTime.parse(info.startTime);
          if (startDateTime.isAfter(DateTime.now())) {
            allDatesInPast = false;
          }
          _servicesController.selectedDates.add(DateTime(
              startDateTime.year, startDateTime.month, startDateTime.day));
        }

        if (allDatesInPast) {
          _servicesController.selectedDates.clear();
        }
      } else {
        _servicesController.selectedDates.add(DateTime.now());
      }

      // _servicesController.DateErrorMessage.value = true;

      _servicesController.isAdventureDateSelcted.value =
          widget.adventureObj.daysInfo!.isNotEmpty ? true : false;
      _servicesController.isAdventureTimeSelcted.value =
          widget.adventureObj.daysInfo!.isNotEmpty ? true : false;

      _servicesController.EmptyTimeErrorMessage.value = false;
      _servicesController.EmptyDateErrorMessage.value = false;

      _priceController.text = widget.adventureObj.price.toString();

      _servicesController.pickUpLocLatLang.value = LatLng(
          double.parse(widget.adventureObj.coordinates!.latitude ?? ''),
          double.parse(widget.adventureObj.coordinates!.longitude ?? ''));

      locationUrl = getLocationUrl(_servicesController.pickUpLocLatLang.value);

      _servicesController.reviewincludeItenrary.value =
          widget.adventureObj.priceIncludesAr!.toList();
    });
  }

  String getLocationUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
//  late tz.Location location;
  bool? DateErrorMessage;
  bool? TimeErrorMessage;
  bool? DurationErrorMessage;
  bool? GuestErrorMessage;
  int selectedChoice = 3;
  final srvicesController = Get.put(HospitalityController());

  Future<void> _updateAdventure() async {
    try {
      final Adventure? result = await _servicesController.editAdventure(
        daysinfo: daysInfo,
        id: widget.adventureObj.id,
        nameAr: adventureTitleControllerAr.text,
        nameEn: adventureTitleControllerEn.text,
        nameZh: _servicesController.titleZh.value,
        descriptionAr: adventureBioControllerAr.text,
        descriptionEn: adventureBioControllerEn.text,
        descriptionZh: _servicesController.desZh.value,
        priceIncludesAr: _servicesController.reviewincludeItenrary,
        priceIncludesEn: widget.adventureObj.priceIncludesEn,
        priceIncludesZh: widget.adventureObj.priceIncludesZh,
        longitude:
            _servicesController.pickUpLocLatLang.value.longitude.toString(),
        latitude:
            _servicesController.pickUpLocLatLang.value.latitude.toString(),
        price: int.parse(_priceController.text),
        image: imageUrls,
        regionAr: widget.adventureObj.regionAr ?? '',
        locationUrl: locationUrl,
        regionEn: widget.adventureObj.regionEn ?? '',
        Genre: adventureTitleControllerEn.text.split(' ')[0],
        context: context,
      );

      if (result == null) {
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
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/paymentSuccess.gif', width: 38),
                    SizedBox(height: width * 0.04),
                    Text(
                      'saveChange'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
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
          // Get.offAll(() => const AjwadiBottomBar());
          Get.back();
          Get.back();
          final experienceController = Get.put(LocalExploreController());
          experienceController.getAllExperiences(context: context);
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    final TextEditingController textField1Controller =
        _selectedLanguageIndex == 0
            ? adventureTitleControllerAr
            : adventureTitleControllerEn;

    final TextEditingController textField2Controller =
        _selectedLanguageIndex == 0
            ? adventureBioControllerAr
            : adventureBioControllerEn;
    return Obx(
      () => _servicesController.isAdventureByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              body: Center(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            )
          : GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: Colors.white,
                // extendBodyBehindAppBar: true,
                appBar: CustomAppBar(
                  "ExperienceEdit".tr,
                  isAjwadi: true,
                  isDeleteIcon: true,
                  onPressedAction: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          content: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 4,
                                ),
                                CustomText(
                                  textAlign: TextAlign.center,
                                  color: const Color(0xFFDC362E),
                                  fontSize: 15,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                  text: "Alert".tr,
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                CustomText(
                                  textAlign: TextAlign.center,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF41404A),
                                  text: 'DeleteNote'.tr,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Obx(
                                  () => _servicesController
                                          .isAdventureDeleteLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator
                                              .adaptive())
                                      : GestureDetector(
                                          onTap: () async {
                                            log("End Trip Taped ${widget.adventureObj.id}");

                                            bool result =
                                                await _servicesController
                                                        .AdventureDelete(
                                                            context: context,
                                                            adventureId: widget
                                                                .adventureObj
                                                                .id) ??
                                                    false;
                                            if (result) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/paymentSuccess.gif',
                                                              width: 38),
                                                          SizedBox(
                                                              height:
                                                                  width * 0.04),
                                                          Text(
                                                            'DeleteDone'.tr,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: AppUtil
                                                                      .rtlDirection2(
                                                                          context)
                                                                  ? 'SF Arabic'
                                                                  : 'SF Pro',
                                                            ),
                                                            textDirection: AppUtil
                                                                    .rtlDirection2(
                                                                        context)
                                                                ? TextDirection
                                                                    .rtl
                                                                : TextDirection
                                                                    .ltr,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((_) {
                                                Get.back();
                                                Get.back();
                                                Get.back();

                                                final experienceController =
                                                    Get.put(
                                                        LocalExploreController());
                                                experienceController
                                                    .getAllExperiences(
                                                        context: context);
                                              });
                                            } else {
                                              if (context.mounted) {
                                                AppUtil.errorToast(
                                                    context, 'notDelete'.tr);
                                                await Future.delayed(
                                                    const Duration(seconds: 1));
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 34,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDC362E),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: CustomText(
                                              textAlign: TextAlign.center,
                                              text: "Delete".tr,
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async {
                                    Get.back();
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      height: 34,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFDC362E),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: CustomText(
                                          textAlign: TextAlign.center,
                                          fontSize: 15,
                                          fontFamily:
                                              AppUtil.rtlDirection2(context)
                                                  ? 'SF Arabic'
                                                  : 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFDC362E),
                                          text: 'cancel'.tr)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 24.0, top: 16),
                    child: Obx(
                      () => _eventController.isImagesLoading.value ||
                              TranslationApi.isTranslatingLoading.value ||
                              _servicesController.isEditAdveentureLoading.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 160),
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : CustomButton(
                              onPressed: () {
                                validateAndSave();
                              },
                              title: 'SaveChanges'.tr),
                    )),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'PhotoGallery'.tr,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 17,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                            // images widget on top of screen
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ViewImages(
                                          tripImageUrl:
                                              widget.adventureObj.image!,
                                          fromNetwork: true,
                                          Type: 'adventure',
                                        ));
                                  },
                                  child: _servicesController.images.isEmpty
                                      ? Image.asset(
                                          'assets/images/Placeholder.png',
                                          height: height * 0.3,
                                          fit: BoxFit.cover,
                                        )
                                      : CarouselSlider.builder(
                                          carouselController:
                                              _carouselController,
                                          options: CarouselOptions(
                                              viewportFraction: 1,
                                              onPageChanged: (i, reason) {
                                                setState(() {
                                                  _currentIndex = i;
                                                });
                                              }),
                                          itemCount:
                                              _servicesController.images.length,
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            return ImagesSliderWidget(
                                              image: _servicesController
                                                  .images[index],
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: width * 0.055,
                            ),
                            const Divider(
                              color: lightGrey,
                            ),
                            const SizedBox(
                              height: 14,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ToggleSwitch(
                                        minWidth: 55,
                                        cornerRadius: 12,
                                        activeBgColors: const [
                                          [Colors.white],
                                          [Colors.white]
                                        ],
                                        activeBorders: [
                                          Border.all(
                                              color: const Color(0xFFF5F5F5),
                                              width: 2.0),
                                          Border.all(
                                              color: const Color(0xFFF5F5F5),
                                              width: 2.0),
                                        ],
                                        activeFgColor: const Color(0xFF070708),
                                        inactiveBgColor:
                                            const Color(0xFFF5F5F5),
                                        inactiveFgColor:
                                            const Color(0xFF9392A0),
                                        initialLabelIndex:
                                            _selectedLanguageIndex,
                                        totalSwitches: 2,
                                        labels: _selectedLanguageIndex == 0
                                            ? ['عربي', 'إنجليزي']
                                            : ['AR', 'EN'],
                                        radiusStyle: true,
                                        customTextStyles: [
                                          TextStyle(
                                            fontSize:
                                                _selectedLanguageIndex == 0
                                                    ? 11
                                                    : 13,
                                            fontFamily:
                                                _selectedLanguageIndex == 0
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            fontWeight:
                                                _selectedLanguageIndex == 0
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                          ),
                                          TextStyle(
                                            fontSize:
                                                _selectedLanguageIndex == 0
                                                    ? 10
                                                    : 13,
                                            fontFamily:
                                                _selectedLanguageIndex == 0
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            fontWeight:
                                                _selectedLanguageIndex == 0
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                          ),
                                        ],
                                        customHeights: const [90, 90],
                                        onToggle: (index) {
                                          setState(() {
                                            _selectedLanguageIndex = index!;
                                          });
                                        },
                                      ),
                                    ]),
                                Directionality(
                                  textDirection: _selectedLanguageIndex == 0
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedLanguageIndex == 0
                                                  ? 'عنوان التجربة'
                                                  : 'Experience title',
                                              style: TextStyle(
                                                color: const Color(0xFF070708),
                                                fontSize: 17,
                                                fontFamily:
                                                    _selectedLanguageIndex == 0
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight:
                                                    _selectedLanguageIndex == 0
                                                        ? FontWeight.w500
                                                        : FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    _selectedLanguageIndex == 0
                                                        ? 8
                                                        : 8),
                                            Container(
                                              width: double.infinity,
                                              height: 54,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 1,
                                                    color:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? titleArEmpty
                                                                ? colorRed
                                                                : const Color(
                                                                    0xFFB9B8C1)
                                                            : titleENEmpty
                                                                ? colorRed
                                                                : const Color(
                                                                    0xFFB9B8C1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 0),
                                                child: TextField(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  inputFormatters: [
                                                    _selectedLanguageIndex == 0
                                                        ? FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[\u0600-\u06FF\s]'))
                                                        : FilteringTextInputFormatter
                                                            .allow(
                                                            RegExp(
                                                                r'[a-zA-Z0-9\s]'),
                                                          ), // Allow only English letters and spaces, // Allow only Arabic characters and spaces
                                                  ],
                                                  controller:
                                                      textField1Controller,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? 'مثال: منزل دانا'
                                                            : 'example: Dana’s house',
                                                    hintStyle: TextStyle(
                                                      color: const Color(
                                                          0xFFB9B8C1),
                                                      fontSize: 15,
                                                      fontFamily:
                                                          _selectedLanguageIndex ==
                                                                  0
                                                              ? 'SF Arabic'
                                                              : 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (titleArEmpty &&
                                                _selectedLanguageIndex == 0)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'يجب إضافة عنوان للتجربة ',
                                                  style: TextStyle(
                                                    color: Color(0xFFDC362E),
                                                    fontSize: 11,
                                                    fontFamily: 'SF Arabic',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            if (_selectedLanguageIndex == 1 &&
                                                titleENEmpty)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'You need to add a title ',
                                                  style: TextStyle(
                                                    color: Color(0xFFDC362E),
                                                    fontSize: 11,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedLanguageIndex == 0
                                                  ? 'الوصف'
                                                  : 'Description',
                                              style: TextStyle(
                                                color: const Color(0xFF070708),
                                                fontSize: 17,
                                                fontFamily:
                                                    _selectedLanguageIndex == 0
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight:
                                                    _selectedLanguageIndex == 0
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    _selectedLanguageIndex == 0
                                                        ? 9
                                                        : 9),
                                            Container(
                                              width: double.infinity,
                                              height: 133,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: _selectedLanguageIndex ==
                                                              0
                                                          ? bioArEmpty
                                                              ? colorRed
                                                              : const Color(
                                                                  0xFFB9B8C1)
                                                          : bioEnEmpty
                                                              ? colorRed
                                                              : const Color(
                                                                  0xFFB9B8C1)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 0),
                                                child: TextField(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 8,
                                                  minLines: 1,
                                                  controller:
                                                      textField2Controller,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      _selectedLanguageIndex ==
                                                              0
                                                          ? RegExp(
                                                              r'[\u0600-\u06FF\s]') // Allow only Arabic characters and spaces
                                                          : RegExp(
                                                              r'[a-zA-Z0-9\s]'),
                                                    ),
                                                    TextInputFormatter
                                                        .withFunction(
                                                      (oldValue, newValue) {
                                                        if (newValue.text
                                                                .split(RegExp(
                                                                    r'\s+'))
                                                                .where((word) =>
                                                                    word.isNotEmpty)
                                                                .length >
                                                            150) {
                                                          return oldValue;
                                                        }
                                                        return newValue;
                                                      },
                                                    ),
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText: _selectedLanguageIndex ==
                                                            0
                                                        ? 'أذكر أبرز ما يميزها ولماذا يجب على السياح زيارتها'
                                                        : 'highlight what makes it unique and why tourists should visit',
                                                    hintStyle: TextStyle(
                                                      color: const Color(
                                                          0xFFB9B8C1),
                                                      fontSize: 15,
                                                      fontFamily:
                                                          _selectedLanguageIndex ==
                                                                  0
                                                              ? 'SF Arabic'
                                                              : 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (bioEnEmpty &&
                                                _selectedLanguageIndex == 1)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'You need to add a discription for the experience',
                                                  style: TextStyle(
                                                    color: Color(0xFFDC362E),
                                                    fontSize: 11,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            if (bioArEmpty &&
                                                _selectedLanguageIndex == 0)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  "يجب إضافة وصف للتجربة ",
                                                  style: TextStyle(
                                                    color: Color(0xFFDC362E),
                                                    fontSize: 11,
                                                    fontFamily: 'SF Arabic',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 1.0, left: 8.0),
                                              child: Text(
                                                _selectedLanguageIndex == 0
                                                    ? '*يجب ألا يتجاوز الوصف 150 كلمة'
                                                    : '*the description must not exceed 150 words',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFFB9B8C1),
                                                  fontSize: 11,
                                                  fontFamily:
                                                      _selectedLanguageIndex ==
                                                              0
                                                          ? 'SF Arabic'
                                                          : 'SF Pro',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: width * 0.055,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.077,
                                ),
                                if ((widget.adventureObj.priceIncludesAr
                                        ?.isNotEmpty ??
                                    false)) ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'priceInclude'.tr,
                                        color: black,
                                        fontSize: 17,
                                        fontFamily: AppUtil.SfFontType(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(
                                        height: width * 0.02,
                                      ),
                                      // SizedBox(
                                      //   height: width * 0.012,
                                      // ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(
                                          //   height: width * 0.050,
                                          // ),
                                          SizedBox(
                                            height: width * 0.012,
                                          ),
                                          Obx(
                                            () => ListView.separated(
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: width * 0.02,
                                              ),
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: _servicesController
                                                  .reviewincludeItenrary.length,
                                              itemBuilder: (context, index) =>
                                                  ReivewIncludeCard(
                                                indx: index,
                                                include: _servicesController
                                                        .reviewincludeItenrary[
                                                    index],
                                                experienceController:
                                                    _servicesController,
                                              ),
                                            ),
                                          ),
                                          Obx(() => _servicesController
                                                  .reviewincludeItenrary
                                                  .isNotEmpty
                                              ? SizedBox(
                                                  height: width * 0.04,
                                                )
                                              : const SizedBox.shrink()),

                                          Obx(() => ListView.separated(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                separatorBuilder: (context,
                                                        index) =>
                                                    SizedBox(
                                                        height: width * 0.06),
                                                itemCount: _servicesController
                                                    .includeList.length,
                                                itemBuilder: (context, index) {
                                                  return _servicesController
                                                      .includeList[index];
                                                },
                                              )),
                                          // SizedBox(height: width * 0.06),

                                          // Add Button
                                          GestureDetector(
                                            onTap: () {
                                              if (_servicesController
                                                      .includeCount >=
                                                  1) {
                                                return;
                                              }
                                              _servicesController.includeList
                                                  .add(
                                                IncludeCard(
                                                  indx: _servicesController
                                                      .includeCount.value,
                                                  experienceController:
                                                      _servicesController,
                                                ),
                                              );
                                              _servicesController
                                                  .includeCount++;
                                            },
                                            child: Obx(
                                              () => Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 0.01,
                                                    top: _servicesController
                                                            .includeList.isEmpty
                                                        ? 0
                                                        : width * 0.050,
                                                    // bottom: width * 0.06,
                                                    right: width * 0.01),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      // height: width * 0.06,
                                                      // width: width * 0.06,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: colorGreen,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      9999),
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: width * 0.06,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * 0.02),
                                                    CustomText(
                                                      text: "addNewPoint".tr,
                                                      fontSize: width * 0.038,
                                                      fontFamily:
                                                          AppUtil.rtlDirection2(
                                                                  context)
                                                              ? 'SF Arabic'
                                                              : 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: width * 0.055,
                                  ),
                                  const Divider(
                                    color: lightGrey,
                                  ),
                                  SizedBox(
                                    height: width * 0.077,
                                  ),
                                ],
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "guests2".tr,
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                    SizedBox(
                                      height: width * 0.02,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: width * 0.012,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.063,
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                          ),
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 1,
                                                  color: guestEmpty
                                                      ? colorRed
                                                      : const Color(
                                                          0xFFB9B8C1)),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              CustomText(
                                                text: "guests".tr,
                                                fontWeight: FontWeight.w400,
                                                color: Graytext,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontSize: 15,
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                  onTap: () {
                                                    if (guestNum > 0) {
                                                      setState(() {
                                                        guestNum = guestNum - 1;
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(
                                                      Icons
                                                          .horizontal_rule_outlined,
                                                      color: Graytext,
                                                      size: 24)),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              CustomText(
                                                text: guestNum.toString(),
                                                color: Graytext,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      guestNum = guestNum + 1;
                                                    });
                                                  },
                                                  child: const Icon(Icons.add,
                                                      color: Graytext,
                                                      size: 24)),
                                            ],
                                          ),
                                        ),
                                        if (guestEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              AppUtil.rtlDirection2(context)
                                                  ? 'يجب ان تستقبل على الاقل 5 اشخاص'
                                                  : 'You need to add at least one Person',
                                              style: TextStyle(
                                                color: const Color(0xFFDC362E),
                                                fontSize: 11,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: width * 0.047,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: width * 0.055,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.077,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: width * 0.012,
                                    ),
                                    CustomText(
                                      text: AppUtil.rtlDirection2(context)
                                          ? "أيام النشاط"
                                          : "Available Dates",
                                      color: black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                    SizedBox(
                                      height: width * 0.02,
                                    ),
                                    Obx(
                                      () => Container(
                                        width: double.infinity,
                                        height: height * 0.063,
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1,
                                                color: _servicesController
                                                            .EmptyDateErrorMessage
                                                            .value ||
                                                        _servicesController
                                                            .DateErrorMessage
                                                            .value
                                                    ? colorRed
                                                    : const Color(0xFFB9B8C1)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedChoice = 3;
                                                });

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return EventCalenderDialog(
                                                        type: 'adv',
                                                        advController:
                                                            _servicesController,
                                                      );
                                                    });
                                              },
                                              child: CustomText(
                                                text: _servicesController
                                                        .isAdventureDateSelcted
                                                        .value
                                                    ? AppUtil
                                                        .formatSelectedDates(
                                                            _servicesController
                                                                .selectedDates,
                                                            context)
                                                    : 'DD/MM/YYYY'.tr,
                                                fontWeight: FontWeight.w400,
                                                color: Graytext,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_servicesController
                                            .EmptyDateErrorMessage.value ||
                                        _servicesController
                                            .DateErrorMessage.value)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          _servicesController
                                                  .EmptyDateErrorMessage.value
                                              ? AppUtil.rtlDirection2(context)
                                                  ? "اختر التاريخ"
                                                  : "You need to choose a valid date"
                                              : AppUtil.rtlDirection2(context)
                                                  ? "يجب اختيار تاريخ بعد اليوم الحالي"
                                                  : "Please choose a date after today",
                                          style: TextStyle(
                                            color: const Color(0xFFDC362E),
                                            fontSize: width * 0.028,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text:
                                                  AppUtil.rtlDirection2(context)
                                                      ? "وقت البداية"
                                                      : "Start Time",
                                              color: black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Align(
                                              alignment:
                                                  AppUtil.rtlDirection(context)
                                                      ? Alignment.centerLeft
                                                      : Alignment.centerRight,
                                              child: Container(
                                                height: height * 0.06,
                                                width: width * 0.41,
                                                padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: _servicesController
                                                                    .EmptyTimeErrorMessage
                                                                    .value ||
                                                                _servicesController
                                                                    .newRangeTimeErrorMessage
                                                                    .value
                                                            ? colorRed
                                                            : DurationErrorMessage ??
                                                                    false
                                                                ? colorRed
                                                                : const Color(
                                                                    0xFFB9B8C1)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await DatePickerBdaya
                                                            .showTime12hPicker(
                                                                context,
                                                                locale: AppUtil
                                                                        .rtlDirection2(
                                                                            context)
                                                                    ? LocaleType
                                                                        .ar
                                                                    : LocaleType
                                                                        .en,
                                                                showTitleActions:
                                                                    true,
                                                                currentTime:
                                                                    newTimeToGo,
                                                                onConfirm:
                                                                    (newT) {
                                                          _servicesController
                                                              .isAdventureTimeSelcted(
                                                                  true);
                                                          _servicesController
                                                                  .EmptyTimeErrorMessage
                                                                  .value =
                                                              !_servicesController
                                                                  .isAdventureTimeSelcted
                                                                  .value;
                                                          setState(() {
                                                            newTimeToGo = newT;
                                                            _servicesController
                                                                    .selectedStartTime
                                                                    .value =
                                                                newTimeToGo;
                                                            time = newTimeToGo;

                                                            _servicesController
                                                                    .TimeErrorMessage
                                                                    .value =
                                                                AppUtil.isEndTimeLessThanStartTime(
                                                                    _servicesController
                                                                        .selectedStartTime
                                                                        .value,
                                                                    _servicesController
                                                                        .selectedEndTime
                                                                        .value);

                                                            //newww  SRS
                                                            if (_servicesController
                                                                .isAdventureDateSelcted
                                                                .value) {
                                                              _servicesController
                                                                      .newRangeTimeErrorMessage
                                                                      .value =
                                                                  AppUtil.areAllDatesTimeBefore(
                                                                      _servicesController
                                                                          .selectedDates,
                                                                      _servicesController
                                                                          .selectedStartTime
                                                                          .value);
                                                            }
                                                          });
                                                        }, onChanged: (newT) {
                                                          _servicesController
                                                              .isAdventureTimeSelcted(
                                                                  true);
                                                          _servicesController
                                                                  .EmptyTimeErrorMessage
                                                                  .value =
                                                              !_servicesController
                                                                  .isAdventureTimeSelcted
                                                                  .value;
                                                          setState(() {
                                                            newTimeToGo = newT;
                                                            _servicesController
                                                                    .selectedStartTime
                                                                    .value =
                                                                newTimeToGo;
                                                            time = newTimeToGo;

                                                            _servicesController
                                                                    .TimeErrorMessage
                                                                    .value =
                                                                AppUtil.isEndTimeLessThanStartTime(
                                                                    _servicesController
                                                                        .selectedStartTime
                                                                        .value,
                                                                    _servicesController
                                                                        .selectedEndTime
                                                                        .value);

                                                            //newww  SRS
                                                            if (_servicesController
                                                                .isAdventureDateSelcted
                                                                .value) {
                                                              _servicesController
                                                                      .newRangeTimeErrorMessage
                                                                      .value =
                                                                  AppUtil.areAllDatesTimeBefore(
                                                                      _servicesController
                                                                          .selectedDates,
                                                                      _servicesController
                                                                          .selectedStartTime
                                                                          .value);
                                                            }
                                                          });
                                                        });
                                                      },
                                                      child: CustomText(
                                                        text: _servicesController
                                                                .isAdventureTimeSelcted
                                                                .value
                                                            ? AppUtil.formatStringTimeWithLocale(
                                                                context,
                                                                DateFormat(
                                                                        'HH:mm:ss')
                                                                    .format(
                                                                        newTimeToGo))
                                                            : "00:00",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Graytext,
                                                        fontFamily: AppUtil
                                                                .rtlDirection2(
                                                                    context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (_servicesController
                                                    .EmptyTimeErrorMessage
                                                    .value ||
                                                _servicesController
                                                    .TimeErrorMessage.value ||
                                                _servicesController
                                                    .newRangeTimeErrorMessage
                                                    .value)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                  _servicesController
                                                          .EmptyTimeErrorMessage
                                                          .value
                                                      ? AppUtil.rtlDirection2(
                                                              context)
                                                          ? "يجب اختيار الوقت"
                                                          : "Select The Time"
                                                      : _servicesController
                                                              .newRangeTimeErrorMessage
                                                              .value
                                                          ? 'StartTimeDurationError'
                                                              .tr
                                                          : '',
                                                  style: TextStyle(
                                                    color: colorRed,
                                                    fontSize: width * 0.026,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text:
                                                  AppUtil.rtlDirection2(context)
                                                      ? "وقت النهاية"
                                                      : "End Time",
                                              color: black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Align(
                                              alignment:
                                                  AppUtil.rtlDirection(context)
                                                      ? Alignment.centerLeft
                                                      : Alignment.centerRight,
                                              child: Container(
                                                height: height * 0.06,
                                                width: width * 0.41,
                                                padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: _servicesController
                                                                    .EmptyTimeErrorMessage
                                                                    .value ||
                                                                _servicesController
                                                                    .TimeErrorMessage
                                                                    .value
                                                            ? colorRed
                                                            : DurationErrorMessage ??
                                                                    false
                                                                ? colorRed
                                                                : const Color(
                                                                    0xFFB9B8C1)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await DatePickerBdaya
                                                            .showTime12hPicker(
                                                          context,
                                                          locale: AppUtil
                                                                  .rtlDirection2(
                                                                      context)
                                                              ? LocaleType.ar
                                                              : LocaleType.en,
                                                          showTitleActions:
                                                              true,
                                                          currentTime:
                                                              newTimeToReturn,
                                                          onConfirm: (newT) {
                                                            _servicesController
                                                                .isAdventureTimeSelcted(
                                                                    true);
                                                            _servicesController
                                                                    .EmptyTimeErrorMessage
                                                                    .value =
                                                                !_servicesController
                                                                    .isAdventureTimeSelcted
                                                                    .value;
                                                            // print(DateFormat(
                                                            //         'HH:mm:ss')
                                                            //     .format(
                                                            //         newTimeToReturn));
                                                            setState(() {
                                                              newTimeToReturn =
                                                                  newT;
                                                              returnTime =
                                                                  newTimeToReturn;
                                                              _servicesController
                                                                      .selectedEndTime
                                                                      .value =
                                                                  newTimeToReturn;

                                                              _servicesController
                                                                      .TimeErrorMessage
                                                                      .value =
                                                                  AppUtil.isEndTimeLessThanStartTime(
                                                                      _servicesController
                                                                          .selectedStartTime
                                                                          .value,
                                                                      _servicesController
                                                                          .selectedEndTime
                                                                          .value);
                                                            });
                                                          },
                                                          onChanged: (newT) {
                                                            _servicesController
                                                                .isAdventureTimeSelcted(
                                                                    true);
                                                            _servicesController
                                                                    .EmptyTimeErrorMessage
                                                                    .value =
                                                                !_servicesController
                                                                    .isAdventureTimeSelcted
                                                                    .value;
                                                            // print(DateFormat(
                                                            //         'HH:mm:ss')
                                                            //     .format(
                                                            //         newTimeToReturn));
                                                            setState(() {
                                                              newTimeToReturn =
                                                                  newT;
                                                              returnTime =
                                                                  newTimeToReturn;
                                                              _servicesController
                                                                      .selectedEndTime
                                                                      .value =
                                                                  newTimeToReturn;

                                                              _servicesController
                                                                      .TimeErrorMessage
                                                                      .value =
                                                                  AppUtil.isEndTimeLessThanStartTime(
                                                                      _servicesController
                                                                          .selectedStartTime
                                                                          .value,
                                                                      _servicesController
                                                                          .selectedEndTime
                                                                          .value);
                                                            });
                                                          },
                                                        );
                                                      },
                                                      child: CustomText(
                                                        text: _servicesController
                                                                .isAdventureTimeSelcted
                                                                .value
                                                            ? AppUtil.formatStringTimeWithLocale(
                                                                context,
                                                                DateFormat(
                                                                        'HH:mm:ss')
                                                                    .format(
                                                                        newTimeToReturn))
                                                            : "00:00",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Graytext,
                                                        fontFamily: AppUtil
                                                                .rtlDirection2(
                                                                    context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Obx(
                                              () => _servicesController
                                                          .EmptyTimeErrorMessage
                                                          .value ||
                                                      // TimeErrorMessage ??
                                                      //         false ||
                                                      _servicesController
                                                          .TimeErrorMessage
                                                          .value ||
                                                      _servicesController
                                                          .newRangeTimeErrorMessage
                                                          .value
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      child: Text(
                                                        _servicesController
                                                                .EmptyTimeErrorMessage
                                                                .value
                                                            ? AppUtil
                                                                    .rtlDirection2(
                                                                        context)
                                                                ? "يجب اختيار الوقت"
                                                                : "Select The Time"
                                                            : _servicesController
                                                                    .TimeErrorMessage
                                                                    .value
                                                                ? AppUtil.rtlDirection2(
                                                                        context)
                                                                    ? "يجب أن لايسبق وقت بدء التجربة"
                                                                    : "Can’t be before start time"
                                                                : '',
                                                        style: TextStyle(
                                                          color: colorRed,
                                                          fontSize:
                                                              width * 0.027,
                                                          fontFamily: AppUtil
                                                                  .rtlDirection2(
                                                                      context)
                                                              ? 'SF Arabic'
                                                              : 'SF Pro',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: width * 0.055,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.077,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Location".tr,
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                    SizedBox(
                                      height: width * 0.05,
                                    ),
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  almostGrey.withOpacity(0.2),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                            ),
                                            height: 246,
                                            width: double.infinity,
                                            child: GoogleMap(
                                              scrollGesturesEnabled: true,
                                              zoomControlsEnabled: false,
                                              padding: EdgeInsets.only(
                                                  bottom: width * 0.102),
                                              gestureRecognizers: {
                                                Factory<OneSequenceGestureRecognizer>(
                                                    () =>
                                                        EagerGestureRecognizer())
                                              },
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: _currentPosition,
                                                zoom: 15,
                                              ),
                                              markers: {
                                                Marker(
                                                  markerId:
                                                      const MarkerId("marker1"),
                                                  position: _currentPosition,
                                                  draggable: true,
                                                  onDragEnd:
                                                      (LatLng newPosition) {
                                                    setState(() {
                                                      _servicesController
                                                          .pickUpLocLatLang
                                                          .value = newPosition;
                                                      _currentPosition =
                                                          newPosition;

                                                      _isLoading = true;
                                                    });
                                                    _fetchAddress();
                                                  },
                                                  icon: markerIcon,
                                                ),
                                              },
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            width: 358,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12),
                                                      bottomRight:
                                                          Radius.circular(12)),
                                              border: Border.all(
                                                color: const Color(0xFFE2E2E2),
                                                width: 2,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: _isLoading
                                                        ? const CircularProgressIndicator
                                                            .adaptive()
                                                        : Text(
                                                            address,
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF9392A0),
                                                              fontSize: 13,
                                                              fontFamily: AppUtil
                                                                      .rtlDirection2(
                                                                          context)
                                                                  ? 'SF Arabic'
                                                                  : 'SF Pro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 0,
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: width * 0.055,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.077,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Price".tr,
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                    SizedBox(
                                      height: width * 0.02,
                                    ),
                                    TextField(
                                      controller: _priceController,
                                      decoration: InputDecoration(
                                        hintText: AppUtil.rtlDirection2(context)
                                            ? '00.00 ر.س / للفرد'
                                            : '00.00 SAR /per person',
                                        hintStyle: TextStyle(
                                          color: const Color(0xFFB9B8C1),
                                          fontSize: 15,
                                          fontFamily:
                                              AppUtil.rtlDirection2(context)
                                                  ? 'SF Arabic'
                                                  : 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: PriceEmpty ||
                                                    PriceLarger ||
                                                    PriceDouble
                                                ? const Color(0xFFDC362E)
                                                : const Color(0xFFB9B8C1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Graytext,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    if (PriceEmpty ||
                                        PriceLarger ||
                                        PriceDouble)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          AppUtil.rtlDirection2(context)
                                              ? PriceEmpty
                                                  ? 'يجب عليك ان تضع السعر المقدر'
                                                  : PriceDouble
                                                      ? '*السعر يجب أن يكون عدد صحيح فقط'
                                                      : 'السعر يجب أن يكون اكبر من أو يساوي 150'
                                              : PriceEmpty
                                                  ? 'You need to add a valid price'
                                                  : PriceDouble
                                                      ? '*The price must be an integer value only'
                                                      : 'You need to add a valid price, >= 150',
                                          style: TextStyle(
                                            color: const Color(0xFFDC362E),
                                            fontSize: width * 0.028,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: height * 0.26,
                              ), // Set the top padding to control vertical position
                              child: AnimatedSmoothIndicator(
                                  effect: WormEffect(
                                    // dotColor: starGreyColor,
                                    dotWidth: width * 0.030,
                                    dotHeight: width * 0.030,
                                    activeDotColor: Colors.white,
                                  ),
                                  activeIndex: _currentIndex,
                                  count: _servicesController.images.length >= 6
                                      ? 6
                                      : _servicesController.images.length),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
