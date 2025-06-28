import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/api/translation_api.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_event_calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/image_slider.dart';
import 'package:ajwad_v4/request/ajwadi/view/view_experience_images.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/include_card.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/review_include_card.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';

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
import 'package:intl/intl.dart' as intl;
import 'package:image/image.dart' as img; // Import the image package

class EditEvent extends StatefulWidget {
  const EditEvent({
    Key? key,
    required this.eventObj,
    // this.experienceType,
  }) : super(key: key);

  final Event eventObj;
  // final String? experienceType;

  @override
  State<EditEvent> createState() => _EditEventState();
}

late double width, height;

class _EditEventState extends State<EditEvent> {
  final _servicesController = Get.put(EventController());
  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN
  bool _isLoading = true;

  List<DateTime> avilableDate = [];
  var locLatLang = const LatLng(24.691846000000012, 46.68552199999999);
  final TextEditingController eventTitleControllerEn = TextEditingController();
  final TextEditingController eventBioControllerEn = TextEditingController();

  final TextEditingController eventTitleControllerAr = TextEditingController();
  final TextEditingController eventBioControllerAr = TextEditingController();
  final TextEditingController _textField1Controller = TextEditingController();

  String address = '';

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

    _servicesController.isEventDateSelcted(false);
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
  List<String> imageUrls = [];

  final int? _selectedRadio1 = 1;
  int guestNum = 0;
  String startTime = '';
  String endTime = '';
  List<Map<String, dynamic>> DaysInfo = [];

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
  String gender = '';

  void daysInfo() {
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
        "seats": _servicesController.seletedSeat.value
      };

      DaysInfo.add(newEntry);
    }

    // Print the new dates list
  }

  Future<bool> uploadImages() async {
    List<dynamic> imagesToUpload = [];
    bool allExtensionsValid = true;

    // Allowed formats
    final allowedFormats = ['jpg', 'jpeg', 'png'];

    for (int i = 0; i < _servicesController.images.length; i++) {
      var image = _servicesController.images[i];

      // Check if the path is a URL
      if (image is String && Uri.parse(image).isAbsolute) {
        imageUrls.add(image);
      } else {
        String fileExtension = image.path.split('.').last.toLowerCase();

        if (!allowedFormats.contains(fileExtension)) {
          allExtensionsValid = false;
          print(
              'File ${image.path} is not in an allowed format (${allowedFormats.join(', ')}).');
        } else {
          imagesToUpload.add(image);
        }
      }
    }

    if (!allExtensionsValid) {
      // if (context.mounted) {
      //   AppUtil.errorToast(context,
      //     'uploadError'.tr);
      //   await Future.delayed(const Duration(seconds: 3));
      // }
      return false;
    }

    // Upload images that are not URLs

    for (var imageFile in imagesToUpload) {
      //  File file = await convertImageToJpg(File(imageFile.path));

      try {
        final uploadedImage = await _servicesController.uploadProfileImages(
          file: File(imageFile.path),
          //file:file,
          fileType: "event",
          context: context,
        );

        if (uploadedImage != null) {
          log('valid');
          imageUrls.add(uploadedImage.filePath);
          log(uploadedImage.filePath);
        } else {
          log('not valid');
          // return false;
        }
      } catch (e) {
        log('Error uploading file ${imageFile.path}: $e');
        return false;
      }
    }

    return true;
  }

  Future<void> translateIncludesList() async {
    final current = _servicesController.reviewincludeItenrary;

    if (current.isNotEmpty) {
      for (int i = 0; i < current.length; i++) {
        final isNew = i >= widget.eventObj.priceIncludesAr!.length;
        final isChanged = !isNew &&
            current[i].trim() != widget.eventObj.priceIncludesAr![i].trim();

        if ((isNew || isChanged) && current[i].trim().isNotEmpty) {
          final translatedEn = await TranslationApi.translate(current[i], 'en');
          final translatedZh = await TranslationApi.translate(current[i], 'zh');
          if (translatedEn.trim().isNotEmpty) {
            if (isNew) {
              widget.eventObj.priceIncludesEn!.add(translatedEn.trim());
            } else {
              widget.eventObj.priceIncludesEn![i] = translatedEn.trim();
            }
          }
          if (translatedZh.trim().isNotEmpty) {
            if (isNew) {
              widget.eventObj.priceIncludesZh!.add(translatedZh.trim());
            } else {
              widget.eventObj.priceIncludesZh![i] = translatedZh.trim();
            }
          }
        }
      }
    } else {
      widget.eventObj.priceIncludesEn!.clear();
      widget.eventObj.priceIncludesZh!.clear();
    }
  }

  Future<void> translateDescriptionFields() async {
    try {
      final currentTitleArValue = eventTitleControllerAr.text;
      final currentBioeArValue = eventBioControllerAr.text;

      final currentTitleEnValue = eventTitleControllerEn.text;
      final currentBioEnValue = eventBioControllerEn.text;

      if ((currentTitleArValue != widget.eventObj.nameAr &&
          currentTitleArValue.isNotEmpty)) {
        final translatedTitleZh =
            await TranslationApi.translate(currentTitleArValue, 'zh');

        if (translatedTitleZh.isNotEmpty) {
          _servicesController.titleZh.value = translatedTitleZh;
        }
      } else if ((currentTitleEnValue != widget.eventObj.nameEn &&
          currentTitleEnValue.isNotEmpty)) {
        final translatedTitleZh =
            await TranslationApi.translate(currentTitleEnValue, 'zh');

        if (translatedTitleZh.isNotEmpty) {
          _servicesController.titleZh.value = translatedTitleZh;
        }
      }
      if ((currentBioeArValue != widget.eventObj.descriptionAr &&
          currentBioeArValue.isNotEmpty)) {
        final translatedBioZh =
            await TranslationApi.translate(currentBioeArValue, 'zh');
        if (translatedBioZh.isNotEmpty) {
          _servicesController.bioZh.value = translatedBioZh;
        }
      } else if ((currentBioEnValue != widget.eventObj.descriptionEn &&
          currentBioEnValue.isNotEmpty)) {
        final translatedBioZh =
            await TranslationApi.translate(currentBioEnValue, 'zh');
        if (translatedBioZh.isNotEmpty) {
          _servicesController.bioZh.value = translatedBioZh;
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
      titleArEmpty = eventTitleControllerAr.text.isEmpty;
      bioArEmpty = eventBioControllerAr.text.isEmpty;

      titleENEmpty = eventTitleControllerEn.text.isEmpty;
      bioEnEmpty = eventBioControllerEn.text.isEmpty;

      _selectedLanguageIndex =
          (titleArEmpty || bioArEmpty) && !(titleENEmpty && bioEnEmpty) ? 0 : 1;

      guestEmpty = _textField1Controller.text.isEmpty ||
          _servicesController.seletedSeat.value.toString() == '0';

      // DateErrorMessage = !_servicesController.isEventDateSelcted.value;
      // TimeErrorMessage = !_servicesController.isEventTimeSelcted.value;
      _servicesController.EmptyDateErrorMessage.value =
          !_servicesController.isEventDateSelcted.value ||
              _servicesController.selectedDates.isEmpty;
      _servicesController.EmptyTimeErrorMessage.value =
          !_servicesController.isEventTimeSelcted.value;
      _servicesController.DateErrorMessage.value =
          !AppUtil.areAllDatesAfter24Hours(_servicesController.selectedDates);
      _servicesController.newRangeTimeErrorMessage.value =
          AppUtil.areAllDatesTimeBefore(_servicesController.selectedDates,
              _servicesController.selectedStartTime.value);
      // DateDurationError =
      //     !AppUtil.areAllDatesAfter24Hours(_servicesController.selectedDates);
      PriceEmpty = _priceController.text.isEmpty;

      if (_priceController.text.isNotEmpty) {
        int? price = int.tryParse(_priceController.text);
        PriceLarger = price == null;

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
        !_servicesController.TimeErrorMessage.value &&
        !_servicesController.newRangeTimeErrorMessage.value && //new srs
        _servicesController.images.length >= 3 &&
        !_servicesController.DateErrorMessage.value) {
      imageUrls = await AppUtil.uploadImagesHelper(
          PickedImages: _servicesController.images,
          imageUrl: imageUrls,
          controller: _servicesController,
          fileType: "event",
          context: context);

      daysInfo();
      await translateDescriptionFields();
      await translateIncludesList();
      await _updateEvent();
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

  Future<void> _loadImages() async {
    List<dynamic> images = [];
    _servicesController.images.clear();
    for (var path in widget.eventObj.image!) {
      images.add(path);
    }

    setState(() {
      _servicesController.images.addAll(images);
    });
  }

  void updateData() {
    setState(() {
      eventTitleControllerAr.text = widget.eventObj.nameAr!;
      eventBioControllerAr.text = widget.eventObj.descriptionAr!;

      eventTitleControllerEn.text = widget.eventObj.nameEn!;
      eventBioControllerEn.text = widget.eventObj.descriptionEn!;

      _servicesController.titleZh.value = widget.eventObj.nameZh!;
      _servicesController.bioZh.value = widget.eventObj.descriptionZh!;

      _textField1Controller.text = widget.eventObj.daysInfo!.isNotEmpty
          ? widget.eventObj.daysInfo!.first.seats.toString()
          : '0';
      _servicesController.seletedSeat.value =
          widget.eventObj.daysInfo!.isNotEmpty
              ? widget.eventObj.daysInfo!.first.seats
              : 0;

      newTimeToGo = widget.eventObj.daysInfo!.isNotEmpty
          ? DateTime.parse(widget.eventObj.daysInfo!.first.startTime)
          : DateTime.now();

      newTimeToReturn = widget.eventObj.daysInfo!.isNotEmpty
          ? DateTime.parse(widget.eventObj.daysInfo!.first.endTime)
          : DateTime.now();

      _servicesController.selectedStartTime.value = newTimeToGo; //new
      _servicesController.selectedEndTime.value = newTimeToReturn; //new

      // _servicesController.selectedDates.value =
      //     widget.eventObj.daysInfo!;
      if (widget.eventObj.daysInfo!.isNotEmpty) {
        bool allDatesInPast = true;
        for (var info in widget.eventObj.daysInfo!) {
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
      _priceController.text = widget.eventObj.price.toString();

      _servicesController.isEventDateSelcted.value =
          widget.eventObj.daysInfo!.isNotEmpty ? true : false;
      _servicesController.isEventTimeSelcted.value =
          widget.eventObj.daysInfo!.isNotEmpty ? true : false;

      // _servicesController.DateErrorMessage.value = false;
      _servicesController.EmptyTimeErrorMessage.value = false;
      _servicesController.EmptyDateErrorMessage.value = false;

      _servicesController.pickUpLocLatLang.value = LatLng(
          double.parse(widget.eventObj.coordinates!.latitude ?? ''),
          double.parse(widget.eventObj.coordinates!.longitude ?? ''));

      locationUrl = getLocationUrl(_servicesController.pickUpLocLatLang.value);
      _servicesController.reviewincludeItenrary.value =
          widget.eventObj.priceIncludesAr!.toList();
    });
    // log('go $newTimeToGo');
    // log('go $newTimeToReturn');
  }

  String getLocationUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
//  late tz.Location location;
  // bool? DateErrorMessage;
  // bool? TimeErrorMessage;
  bool? DurationErrorMessage;
  bool? DateDurationError;

  bool? GuestErrorMessage;
  int selectedChoice = 3;
  final srvicesController = Get.put(HospitalityController());

  Future<void> _updateEvent() async {
    try {
      final Event? result = await _servicesController.editEvent(
        id: widget.eventObj.id,
        nameAr: eventTitleControllerAr.text,
        nameEn: eventTitleControllerEn.text,
        nameZh: _servicesController.titleZh.value,
        descriptionAr: eventBioControllerAr.text,
        descriptionEn: eventBioControllerEn.text,
        descriptionZh: _servicesController.bioZh.value,
        priceIncludesAr: _servicesController.reviewincludeItenrary,
        priceIncludesEn: widget.eventObj.priceIncludesEn,
        priceIncludesZh: widget.eventObj.priceIncludesZh,
        longitude:
            _servicesController.pickUpLocLatLang.value.longitude.toString(),
        latitude:
            _servicesController.pickUpLocLatLang.value.latitude.toString(),
        price: double.parse(_priceController.text),
        image: imageUrls,
        regionAr: widget.eventObj.regionAr ?? '',
        locationUrl: locationUrl,
        regionEn: widget.eventObj.regionEn ?? '',
        daysInfo: DaysInfo,
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
          final experienceController = Get.put(AjwadiExploreController());
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
            ? eventTitleControllerAr
            : eventTitleControllerEn;

    final TextEditingController textField2Controller =
        _selectedLanguageIndex == 0
            ? eventBioControllerAr
            : eventBioControllerEn;
    return Obx(
      () => _servicesController.isEventByIdLoading.value
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
                                  fontSize: width * 0.038,
                                  fontFamily: AppUtil.SfFontType(context),
                                  fontWeight: FontWeight.w500,
                                  text: "Alert".tr,
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                CustomText(
                                  textAlign: TextAlign.center,
                                  fontSize: width * 0.038,
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
                                          .isEventDeleteLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator
                                              .adaptive())
                                      : GestureDetector(
                                          onTap: () async {
                                            log("End Trip Taped ${widget.eventObj.id}");

                                            bool result =
                                                await _servicesController
                                                        .EventDelete(
                                                            context: context,
                                                            eventId: widget
                                                                .eventObj.id) ??
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
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
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
                                                        AjwadiExploreController());
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
                      () => _servicesController.isImagesLoading.value ||
                              TranslationApi.isTranslatingLoading.value ||
                              _servicesController.isEditEventLoading.value
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
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ViewImages(
                                      tripImageUrl: widget.eventObj.image!,
                                      fromNetwork: true,
                                      Type: 'event'));
                                },
                                child: _servicesController.images.isEmpty
                                    ? Image.asset(
                                        'assets/images/Placeholder.png',
                                        height: height * 0.3,
                                        fit: BoxFit.cover,
                                      )
                                    : CarouselSlider.builder(
                                        carouselController: _carouselController,
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
                                                        ? FontWeight.w500
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
                                if ((widget
                                        .eventObj.priceIncludesAr?.isNotEmpty ??
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
                                              left: 6, right: 6),
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
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: _textField1Controller,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'seatHint'.tr,
                                              hintStyle: TextStyle(
                                                color: Graytext,
                                                fontSize: 15,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged: (newValue) =>
                                                _servicesController
                                                        .seletedSeat.value =
                                                    int.tryParse(newValue) ?? 0,
                                          ),
                                        ),
                                        if (guestEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              AppUtil.rtlDirection2(context)
                                                  ? 'يجب ان تستقبل شخص على الأقل '
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
                                          ? 'التواريخ المتاحة'
                                          : 'AvailableDates',
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
                                                        //  DateErrorMessage ??
                                                        //         false ||
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
                                                        type: 'event',
                                                        eventController:
                                                            _servicesController,
                                                      );
                                                    });
                                              },
                                              child: CustomText(
                                                text: _servicesController
                                                        .isEventDateSelcted
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
                                        // DateErrorMessage ??
                                        //   false ||
                                        _servicesController
                                            .DateErrorMessage.value)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          // DateErrorMessage ?? false
                                          _servicesController
                                                  .EmptyDateErrorMessage.value
                                              ? AppUtil.rtlDirection2(context)
                                                  ? "اختر التاريخ"
                                                  : "You need to choose a valid date"
                                              : AppUtil.rtlDirection2(context)
                                                  ? "يجب اختيار تاريخ بعد اليوم الحالي"
                                                  : "Please choose a date after today",
                                          style: TextStyle(
                                            color: colorRed,
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
                                                      ? "وقت الفعالية"
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
                                                      // onTap: () {
                                                      //   showCupertinoModalPopup<
                                                      //           void>(
                                                      //       context: context,
                                                      //       barrierDismissible:
                                                      //           false,
                                                      //       builder: (BuildContext
                                                      //           context) {
                                                      //         return Column(
                                                      //           mainAxisAlignment:
                                                      //               MainAxisAlignment
                                                      //                   .end,
                                                      //           children: [
                                                      //             Container(
                                                      //               decoration:
                                                      //                   BoxDecoration(
                                                      //                 color: Color(
                                                      //                     0xffffffff),
                                                      //                 border:
                                                      //                     Border(
                                                      //                   bottom:
                                                      //                       BorderSide(
                                                      //                     width:
                                                      //                         0.0,
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //               child: Row(
                                                      //                 mainAxisAlignment:
                                                      //                     MainAxisAlignment
                                                      //                         .spaceBetween,
                                                      //                 children: <Widget>[
                                                      //                   CupertinoButton(
                                                      //                     onPressed:
                                                      //                         () {
                                                      //                       _servicesController
                                                      //                           .isEventDateSelcted(true);
                                                      //                       setState(
                                                      //                           () {
                                                      //                         Get.back();
                                                      //                         time =
                                                      //                             newTimeToGo;
                                                      //                         _servicesController.selectedStartTime.value =
                                                      //                             newTimeToGo;

                                                      //                         _servicesController.TimeErrorMessage.value =
                                                      //                             AppUtil.isEndTimeLessThanStartTime(  newTimeToGo,newTimeToReturn);
                                                      //                       });
                                                      //                     },
                                                      //                     padding:
                                                      //                         const EdgeInsets.symmetric(
                                                      //                       horizontal:
                                                      //                           16.0,
                                                      //                       vertical:
                                                      //                           5.0,
                                                      //                     ),
                                                      //                     child:
                                                      //                         CustomText(
                                                      //                       text:
                                                      //                           "confirm".tr,
                                                      //                       color:
                                                      //                           colorGreen,
                                                      //                       fontSize:
                                                      //                           15,
                                                      //                       fontFamily: AppUtil.rtlDirection2(context)
                                                      //                           ? 'SF Arabic'
                                                      //                           : 'SF Pro',
                                                      //                       fontWeight:
                                                      //                           FontWeight.w500,
                                                      //                     ),
                                                      //                   )
                                                      //                 ],
                                                      //               ),
                                                      //             ),
                                                      //             Container(
                                                      //               height: 220,
                                                      //               width: width,
                                                      //               margin:
                                                      //                   EdgeInsets
                                                      //                       .only(
                                                      //                 bottom: MediaQuery.of(
                                                      //                         context)
                                                      //                     .viewInsets
                                                      //                     .bottom,
                                                      //               ),
                                                      //               child:
                                                      //                   Container(
                                                      //                 width:
                                                      //                     width,
                                                      //                 color: Colors
                                                      //                     .white,
                                                      //                 child:
                                                      //                     CupertinoDatePicker(
                                                      //                   backgroundColor:
                                                      //                       Colors
                                                      //                           .white,
                                                      //                   initialDateTime:
                                                      //                       newTimeToGo,
                                                      //                   mode: CupertinoDatePickerMode
                                                      //                       .time,
                                                      //                   use24hFormat:
                                                      //                       false,
                                                      //                   onDateTimeChanged:
                                                      //                       (DateTime
                                                      //                           newT) {
                                                      //                     setState(
                                                      //                         () {
                                                      //                       newTimeToGo =
                                                      //                           newT;
                                                      //                       _servicesController
                                                      //                           .selectedStartTime
                                                      //                           .value =  newT;

                                                      //                       _servicesController.TimeErrorMessage.value = AppUtil.isEndTimeLessThanStartTime(
                                                      //                           newTimeToGo,newTimeToReturn);

                                                      //
                                                      //
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //               ),
                                                      //             ),
                                                      //           ],
                                                      //         );
                                                      //       });
                                                      // },
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
                                                              .isEventTimeSelcted(
                                                                  true);
                                                          _servicesController
                                                                  .EmptyTimeErrorMessage
                                                                  .value =
                                                              !_servicesController
                                                                  .isEventTimeSelcted
                                                                  .value;
                                                          setState(() {
                                                            time = newTimeToGo;
                                                            newTimeToGo = newT;
                                                            _servicesController
                                                                .selectedStartTime
                                                                .value = newT;

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
                                                                .isEventDateSelcted
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
                                                              .isEventTimeSelcted(
                                                                  true);
                                                          _servicesController
                                                                  .EmptyTimeErrorMessage
                                                                  .value =
                                                              !_servicesController
                                                                  .isEventTimeSelcted
                                                                  .value;
                                                          setState(() {
                                                            time = newTimeToGo;

                                                            newTimeToGo = newT;
                                                            _servicesController
                                                                .selectedStartTime
                                                                .value = newT;

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

                                                            if (_servicesController
                                                                .isEventDateSelcted
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
                                                                .isEventTimeSelcted
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
                                                              .tr
                                                          : '',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFFDC362E),
                                                    fontSize: width * 0.028,
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
                                                      ? "إلى"
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
                                                                // TimeErrorMessage ??
                                                                //         false ||
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
                                                      // onTap: () {
                                                      //   showCupertinoModalPopup<
                                                      //           void>(
                                                      //       context: context,
                                                      //       barrierDismissible:
                                                      //           false,
                                                      //       builder: (BuildContext
                                                      //           context) {
                                                      //         return Column(
                                                      //           mainAxisAlignment:
                                                      //               MainAxisAlignment
                                                      //                   .end,
                                                      //           children: [
                                                      //             Container(
                                                      //               decoration:
                                                      //                   BoxDecoration(
                                                      //                 color: Color(
                                                      //                     0xffffffff),
                                                      //                 border:
                                                      //                     Border(
                                                      //                   bottom:
                                                      //                       BorderSide(
                                                      //                     width:
                                                      //                         0.0,
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //               child: Row(
                                                      //                 mainAxisAlignment:
                                                      //                     MainAxisAlignment
                                                      //                         .spaceBetween,
                                                      //                 children: <Widget>[
                                                      //                   CupertinoButton(
                                                      //                     onPressed:
                                                      //                         () {
                                                      //                       _servicesController
                                                      //                           .isEventTimeSelcted(true);

                                                      //                       setState(
                                                      //                           () {
                                                      //                         Get.back();
                                                      //                         returnTime =
                                                      //                             newTimeToReturn;
                                                      //                         _servicesController.selectedEndTime.value =
                                                      //                             newTimeToReturn;

                                                      //                         _servicesController.TimeErrorMessage.value =
                                                      //                             AppUtil.isEndTimeLessThanStartTime(_servicesController.selectedStartTime.value, _servicesController.selectedEndTime.value);
                                                      //                       });
                                                      //                     },
                                                      //                     padding:
                                                      //                         const EdgeInsets.symmetric(
                                                      //                       horizontal:
                                                      //                           16.0,
                                                      //                       vertical:
                                                      //                           5.0,
                                                      //                     ),
                                                      //                     child:
                                                      //                         CustomText(
                                                      //                       text:
                                                      //                           "confirm".tr,
                                                      //                       color:
                                                      //                           colorGreen,
                                                      //                     ),
                                                      //                   )
                                                      //                 ],
                                                      //               ),
                                                      //             ),
                                                      //             Container(
                                                      //               height: 220,
                                                      //               width: width,
                                                      //               margin:
                                                      //                   EdgeInsets
                                                      //                       .only(
                                                      //                 bottom: MediaQuery.of(
                                                      //                         context)
                                                      //                     .viewInsets
                                                      //                     .bottom,
                                                      //               ),
                                                      //               child:
                                                      //                   Container(
                                                      //                 width:
                                                      //                     width,
                                                      //                 color: Colors
                                                      //                     .white,
                                                      //                 child:
                                                      //                     CupertinoDatePicker(
                                                      //                   backgroundColor:
                                                      //                       Colors
                                                      //                           .white,
                                                      //                   initialDateTime:
                                                      //                       newTimeToReturn,
                                                      //                   mode: CupertinoDatePickerMode
                                                      //                       .time,
                                                      //                   use24hFormat:
                                                      //                       false,
                                                      //                   onDateTimeChanged:
                                                      //                       (DateTime
                                                      //                           newT) {
                                                      //                     print(DateFormat('HH:mm:ss')
                                                      //                         .format(newTimeToReturn));
                                                      //                     setState(
                                                      //                         () {
                                                      //                       newTimeToReturn =
                                                      //                           newT;
                                                      //                       _servicesController
                                                      //                           .selectedEndTime
                                                      //                           .value = newT;

                                                      //                       _servicesController.TimeErrorMessage.value = AppUtil.isEndTimeLessThanStartTime(
                                                      //                           _servicesController.selectedStartTime.value,
                                                      //                           _servicesController.selectedEndTime.value);
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //               ),
                                                      //             ),
                                                      //           ],
                                                      //         );
                                                      //       });
                                                      // },

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
                                                                    newTimeToReturn,
                                                                onConfirm:
                                                                    (newT) {
                                                          _servicesController
                                                              .isEventTimeSelcted(
                                                                  true);
                                                          _servicesController
                                                                  .EmptyTimeErrorMessage
                                                                  .value =
                                                              !_servicesController
                                                                  .isEventTimeSelcted
                                                                  .value;
                                                          setState(() {
                                                            returnTime =
                                                                newTimeToReturn;
                                                            newTimeToReturn =
                                                                newT;
                                                            _servicesController
                                                                .selectedEndTime
                                                                .value = newT;

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
                                                            log(_servicesController
                                                                .TimeErrorMessage
                                                                .value
                                                                .toString());
                                                          });
                                                        }, onChanged: (newT) {
                                                          _servicesController
                                                              .isEventTimeSelcted(
                                                                  true);
                                                          _servicesController
                                                                  .EmptyTimeErrorMessage
                                                                  .value =
                                                              !_servicesController
                                                                  .isEventTimeSelcted
                                                                  .value;
                                                          setState(() {
                                                            newTimeToReturn =
                                                                newT;
                                                            _servicesController
                                                                .selectedEndTime
                                                                .value = newT;

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
                                                            log(_servicesController
                                                                .TimeErrorMessage
                                                                .value
                                                                .toString());
                                                          });
                                                        });
                                                      },
                                                      child: CustomText(
                                                        text: _servicesController
                                                                .isEventTimeSelcted
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
                                                          color: const Color(
                                                              0xFFDC362E),
                                                          fontSize:
                                                              width * 0.028,
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
                                              padding: EdgeInsets.only(
                                                  bottom: width * 0.102),
                                              scrollGesturesEnabled: true,
                                              zoomControlsEnabled: false,
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
                                                color: const Color(
                                                    0xFFE2E2E2), // Change this to your desired border color
                                                width:
                                                    2, // Change this to your desired border width
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
                                      text: "price".tr,
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
                                            : '00.00 SAR / per person',
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
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Graytext,
                                          ),
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
                                                      : 'السعر يجب أن يكون اكبر من أو يساوي 1'
                                              : PriceEmpty
                                                  ? 'You need to add a valid price'
                                                  : PriceDouble
                                                      ? '*The price must be an integer value only'
                                                      : 'You need to add a valid price, >= 1',
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

                        //indicator

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
