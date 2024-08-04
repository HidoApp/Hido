import 'dart:developer';

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/add_experience_info.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_hospitality_calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/local_home_screen.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';
import 'package:ajwad_v4/services/view/widgets/images_services_widget.dart';
import 'package:ajwad_v4/services/view/widgets/reservation_details_sheet.dart';
import 'package:ajwad_v4/services/view/widgets/hospitality_booking_sheet.dart';
import 'package:ajwad_v4/services/view/widgets/service_profile_card.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/floating_booking_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:toggle_switch/toggle_switch.dart';

import '../widget/image_slider.dart';

class EditHospitality extends StatefulWidget {
  const EditHospitality({
    Key? key,
    required this.hospitalityObj,
    this.experienceType,
  }) : super(key: key);

  final Hospitality hospitalityObj;
  final String? experienceType;

  @override
  State<EditHospitality> createState() => _EditHospitalityState();
}

late double width, height;

class _EditHospitalityState extends State<EditHospitality> {
  final _servicesController = Get.put(HospitalityController());
  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN
  bool _isLoading = true;

  List<DateTime> avilableDate = [];
  var locLatLang = const LatLng(24.691846000000012, 46.68552199999999);
  final TextEditingController hospitalityTitleControllerEn =
      TextEditingController();
  final TextEditingController hospitalityBioControllerEn =
      TextEditingController();

  final TextEditingController hospitalityTitleControllerAr =
      TextEditingController();
  final TextEditingController hospitalityBioControllerAr =
      TextEditingController();

  String address = '';
  

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

  late LatLng _currentPosition;
  var hideLocation = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //    initializeDateFormatting(); //very important

    //addCustomIcon();
    //getHospitalityById();

    _servicesController.isHospatilityDateSelcted(false);
    _servicesController.selectedDate('');
    _servicesController.selectedDateIndex(-1);

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
      print(placemarks);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print(placemarks.first);
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
    } catch (e) {
      print("Error retrieving address: $e");
    }
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

  final CarouselController _carouselController = CarouselController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();

  int? _selectedRadio1;
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

  String gender = '';

  Future<void> validateAndSave() async {
    setState(() {
      titleArEmpty = hospitalityTitleControllerAr.text.isEmpty;
      bioArEmpty = hospitalityBioControllerAr.text.isEmpty;

      titleENEmpty = hospitalityTitleControllerEn.text.isEmpty;
      bioEnEmpty = hospitalityBioControllerEn.text.isEmpty;

      _selectedLanguageIndex =
          (titleArEmpty || bioArEmpty) && !(titleENEmpty && bioEnEmpty) ? 0 : 1;

      guestEmpty = guestNum == 0;

      DateErrorMessage = !_servicesController.isHospatilityDateSelcted.value;
      TimeErrorMessage = !_servicesController.isHospatilityTimeSelcted.value;

      // !AppUtil.isDateBefore24Hours(_servicesController.selectedDate.value);
      PriceEmpty = _priceController.text.isEmpty;

      PriceEmpty = _priceController.text.isEmpty;
      if (_priceController.text.isNotEmpty) {
        int? price = int.tryParse(_priceController.text);
        PriceLarger = price == null || price! < 150;
        print(PriceLarger = price == null || price! < 150);

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
        !DateErrorMessage! &&
        !TimeErrorMessage! &&
        !PriceEmpty &&
        !PriceLarger &&
        !PriceDouble &&
        _servicesController.DateErrorMessage.value &&
        !_servicesController.TimeErrorMessage.value) {
      daysInfo();
      _updateProfile();
    } else {
      if (!_servicesController.DateErrorMessage.value) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'DateDuration'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
      }
      if (_servicesController.TimeErrorMessage.value) {
        if (context.mounted) {
          AppUtil.errorToast(context, 'TimeDuration'.tr);
          await Future.delayed(const Duration(seconds: 3));
        }
      }
      print("Please fill all required fields");
    }
  }

  void updateData() {
    setState(() {
      hospitalityTitleControllerAr.text = widget.hospitalityObj.titleAr;
      hospitalityBioControllerAr.text = widget.hospitalityObj.bioAr;

      hospitalityTitleControllerEn.text = widget.hospitalityObj.titleEn;
      hospitalityBioControllerEn.text = widget.hospitalityObj.bioEn;

      mealTypeAr = widget.hospitalityObj.mealTypeAr;
      mealTypeEn = widget.hospitalityObj.mealTypeEn;
      guestNum = widget.hospitalityObj.daysInfo.first.seats;
      newTimeToGo =
          DateTime.parse(widget.hospitalityObj.daysInfo.first.startTime);
      newTimeToReturn =
          DateTime.parse(widget.hospitalityObj.daysInfo.first.endTime);
      _servicesController.selectedDate.value =
          widget.hospitalityObj.daysInfo.first.endTime;
      _priceController.text = widget.hospitalityObj.price.toString();
      _selectRadio(widget.hospitalityObj.mealTypeEn);
      _selectRadio(widget.hospitalityObj.touristsGender ?? '');

      _guestsController.text = widget.hospitalityObj.touristsGender ?? '';

      _servicesController.isHospatilityDateSelcted.value = true;
      _servicesController.isHospatilityTimeSelcted.value = true;

      _servicesController.DateErrorMessage.value = true;

      _servicesController.pickUpLocLatLang.value = LatLng(
          double.parse(widget.hospitalityObj.coordinate.latitude ?? ''),
          double.parse(widget.hospitalityObj.coordinate.longitude ?? ''));

      locationUrl = getLocationUrl(_servicesController.pickUpLocLatLang.value);
    });
  }

  String getLocationUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  void daysInfo() {
    // Format for combining date and time
    var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateTime date = DateTime.parse(_servicesController.selectedDate.value);

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

    startTime = formatter.format(newStartTime);
    endTime = formatter.format(newEndTime);
  }

  void _updateGender(int? newValue) {
    setState(() {
      _selectedRadio1 = newValue;
      if (_selectedRadio1 == 1) {
        _guestsController.text = "FEMALE";
      } else if (_selectedRadio1 == 2) {
        _guestsController.text = "MALE";
      } else if (_selectedRadio1 == 3) {
        _guestsController.text = "BOTH";
      }
      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }

  void _selectRadio(String newValue) {
    setState(() {
      if (newValue == "FEMALE") {
        _selectedRadio1 = 1;
      } else if (newValue == "MALE") {
        _selectedRadio1 = 2;
      } else if (newValue == "BOTH") {
        _selectedRadio1 = 3;
      } else if (newValue == "BREAKFAST" || newValue == "إفطار") {
        _selectedRadio2 = 1;
      } else if (newValue == "LUNCH" || newValue == "غداء") {
        _selectedRadio2 = 2;
      } else if (newValue == "Dinner" || newValue == "عشاء") {
        _selectedRadio2 = 3;
      }

      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
//  late tz.Location location;
  bool? DateErrorMessage;
  bool? TimeErrorMessage;
  bool? DurationErrorMessage;
  bool? DurationDateError;

  bool? GuestErrorMessage;
  int selectedChoice = 3;
  final srvicesController = Get.put(HospitalityController());

  void _updateMeal(int? newValue) {
    setState(() {
      _selectedRadio2 = newValue ?? 2;
      if (_selectedRadio2 == 1) {
        mealTypeEn = "BREAKFAST";
        mealTypeAr = "إفطار";
      } else if (_selectedRadio2 == 3) {
        mealTypeEn = "Dinner";
        mealTypeAr = "عشاء";
      } else if (_selectedRadio2 == 2) {
        mealTypeEn = "LUNCH";
        mealTypeAr = "غداء";
      }
      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }

  Future<void> _updateProfile() async {
    try {
      print("Updating hospitality with the following data:");
      print("ID: ${widget.hospitalityObj.id}");
      print("Title AR: ${hospitalityTitleControllerAr.text}");
      print("Title EN: ${hospitalityTitleControllerEn.text}");
      print("Bio AR: ${hospitalityBioControllerAr.text}");
      print("Bio EN: ${hospitalityBioControllerEn.text}");
      print("Meal Type AR: $mealTypeAr");
      print("Meal Type EN: $mealTypeEn");
      print(
          "Longitude: ${_servicesController.pickUpLocLatLang.value.longitude}");
      print("Latitude: ${_servicesController.pickUpLocLatLang.value.latitude}");
      print("Tourists Gender: ${_guestsController.text}");
      print("Price: ${double.parse(_priceController.text)}");
      print("Images: ${widget.hospitalityObj.images}");
      print("Region AR: ${widget.hospitalityObj.regionAr}");
      print("Location: $locationUrl");
      print("Region EN: ${widget.hospitalityObj.regionEn}");
      print("Start Time: $startTime");
      print("End Time: $endTime");
      print("Guest Number: $guestNum");
      final Hospitality? result = await _servicesController.editHospatility(
        id: widget.hospitalityObj.id,
        titleAr: hospitalityTitleControllerAr.text,
        titleEn: hospitalityTitleControllerEn.text,
        bioAr: hospitalityBioControllerAr.text,
        bioEn: hospitalityBioControllerEn.text,
        mealTypeAr: mealTypeAr,
        mealTypeEn: mealTypeEn,
        longitude:
            _servicesController.pickUpLocLatLang.value.longitude.toString(),
        latitude:
            _servicesController.pickUpLocLatLang.value.latitude.toString(),
        touristsGender: _guestsController.text,
        price: double.parse(_priceController.text),
        images: widget.hospitalityObj.images,
        regionAr: widget.hospitalityObj.regionAr??'',
        location: locationUrl,
        regionEn: widget.hospitalityObj.regionEn,
        start: startTime,
        end: endTime,
        seat: guestNum,
        context: context,
      );

      if (result == null) {
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
                    Text(
                      !AppUtil.rtlDirection2(context)
                          ? "Changes have been saved successfully!"
                          : "تم حفظ التغييرات بنجاح ",
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
          Get.offAll(() => const AjwadiBottomBar());
        });

        print("Profile updated successfully: $result");
      } else {
        // Get.offAll(AddExperienceInfo());
        // Get.offAll(() => const AjwadiBottomBar());

        print("Profile update returned null");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final TextEditingController textField1Controller =
        _selectedLanguageIndex == 0
            ? hospitalityTitleControllerAr
            : hospitalityTitleControllerEn;

    final TextEditingController textField2Controller =
        _selectedLanguageIndex == 0
            ? hospitalityBioControllerAr
            : hospitalityBioControllerEn;
    return Obx(
      () => _servicesController.isHospitalityByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              body: Center(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            )
          : Scaffold(
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        content: Container(
                          width: 500,
                          height: AppUtil.rtlDirection2(context) ? 138 : 138,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 4,
                              ),
                              CustomText(
                                textAlign: TextAlign.center,
                                color: Color(0xFFDC362E),
                                fontSize: 15,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                                text: AppUtil.rtlDirection2(context)
                                    ? "تنبيه"
                                    : "Alert!",
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              CustomText(
                                textAlign: TextAlign.center,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF41404A),
                                text: AppUtil.rtlDirection2(context)
                                    ? "أنت على وشك حذف هذه التجربة"
                                    : 'You’re about to delete this experience',
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  log("End Trip Taped ${widget.hospitalityObj.id}");

                                  bool result = await _servicesController
                                          .hospitalityDelete(
                                              context: context,
                                              hospitalityId:
                                                  widget.hospitalityObj.id) ??
                                      false;
                                  if (result) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Container(
                                            width: 350,
                                            height: 110, // Custom width
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/images/paymentSuccess.gif',
                                                    width: 38),
                                                SizedBox(height: 16),
                                                Text(
                                                  !AppUtil.rtlDirection2(
                                                          context)
                                                      ? 'The experience has been deleted'
                                                      : "تم حذف التجربة بنجاح ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                  ),
                                                  textDirection:
                                                      AppUtil.rtlDirection2(
                                                              context)
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      Get.offAll(() => const AjwadiBottomBar());
                                    });
                                  } else {
                                    if (context.mounted) {
                                      AppUtil.errorToast(context,
                                          'The experience not deleted'.tr);
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                    }
                                  }
                                },
                                child: Container(
                                  height: 34,
                                  width: 278,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDC362E),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    text: AppUtil.rtlDirection2(context)
                                        ? "حذف"
                                        : "Delete",
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  Get.back();
                                },
                                child: Container(
                                    width: 278,
                                    height: 34,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFFDC362E),
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
                                        color: Color(0xFFDC362E),
                                        text: AppUtil.rtlDirection2(context)
                                            ? 'الغاء'
                                            : 'Cancel')),
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
                  padding: EdgeInsets.all(16.0),
                  child: CustomButton(
                      onPressed: () {
                        validateAndSave();
                      },
                      title: 'SaveChanges'.tr)),
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
                                // Get.to(ViewTripImages(
                                //   tripImageUrl: hospitalityObj!.images,
                                //   fromNetwork: true,
                                // ));
                              },
                              child: CarouselSlider.builder(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                    viewportFraction: 1,
                                    onPageChanged: (i, reason) {
                                      setState(() {
                                        _currentIndex = i;
                                      });
                                    }),
                                itemCount: widget.hospitalityObj.images.length,
                                itemBuilder: (context, index, realIndex) {
                                  return ImagesSliderWidget(
                                    image: widget.hospitalityObj.images[index],
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
                          SizedBox(
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
                                      activeBgColors: [
                                        [Colors.white],
                                        [Colors.white]
                                      ],
                                      activeBorders: [
                                        Border.all(
                                            color: Color(0xFFF5F5F5),
                                            width: 2.0),
                                        Border.all(
                                            color: Color(0xFFF5F5F5),
                                            width: 2.0),
                                      ],
                                      activeFgColor: Color(0xFF070708),
                                      inactiveBgColor: Color(0xFFF5F5F5),
                                      inactiveFgColor: Color(0xFF9392A0),
                                      initialLabelIndex: _selectedLanguageIndex,
                                      totalSwitches: 2,
                                      labels: _selectedLanguageIndex == 0
                                          ? ['عربي', 'إنجليزي']
                                          : ['AR', 'EN'],
                                      radiusStyle: true,
                                      customTextStyles: [
                                        TextStyle(
                                          fontSize: _selectedLanguageIndex == 0
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
                                          fontSize: _selectedLanguageIndex == 0
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
                                      ],
                                      customHeights: [90, 90],
                                      onToggle: (index) {
                                        setState(() {
                                          _selectedLanguageIndex = index!;
                                        });
                                        print('switched to: $index');
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
                                              color: Color(0xFF070708),
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
                                                              ? Colors.red
                                                              : Color(
                                                                  0xFFB9B8C1)
                                                          : titleENEmpty
                                                              ? Colors.red
                                                              : Color(
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
                                                controller:
                                                    textField1Controller,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      _selectedLanguageIndex ==
                                                              0
                                                          ? 'مثال: منزل دانا'
                                                          : 'example: Dana’s house',
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFFB9B8C1),
                                                    fontSize: 15,
                                                    fontFamily:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (titleArEmpty &&
                                              _selectedLanguageIndex == 0)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
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
                                              color: Color(0xFF070708),
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
                                                    color:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? bioArEmpty
                                                                ? Colors.red
                                                                : Color(
                                                                    0xFFB9B8C1)
                                                            : bioEnEmpty
                                                                ? Colors.red
                                                                : Color(
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
                                                maxLines: 8,
                                                minLines: 1,
                                                controller:
                                                    textField2Controller,
                                                inputFormatters: [
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
                                                    color: Color(0xFFB9B8C1),
                                                    fontSize: 15,
                                                    fontFamily:
                                                        _selectedLanguageIndex ==
                                                                0
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (bioEnEmpty &&
                                              _selectedLanguageIndex == 1)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
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
                                                color: Color(0xFFB9B8C1),
                                                fontSize: 11,
                                                fontFamily:
                                                    _selectedLanguageIndex == 0
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
                                   crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    ? Colors.red
                                                    : Color(0xFFB9B8C1)),
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
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                              fontSize: 15,
                                            ),
                                            Spacer(),
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
                                                    color: Graytext, size: 24)),
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
                                              color: Color(0xFFDC362E),
                                              fontSize: 11,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: width * 0.047,
                                      ),
                                      CustomText(
                                        text: "Accepts".tr,
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                      ),
                                      SizedBox(
                                        height: width * 0.025,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Radio<int>(
                                                  value: 1,
                                                  groupValue: _selectedRadio1,
                                                  onChanged: _updateGender,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  visualDensity: VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                                  fillColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .selected)) {
                                                      return Colors.green;
                                                    }
                                                    return Colors.grey;
                                                  }),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "female".tr,
                                                  style: TextStyle(
                                                    color: Color(0xFF41404A),
                                                    fontSize: 13,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Radio<int>(
                                                  value: 2,
                                                  groupValue: _selectedRadio1,
                                                  onChanged: _updateGender,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  visualDensity: VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                                  fillColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .selected)) {
                                                      return Colors.green;
                                                    }
                                                    return Colors.grey;
                                                  }),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'male'.tr,
                                                  style: TextStyle(
                                                    color: Color(0xFF41404A),
                                                    fontSize: 13,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Radio<int>(
                                                  value: 3,
                                                  groupValue: _selectedRadio1,
                                                  onChanged: _updateGender,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  visualDensity: VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                                  fillColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .selected)) {
                                                      return Colors.green;
                                                    }
                                                    return Colors.grey;
                                                  }),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'both'.tr,
                                                  style: TextStyle(
                                                    color: Color(0xFF41404A),
                                                    fontSize: 13,
                                                    fontFamily:
                                                        AppUtil.rtlDirection2(
                                                                context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                    text: 'AvailableDates'.tr,
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
                                              color: DateErrorMessage ??
                                                      false ||
                                                          !_servicesController
                                                              .DateErrorMessage
                                                              .value
                                                  ? Colors.red
                                                  : Color(0xFFB9B8C1)),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              print("object");
                                              setState(() {
                                                selectedChoice = 3;
                                              });

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return HostCalenderDialog(
                                                      type: 'hospitality',
                                                      srvicesController:
                                                          _servicesController,
                                                    );
                                                  });

                                              //
                                            },
                                            child: CustomText(
                                              text: AppUtil.formatBookingDate(
                                                context,
                                                _servicesController
                                                    .selectedDate.value
                                                    .substring(0, 10),
                                              ),
                                              fontWeight: FontWeight.w400,
                                              color: Graytext,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? 'SF Arabic'
                                                      : 'SF Pro',
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (DateErrorMessage ??
                                      false ||
                                          !_servicesController
                                              .DateErrorMessage.value)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        DateErrorMessage ?? false
                                            ? AppUtil.rtlDirection2(context)
                                                ? "اختر التاريخ"
                                                : "You need to choose a valid date"
                                            : AppUtil.rtlDirection2(context)
                                                ? "يجب اختيار تاريخ بعد 48 ساعة من الآن على الأقل"
                                                : "*Please select a date at least 48 hours from now",
                                        style: TextStyle(
                                          color: Color(0xFFDC362E),
                                          fontSize: 11,
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
                                            text: AppUtil.rtlDirection2(context)
                                                ? "وقت الاستضافة من"
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
                                                      color: TimeErrorMessage ??
                                                              false
                                                          ? Colors.red
                                                          : DurationErrorMessage ??
                                                                  false
                                                              ? Colors.red
                                                              : Color(
                                                                  0xFFB9B8C1)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await DatePickerBdaya
                                                          .showTime12hPicker(
                                                        context,
                                                       locale:AppUtil.rtlDirection2(context)?LocaleType.ar:LocaleType.en ,
                                                        showTitleActions: true,
                                                        currentTime:
                                                            newTimeToGo,
                                                        onConfirm: (newT) {
                                                          setState(() {
                                                            newTimeToGo = newT;
                                                            _servicesController
                                                         .isHospatilityTimeSelcted(true);

                                                            _servicesController
                                                                    .selectedStartTime
                                                                    .value =
                                                                newTimeToGo;

                                                            _servicesController
                                                                    .TimeErrorMessage
                                                                    .value =
                                                                AppUtil.isEndTimeLessThanStartTime(
                                                                    newTimeToGo,
                                                                    newTimeToReturn);
                                                          });
                                                        },
                                                        onChanged: (newT) {
                                                          setState(() {
                                                            newTimeToGo = newT;
                                                            _servicesController
                                                         .isHospatilityTimeSelcted(true);

                                                            _servicesController
                                                                    .selectedStartTime
                                                                    .value =
                                                                newTimeToGo;

                                                            _servicesController
                                                                    .TimeErrorMessage
                                                                    .value =
                                                                AppUtil.isEndTimeLessThanStartTime(
                                                                    newTimeToGo,
                                                                    newTimeToReturn);
                                                          });
                                                        },
                                                        // showCupertinoModalPopup<
                                                        //         void>(
                                                        //     context: context,
                                                        //     barrierDismissible:
                                                        //         false,
                                                        //     builder: (BuildContext
                                                        //         context) {
                                                        //       return Column(
                                                        //         mainAxisAlignment:
                                                        //             MainAxisAlignment
                                                        //                 .end,
                                                        //         children: [
                                                        //           Container(
                                                        //             decoration:
                                                        //                 BoxDecoration(
                                                        //               color: Color(
                                                        //                   0xffffffff),
                                                        //               border:
                                                        //                   Border(
                                                        //                 bottom:
                                                        //                     BorderSide(
                                                        //                   width:
                                                        //                       0.0,
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             child: Row(
                                                        //               mainAxisAlignment:
                                                        //                   MainAxisAlignment
                                                        //                       .spaceBetween,
                                                        //               children: <Widget>[
                                                        //                 CupertinoButton(
                                                        //                   onPressed:
                                                        //                       () {
                                                        //                     _servicesController
                                                        //                         .isHospatilityTimeSelcted(true);
                                                        //                     setState(
                                                        //                         () {
                                                        //                       Get.back();
                                                        //                       time =
                                                        //                           newTimeToGo;
                                                        //                       _servicesController.selectedStartTime.value =
                                                        //                           newTimeToGo;

                                                        //                       _servicesController.TimeErrorMessage.value =
                                                        //                           AppUtil.isEndTimeLessThanStartTime( newTimeToGo,newTimeToReturn);
                                                        //                     });
                                                        //                   },
                                                        //                   padding:
                                                        //                       const EdgeInsets.symmetric(
                                                        //                     horizontal:
                                                        //                         16.0,
                                                        //                     vertical:
                                                        //                         5.0,
                                                        //                   ),
                                                        //                   child:
                                                        //                       CustomText(
                                                        //                     text:
                                                        //                         "confirm".tr,
                                                        //                     color:
                                                        //                         colorGreen,
                                                        //                     fontSize:
                                                        //                         15,
                                                        //                     fontFamily: AppUtil.rtlDirection2(context)
                                                        //                         ? 'SF Arabic'
                                                        //                         : 'SF Pro',
                                                        //                     fontWeight:
                                                        //                         FontWeight.w500,
                                                        //                   ),
                                                        //                 )
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //           Container(
                                                        //             height: 220,
                                                        //             width: width,
                                                        //             margin:
                                                        //                 EdgeInsets
                                                        //                     .only(
                                                        //               bottom: MediaQuery.of(
                                                        //                       context)
                                                        //                   .viewInsets
                                                        //                   .bottom,
                                                        //             ),
                                                        //             child:
                                                        //                 Container(
                                                        //               width:
                                                        //                   width,
                                                        //               color: Colors
                                                        //                   .white,
                                                        //               child:

                                                        //                   CupertinoDatePicker(
                                                        //                 backgroundColor:
                                                        //                     Colors
                                                        //                         .white,
                                                        //                 initialDateTime:
                                                        //                     newTimeToGo,
                                                        //                 mode: CupertinoDatePickerMode
                                                        //                     .time,
                                                        //                 use24hFormat:
                                                        //                     false,
                                                        //                 onDateTimeChanged:
                                                        //                     (DateTime
                                                        //                         newT) {
                                                        //                   setState(
                                                        //                       () {
                                                        //                     newTimeToGo =
                                                        //                         newT;
                                                        //                     _servicesController
                                                        //                         .selectedStartTime
                                                        //                         .value = newTimeToGo;

                                                        //                     _servicesController.TimeErrorMessage.value = AppUtil.isEndTimeLessThanStartTime(
                                                        //                         newTimeToGo,newTimeToReturn);
                                                        //                   });
                                                        //                 },
                                                        //               ),
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       );
                                                        //     });
                                                      );
                                                    },
                                                    child: CustomText(
                                                      text: AppUtil
                                                          .formatStringTimeWithLocale(
                                                              context,
                                                              DateFormat(
                                                                      'HH:mm:ss')
                                                                  .format(
                                                                      newTimeToGo)),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                          if (TimeErrorMessage ??
                                              false ||
                                                  _servicesController
                                                      .TimeErrorMessage.value)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                !_servicesController
                                                        .TimeErrorMessage.value
                                                    ? AppUtil.rtlDirection2(
                                                            context)
                                                        ? "يجب اختيار الوقت"
                                                        : "Select The Time"
                                                    : '',
                                                style: TextStyle(
                                                  color: Color(0xFFDC362E),
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
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: AppUtil.rtlDirection2(context)
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
                                                      color: TimeErrorMessage ??
                                                              false ||
                                                                  _servicesController
                                                                      .TimeErrorMessage
                                                                      .value
                                                          ? Colors.red
                                                          : DurationErrorMessage ??
                                                                  false
                                                              ? Colors.red
                                                              : Color(
                                                                  0xFFB9B8C1)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                   // onTap: () {
                                                      // showCupertinoModalPopup<
                                                      //         void>(
                                                      //     context: context,
                                                      //     barrierDismissible:
                                                      //         false,
                                                      //     builder: (BuildContext
                                                      //         context) {
                                                      //       return Column(
                                                      //         mainAxisAlignment:
                                                      //             MainAxisAlignment
                                                      //                 .end,
                                                      //         children: [
                                                      //           Container(
                                                      //             decoration:
                                                      //                 BoxDecoration(
                                                      //               color: Color(
                                                      //                   0xffffffff),
                                                      //               border:
                                                      //                   Border(
                                                      //                 bottom:
                                                      //                     BorderSide(
                                                      //                   width:
                                                      //                       0.0,
                                                      //                 ),
                                                      //               ),
                                                      //             ),
                                                      //             child: Row(
                                                      //               mainAxisAlignment:
                                                      //                   MainAxisAlignment
                                                      //                       .spaceBetween,
                                                      //               children: <Widget>[
                                                      //                 CupertinoButton(
                                                      //                   onPressed:
                                                      //                       () {
                                                      //                     _servicesController
                                                      //                         .isHospatilityTimeSelcted(true);

                                                      //                     setState(
                                                      //                         () {
                                                      //                       Get.back();
                                                      //                       returnTime =
                                                      //                           newTimeToReturn;
                                                      //                       _servicesController.selectedEndTime.value =
                                                      //                           newTimeToReturn;

                                                      //                       _servicesController.TimeErrorMessage.value =
                                                      //                           AppUtil.isEndTimeLessThanStartTime(_servicesController.selectedStartTime.value, _servicesController.selectedEndTime.value);
                                                      //                     });
                                                      //                   },
                                                      //                   padding:
                                                      //                       const EdgeInsets.symmetric(
                                                      //                     horizontal:
                                                      //                         16.0,
                                                      //                     vertical:
                                                      //                         5.0,
                                                      //                   ),
                                                      //                   child:
                                                      //                       CustomText(
                                                      //                     text:
                                                      //                         "confirm".tr,
                                                      //                     color:
                                                      //                         colorGreen,
                                                      //                   ),
                                                      //                 )
                                                      //               ],
                                                      //             ),
                                                      //           ),
                                                      //           Container(
                                                      //             height: 220,
                                                      //             width: width,
                                                      //             margin:
                                                      //                 EdgeInsets
                                                      //                     .only(
                                                      //               bottom: MediaQuery.of(
                                                      //                       context)
                                                      //                   .viewInsets
                                                      //                   .bottom,
                                                      //             ),
                                                      //             child:
                                                      //                 Container(
                                                      //               width:
                                                      //                   width,
                                                      //               color: Colors
                                                      //                   .white,
                                                      //               child:
                                                      //                   CupertinoDatePicker(
                                                      //                 backgroundColor:
                                                      //                     Colors
                                                      //                         .white,
                                                      //                 initialDateTime:
                                                      //                     newTimeToReturn,
                                                      //                 mode: CupertinoDatePickerMode
                                                      //                     .time,
                                                      //                 use24hFormat:
                                                      //                     false,
                                                      //                 onDateTimeChanged:
                                                      //                     (DateTime
                                                      //                         newT) {
                                                      //                   print(DateFormat('HH:mm:ss')
                                                      //                       .format(newTimeToReturn));
                                                      //                   setState(
                                                      //                       () {
                                                      //                     newTimeToReturn =
                                                      //                         newT;
                                                      //                     _servicesController
                                                      //                         .selectedEndTime
                                                      //                         .value = newTimeToReturn;

                                                      //                     _servicesController.TimeErrorMessage.value = AppUtil.isEndTimeLessThanStartTime(
                                                      //                         _servicesController.selectedStartTime.value,
                                                      //                         _servicesController.selectedEndTime.value);
                                                      //                   });
                                                      //                 },
                                                      //               ),
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       );
                                                      //     });
                                                   // },
                                                    onTap: () async {
                                                      await DatePickerBdaya
                                                          .showTime12hPicker(
                                                        context,
                                                     locale:AppUtil.rtlDirection2(context)?LocaleType.ar:LocaleType.en ,
                                                        showTitleActions: true,
                                                        currentTime:
                                                            newTimeToReturn,
                                                        onConfirm:
                                                          (newT) {
                                                            _servicesController
                                                      .isHospatilityTimeSelcted(true);

                                                            print(DateFormat(
                                                                    'HH:mm:ss')
                                                                .format(
                                                                    newTimeToReturn));
                                                            setState(() {
                                                              newTimeToReturn =
                                                                  newT;
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
                                                        onChanged:
                                                          (newT) {
                                                            _servicesController
                                                      .isHospatilityTimeSelcted(true);

                                                            print(DateFormat(
                                                                    'HH:mm:ss')
                                                                .format(
                                                                    newTimeToReturn));
                                                            setState(() {
                                                              newTimeToReturn =
                                                                  newT;
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
                                                      text: AppUtil
                                                          .formatStringTimeWithLocale(
                                                              context,
                                                              DateFormat(
                                                                      'HH:mm:ss')
                                                                  .format(
                                                                      newTimeToReturn)),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                          if (TimeErrorMessage ??
                                              false ||
                                                  _servicesController
                                                      .TimeErrorMessage.value)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                !_servicesController
                                                        .TimeErrorMessage.value
                                                    ? AppUtil.rtlDirection2(
                                                            context)
                                                        ? "يجب اختيار الوقت"
                                                        : "Select The Time"
                                                    : AppUtil.rtlDirection2(
                                                            context)
                                                        ? "يجب أن لايسبق وقت بدء التجربة"
                                                        : "*Can’t be before start time",
                                                style: TextStyle(
                                                  color: Color(0xFFDC362E),
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
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: width * 0.047,
                                  ),
                                  CustomText(
                                    text: 'ServedMeal'.tr,
                                    color: black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                  ),
                                  SizedBox(
                                    height: width * 0.025,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Radio<int>(
                                              value: 1,
                                              groupValue: _selectedRadio2,
                                              onChanged: _updateMeal,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity: VisualDensity(
                                                  horizontal: -4, vertical: -4),
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return colorGreen;
                                                }
                                                return dotGreyColor;
                                              }),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Breakfast'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF41404A),
                                                fontSize: 13,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Radio<int>(
                                              value: 2,
                                              groupValue: _selectedRadio2,
                                              onChanged: _updateMeal,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity: VisualDensity(
                                                  horizontal: -4, vertical: -4),
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return colorGreen;
                                                }
                                                return dotGreyColor;
                                              }),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Lunch'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF41404A),
                                                fontSize: 13,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Radio<int>(
                                              value: 3,
                                              groupValue: _selectedRadio2,
                                              onChanged: _updateMeal,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity: VisualDensity(
                                                  horizontal: -4, vertical: -4),
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return colorGreen;
                                                }
                                                return dotGreyColor;
                                              }),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Dinner'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF41404A),
                                                fontSize: 13,
                                                fontFamily:
                                                    AppUtil.rtlDirection2(
                                                            context)
                                                        ? 'SF Arabic'
                                                        : 'SF Pro',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ],
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: almostGrey.withOpacity(0.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          height: 246,
                                          width: 358,
                                          child: GoogleMap(
                                            scrollGesturesEnabled: true,
                                            zoomControlsEnabled: false,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: _currentPosition,
                                              zoom: 15,
                                            ),
                                            markers: {
                                              Marker(
                                                markerId: MarkerId("marker1"),
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
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12)),
                                            border: Border.all(
                                              color: Color(
                                                  0xFFE2E2E2), // Change this to your desired border color
                                              width:
                                                  2, // Change this to your desired border width
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: _isLoading
                                                      ? CircularProgressIndicator()
                                                      : Text(
                                                          address,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF9392A0),
                                                            fontSize: 13,
                                                            fontFamily: AppUtil
                                                                    .rtlDirection2(
                                                                        context)
                                                                ? 'SF Arabic'
                                                                : 'SF Pro',
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                        color: Color(0xFFB9B8C1),
                                        fontSize: 15,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: PriceEmpty ||
                                                  PriceLarger ||
                                                  PriceDouble
                                              ? Color(0xFFDC362E)
                                              : Color(0xFFB9B8C1),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  if (PriceEmpty || PriceLarger || PriceDouble)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                          color: Color(0xFFDC362E),
                                          fontSize: 11,
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
                      Positioned(
                        top: height * 0.256,
                        left: width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.hospitalityObj.images
                              .asMap()
                              .entries
                              .map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  _carouselController.animateToPage(entry.key),
                              child: Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.symmetric(
                                    vertical: width * 0.025,
                                    horizontal: width * 0.009),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == entry.key
                                      ? widget.hospitalityObj.images.length == 1
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.white
                                      : Colors.white.withOpacity(0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
