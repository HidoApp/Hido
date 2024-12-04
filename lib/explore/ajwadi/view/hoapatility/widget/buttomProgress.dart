import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_event_calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_hospitality_calender_dialog.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intel;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../services/controller/hospitality_controller.dart';
import '../../../../../services/model/hospitality.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../view/host_info_review.dart';

class ButtomProgress extends StatefulWidget {
  // int activeIndex;

  const ButtomProgress({
    super.key,
  });

  @override
  _ButtomProgressState createState() => _ButtomProgressState();
}

class _ButtomProgressState extends State<ButtomProgress> {
  bool isFirstButtonPressed = false;
  bool isSecondButtonPressed = false;
  final int totalIndex = 6;
  int activeIndex = 0;

  final TextEditingController hospitalityTitleControllerEn =
      TextEditingController();
  final TextEditingController hospitalityBioControllerEn =
      TextEditingController();

  final TextEditingController hospitalityTitleControllerAr =
      TextEditingController();
  final TextEditingController hospitalityBioControllerAr =
      TextEditingController();

  final TextEditingController hospitalityLocation = TextEditingController();
  final TextEditingController hospitalityPrice = TextEditingController();

  final List<String> _hospitalityImages = [];
  int seats = 0;
  String gender = '';
  final HospitalityController _hospitalityController =
      Get.put(HospitalityController());

  void _handleGuestNumChanged(int newGuestNum) {
    setState(() {
      seats = newGuestNum;
    });
  }

  void _handleGenderChanged(String newGender) {
    setState(() {
      gender = newGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          _appBarText(),
          isAjwadi: true,
          isBack: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                // Your main content here
                child: nextStep(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: activeIndex + 1,
                selectedColor: const Color(0xFF36B268),
                unselectedColor: const Color(0xFFDCDCE0),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 14, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    previousButton(),
                    nextButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nextStep() {
    switch (activeIndex) {
      case 0:
        return AddHospitalityInfo(
          textField1ControllerAR: hospitalityTitleControllerAr,
          textField2ControllerAR: hospitalityBioControllerAr,
          textField1ControllerEN: hospitalityTitleControllerEn,
          textField2ControllerEN: hospitalityBioControllerEn,
        );
      case 1:
        return AddHospitalityLocation(
          textField1Controller: hospitalityLocation,
          hospitalityController: _hospitalityController,
        );
      case 2:
        return PhotoGalleryPage(selectedImages: _hospitalityImages);
      case 3:

        //
        return AddGuests(hospitalityController: _hospitalityController);
      case 4:
        return SelectDateTime(hospitalityController: _hospitalityController);
      case 5:

        // print(
        //  'Selected Start Time: ${_hospitalityController.selectedDate.value}');

        return PriceDecisionCard(priceController: hospitalityPrice);

      default:
        return PhotoGalleryPage(
            selectedImages:
                _hospitalityImages); // Replace with your actual widget
    }
  }

  bool _validateFields() {
    if (activeIndex == 0) {
      return hospitalityTitleControllerEn.text.isNotEmpty &&
          hospitalityBioControllerEn.text.isNotEmpty &&
          hospitalityTitleControllerAr.text.isNotEmpty &&
          hospitalityBioControllerAr.text.isNotEmpty;
    }
    if (activeIndex == 1) {
      return _hospitalityController.pickUpLocLatLang.value !=
              const LatLng(0.0, 0.0) &&
          _hospitalityController.ragionAr.isNotEmpty &&
          _hospitalityController.ragionEn.isNotEmpty;
    }
    if (activeIndex == 2) {
      return _hospitalityController.selectedImages.length >= 3;
    }
    if (activeIndex == 3) {
      return _hospitalityController.seletedSeat.value != 0 &&
          _hospitalityController.selectedGender.value != '';
    }
    if (activeIndex == 4) {
      return _hospitalityController.selectedDates.isNotEmpty &&
          _hospitalityController.isHospatilityDateSelcted.value &&
          _hospitalityController.isHospatilityTimeSelcted.value &&
          _hospitalityController.selectedMealEn.value != '' &&
          !_hospitalityController.TimeErrorMessage.value &&
          !_hospitalityController.newRangeTimeErrorMessage.value &&
          // _hospitalityController.DateErrorMessage.value;
          !_hospitalityController.DateErrorMessage.value;
    }

    if (activeIndex == 5) {
      if (hospitalityPrice.text.isNotEmpty) {
        int? price = int.tryParse(hospitalityPrice.text);
        if (price != null && price >= 150) {
          return true;
        }
      }
      return false;
    }

    return true; // Add validation for other steps if needed
  }

  String _appBarText() {
    if (activeIndex == 0) {
      return "GeneralInformation".tr;
    }
    if (activeIndex == 1) {
      return "Location".tr;
    }
    if (activeIndex == 2) {
      return "PhotoGallery".tr;
    }
    if (activeIndex == 3) {
      return "GuestNumber".tr;
    }
    if (activeIndex == 4) {
      return "Date&Time".tr;
    }
    if (activeIndex == 5) {
      return "Price".tr;
    }
    return ""; // Add validation for other steps if needed
  }

  Widget nextButton() {
    if (activeIndex != 0) {
      return Obx(() {
        return IgnorePointer(
          ignoring: !_validateFields(),
          child: Opacity(
            opacity: _validateFields() ? 1.0 : 0.5,
            child: GestureDetector(
              onTap: () {
                if (activeIndex < totalIndex - 1) {
                  setState(() {
                    activeIndex++;
                  });
                } else if (activeIndex == totalIndex - 1) {
                  Get.to(() => HostInfoReview(
                        hospitalityTitleEn: hospitalityTitleControllerEn.text,
                        hospitalityBioEn: hospitalityBioControllerEn.text,
                        hospitalityTitleAr: hospitalityTitleControllerAr.text,
                        hospitalityBioAr: hospitalityBioControllerAr.text,
                        hospitalityPrice: int.parse(hospitalityPrice.text),
                        hospitalityImages: _hospitalityImages,
                        hospitalityController: _hospitalityController,
                        hospitalityLocation: hospitalityLocation.text,
                        experienceType: 'hospitality',
                      ));
                }
              },
              child: Container(
                width: 157,
                height: 48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFF36B268),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Next'.tr,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                  height: 0.10,
                ),
              ),
            ),
          ),
        );
      });
    } else {
      return IgnorePointer(
        ignoring: !_validateFields(),
        child: Opacity(
          opacity: _validateFields() ? 1.0 : 0.5,
          child: GestureDetector(
            onTap: () {
              setState(() {
                activeIndex++;
              });
            },
            child: Container(
              width: 157,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFF36B268),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: 'Next'.tr,
                textAlign: TextAlign.center,
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'HT Rakik',
                fontWeight: FontWeight.w500,
                height: 0.10,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget previousButton() {
    return GestureDetector(
      onTap: () {
        if (activeIndex > 0) {
          setState(() {
            activeIndex--;
          });
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 157,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: 'Back'.tr,
          textAlign: TextAlign.center,
          color: const Color(0xFF070708),
          fontSize: 17,
          fontFamily: 'HT Rakik',
          fontWeight: FontWeight.w500,
          height: 0.10,
        ),
      ),
    );
  }
}

class AddHospitalityInfo extends StatefulWidget {
  const AddHospitalityInfo({
    Key? key,
    required this.textField1ControllerEN,
    required this.textField2ControllerEN,
    required this.textField1ControllerAR,
    required this.textField2ControllerAR,
  }) : super(key: key);

  final TextEditingController textField1ControllerEN;
  final TextEditingController textField2ControllerEN;
  final TextEditingController textField1ControllerAR;
  final TextEditingController textField2ControllerAR;

  @override
  _AddHospitalityInfoState createState() => _AddHospitalityInfoState();
}

class _AddHospitalityInfoState extends State<AddHospitalityInfo> {
  int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedLanguageIndex = AppUtil.rtlDirection2(context) ? 0 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.of(context).size.height;

    final TextEditingController textField1Controller =
        _selectedLanguageIndex == 0
            ? widget.textField1ControllerAR
            : widget.textField1ControllerEN;
    final TextEditingController textField2Controller =
        _selectedLanguageIndex == 0
            ? widget.textField2ControllerAR
            : widget.textField2ControllerEN;

    return Column(
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
                  Border.all(color: const Color(0xFFF5F5F5), width: 2.0),
                  Border.all(color: const Color(0xFFF5F5F5), width: 2.0),
                ],
                activeFgColor: const Color(0xFF070708),
                inactiveBgColor: const Color(0xFFF5F5F5),
                inactiveFgColor: const Color(0xFF9392A0),
                initialLabelIndex: _selectedLanguageIndex,
                totalSwitches: 2,
                labels: _selectedLanguageIndex == 0
                    ? ['عربي', 'إنجليزي']
                    : ['AR', 'EN'],
                radiusStyle: true,
                customTextStyles: [
                  TextStyle(
                    fontSize: _selectedLanguageIndex == 0 ? 11 : 13,
                    fontFamily:
                        _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                    fontWeight: _selectedLanguageIndex == 0
                        ? FontWeight.w500
                        : FontWeight.w500,
                  ),
                  TextStyle(
                    fontSize: _selectedLanguageIndex == 0 ? 10 : 13,
                    fontFamily:
                        _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                    fontWeight: _selectedLanguageIndex == 0
                        ? FontWeight.w500
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: _selectedLanguageIndex == 0
                          ? 'عنوان التجربة'
                          : 'Experience title',
                      color: const Color(0xFF070708),
                      fontSize: 17,
                      fontFamily:
                          _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                      fontWeight: _selectedLanguageIndex == 0
                          ? FontWeight.w600
                          : FontWeight.w500,
                      height: 0,
                    ),
                    SizedBox(height: _selectedLanguageIndex == 0 ? 8 : 9),
                    TextField(
                      maxLength: 20,
                      controller: textField1Controller,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: _selectedLanguageIndex == 0
                            ? 'مثال: منزل دانا'
                            : 'example: Dana’s house',
                        hintStyle: TextStyle(
                          color: const Color(0xFFB9B8C1),
                          fontSize: 15,
                          fontFamily: _selectedLanguageIndex == 0
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0), // Adjust vertical padding for height
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              width: 1, color: Color(0xFFB9B8C1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color(
                                  0xFFB9B8C1)), // Same color to remove focus color
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: _selectedLanguageIndex == 0 ? 'الوصف' : 'Description',
                    color: const Color(0xFF070708),
                    fontSize: 17,
                    fontFamily:
                        _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                    fontWeight: _selectedLanguageIndex == 0
                        ? FontWeight.w600
                        : FontWeight.w500,
                    height: 0,
                  ),
                  SizedBox(height: _selectedLanguageIndex == 0 ? 8 : 9),
                  Container(
                    width: double.infinity,
                    height: 133,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFB9B8C1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: TextField(
                        maxLines: 8,
                        // minLines: 1,
                        controller: textField2Controller,
                        focusNode: _focusNode,
                        inputFormatters: [
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              if (newValue.text
                                      .split(RegExp(r'\s+'))
                                      .where((word) => word.isNotEmpty)
                                      .length >
                                  150) {
                                return oldValue;
                              }
                              return newValue;
                            },
                          ),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: _selectedLanguageIndex == 0
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: _selectedLanguageIndex == 0
                              ? 'أذكر أبرز ما يميزها ولماذا يجب على السياح زيارتها'
                              : 'highlight what makes it unique and why tourists should visit',
                          hintStyle: TextStyle(
                            color: const Color(0xFFB9B8C1),
                            fontSize: 15,
                            fontFamily: _selectedLanguageIndex == 0
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                    child: CustomText(
                      text: _selectedLanguageIndex == 0
                          ? '*يجب ألا يتجاوز الوصف 150 كلمة'
                          : '*the description must not exceed 150 words',
                      color: const Color(0xFFB9B8C1),
                      fontSize: 11,
                      fontFamily:
                          _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddHospitalityLocation extends StatefulWidget {
  const AddHospitalityLocation({
    Key? key,
    required this.textField1Controller,
    required this.hospitalityController,
  }) : super(key: key);

  final TextEditingController textField1Controller;
  final HospitalityController hospitalityController;

  @override
  _AddHospitalityLocationState createState() => _AddHospitalityLocationState();
}

class _AddHospitalityLocationState extends State<AddHospitalityLocation> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _controller = Completer();
  bool _isLoading = true;

  late GoogleMapController mapController;
  LatLng? _currentPosition;
  String address = '';
  UserLocation? userLocation;
  final Set<Marker> _userMarkers = {};
  final Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(24.7136, 46.6753);

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

  void getLocation() async {
    userLocation = await LocationService().getUserLocation();
    if (userLocation == null) {
      return;
    }
    if (userLocation != null) {
      setState(() {
        if (mounted) {
          _currentPosition =
              LatLng(userLocation!.latitude, userLocation!.longitude);

          widget.hospitalityController.pickUpLocLatLang.value =
              _currentPosition!;
        }
      });
      _fetchAddress();
    } else {
      setState(() {
        if (mounted) {
          _currentPosition =
              LatLng(_currentLocation.latitude, _currentLocation.longitude);
        }
      });
      _fetchAddress();
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        setState(() {
          address =
              '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // addCustomIcon();
    getLocation();
  }

  Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1, position2);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        return '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
      }
    } catch (e) {}
    return '';
  }

  Future<void> _fetchAddress() async {
    double latitude = _currentPosition!.latitude;
    double longitude = _currentPosition!.longitude;
    String fetchedAddress = await _getAddressFromLatLng(latitude, longitude);
    setState(() {
      address = fetchedAddress;
      _isLoading = false;
    });
  }

  final List<String> regionListEn = [
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

  final List<String> regionListAr = [
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: 'locationCheck'.tr,
              color: black,
              fontSize: 17,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        Directionality(
          textDirection: AppUtil.rtlDirection2(context)
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'locationMSG'.tr,
                      color: starGreyColor,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: almostGrey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      height: AppUtil.rtlDirection2(context)
                          ? height * 0.49
                          : height * 0.49,
                      width: double.infinity,
                      child: _currentPosition == null
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : GoogleMap(
                              scrollGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              padding: EdgeInsets.only(bottom: width * 0.102),
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer())
                              },
                              initialCameraPosition: CameraPosition(
                                target: _currentPosition!,
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId("marker1"),
                                  position: _currentPosition!,
                                  draggable: true,
                                  onDragEnd: (LatLng newPosition) {
                                    setState(() {
                                      widget.hospitalityController
                                          .pickUpLocLatLang.value = newPosition;
                                      _currentPosition = newPosition;

                                      _isLoading = true;
                                    });
                                    _fetchAddress();
                                  },
                                  icon: markerIcon,
                                ),
                              },
                              onMapCreated: (controller) {
                                _controller.complete(controller);
                              },
                              onTap: (position) async {
                                mapController = await _controller.future;

                                setState(() {
                                  widget.hospitalityController.pickUpLocLatLang
                                      .value = position;
                                  _currentPosition = position;
                                  _isLoading = true;

                                  mapController.animateCamera(
                                      CameraUpdate.newLatLngZoom(position, 18));
                                });
                                _fetchAddress();
                              },
                              onCameraMove: (position) {
                                setState(() {
                                  _currentLocation = position.target;
                                  widget.hospitalityController.pickUpLocLatLang
                                      .value = position.target;
                                });
                                _fetchAddress();
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
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        border: Border.all(
                          color: const Color(
                              0xFFE2E2E2), // Change this to your desired border color
                          width: 2, // Change this to your desired border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator.adaptive()
                                  : CustomText(
                                      text: address,
                                      color: const Color(0xFF9392A0),
                                      fontSize: 13,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Region".tr,
                      color: black,
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                    ),
                    SizedBox(height: width * 0.02),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: widget.hospitalityController.ragionAr.isEmpty ||
                                widget.hospitalityController.ragionEn.isEmpty
                            ? null
                            : AppUtil.rtlDirection2(context)
                                ? widget.hospitalityController.ragionAr.value
                                : widget.hospitalityController.ragionEn.value,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Graytext)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Graytext)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Graytext),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: MediaQuery(
                          // data: MediaQuery.of(context)
                          //     .copyWith(textScaler: const TextScaler.linear(1.0)),
                          data: MediaQuery.of(context)
                              .copyWith(textScaler: TextScaler.linear(1.0)),
                          child: Text(
                            'regionChoose'.tr,
                            style: TextStyle(
                              color: Graytext,
                              fontSize: 14,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        items: AppUtil.rtlDirection2(context)
                            ? regionListAr
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: CustomText(
                                        text: item,
                                        color: black,
                                        fontSize: 15,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ))
                                .toList()
                            : regionListEn
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: CustomText(
                                        text: item,
                                        color: black,
                                        fontSize: 15,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ))
                                .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select regaion.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (AppUtil.rtlDirection2(context)) {
                            widget.hospitalityController.ragionAr.value =
                                value.toString();

                            int index = regionListAr.indexOf(value.toString());

                            if (index != -1 && index < regionListEn.length) {
                              widget.hospitalityController.ragionEn.value =
                                  regionListEn[index];
                            }
                          } else {
                            widget.hospitalityController.ragionEn.value =
                                value.toString();

                            int index = regionListEn.indexOf(value.toString());

                            if (index != -1 && index < regionListAr.length) {
                              widget.hospitalityController.ragionAr.value =
                                  regionListAr[index];
                            }
                          }
                        },
                        onSaved: (value) {
                          if (AppUtil.rtlDirection2(context)) {
                            widget.hospitalityController.ragionAr.value =
                                value.toString();

                            int index = regionListAr.indexOf(value.toString());

                            if (index != -1 && index < regionListEn.length) {
                              widget.hospitalityController.ragionEn.value =
                                  regionListEn[index];
                            }
                          } else {
                            widget.hospitalityController.ragionEn.value =
                                value.toString();

                            int index = regionListEn.indexOf(value.toString());

                            if (index != -1 && index < regionListAr.length) {
                              widget.hospitalityController.ragionAr.value =
                                  regionListAr[index];
                            }
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: AppUtil.rtlDirection2(context)
                              ? const EdgeInsets.only(left: 9)
                              : const EdgeInsets.only(right: 9),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Graytext,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 100,
                          decoration: const BoxDecoration(),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: WidgetStateProperty.all(8),
                            thumbVisibility: WidgetStateProperty.all(true),
                            thumbColor: WidgetStateProperty.all(starGreyColor),
                            trackColor: WidgetStateProperty.all(lightGreyColor),
                            trackVisibility: WidgetStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhotoGalleryPage extends StatefulWidget {
  PhotoGalleryPage({
    Key? key,
    required this.selectedImages,
  }) : super(key: key);

  List<String> selectedImages;

  @override
  _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final HospitalityController _hospitalityController =
      Get.put(HospitalityController());
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ImagePickerBottomSheet(
          onImagesSelected: (images) {
            setState(() {
              _hospitalityController.selectedImages.addAll(images);
            });
          },
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        if (AppUtil.isImageValidate(pickedImages.length)) {
          setState(() {
            _hospitalityController.selectedImages.addAll(pickedImages);
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
      if (photo != null) {
        if (AppUtil.isImageValidate(await photo.length())) {
          setState(() {
            // _selectedImages =
            //     _selectedImages != null ? [..._selectedImages!, photo] : [photo];
            _hospitalityController.selectedImages.add(photo);
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  Future<void> _showImageOptions(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 44,
          ),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 65,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Move the selected image to the first position to set it as cover image

                        final selectedImagePath = _hospitalityController
                            .selectedImages
                            .removeAt(index);
                        _hospitalityController.selectedImages
                            .insert(0, selectedImagePath);
                      });
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF37B268),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'makeCover'.tr,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hospitalityController.selectedImages.removeAt(index);
                      });
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1.5, color: Color(0xFFDC362E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Delete'.tr,
                        textAlign: TextAlign.center,
                        color: const Color(0xFFDC362E),
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _hospitalityController.selectedImages.isEmpty
            ? Center(
                child: DottedBorder(
                  strokeWidth: 1,
                  color: const Color(0xFFDCDCE0),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: const [5, 5],
                  child: Container(
                      width: 390,
                      // height: 599,
                      height: 561,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _showImagePickerOptions(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFECF9F1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.33),
                                ),
                              ),
                              child: SvgPicture.asset(
                                  'assets/icons/UploadIcon.svg'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomText(
                            text: 'UploadPhotos'.tr,
                            color: const Color(0xFF070708),
                            fontSize: 15,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'uploadLimit'.tr,
                            textAlign: TextAlign.center,
                            color: const Color(0xFFB9B8C1),
                            fontSize: 11,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ],
                      )),
                ),
              )
            : Column(
                children: [
                  Container(
                    child: Container(
                      width: double.infinity,
                      height: 186,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(
                              _hospitalityController.selectedImages[0].path)),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0x3FC7C7C7),
                        //     blurRadius: 15,
                        //     offset: Offset(0, 0),
                        //     spreadRadius: 0,
                        //   ),
                        // ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12,
                                  right: 12,
                                  left: 12), // Add padding here
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: Colors.white
                                      .withOpacity(0.20000000298023224),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: CustomText(
                                  text: 'Coverphoto'.tr,
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 360,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount:
                          (_hospitalityController.selectedImages.length - 1) +
                              3,
                      itemBuilder: (context, index) {
                        if (index <
                            _hospitalityController.selectedImages.length - 1) {
                          return GestureDetector(
                            onTap: () => _showImageOptions(context, index + 1),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(_hospitalityController
                                      .selectedImages[index + 1].path)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        } else if (index ==
                            _hospitalityController.selectedImages.length - 1) {
                          return GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: DottedBorder(
                              strokeWidth: 1,
                              color: const Color(0xFFDCDCE0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              dashPattern: const [5, 5],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Color(0xFFB9B8C1),
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: 'Addmore'.tr,
                                      color: const Color(0xFFB9B8C1),
                                      fontSize: 11,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (index ==
                            _hospitalityController.selectedImages.length) {
                          return GestureDetector(
                            onTap: () => _takePhoto(),
                            child: DottedBorder(
                              strokeWidth: 1,
                              color: const Color(0xFFDCDCE0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              dashPattern: const [5, 5],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_outlined,
                                        size: 32, color: Color(0xFFB9B8C1)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(); // Placeholder for the last item (will not be displayed)
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class ImagePickerBottomSheet extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;

  const ImagePickerBottomSheet({super.key, required this.onImagesSelected});

  @override
  _ImagePickerBottomSheetState createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;
  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        if (AppUtil.isImageValidate(pickedImages.length)) {
          setState(() {
            _selectedImages = pickedImages;
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
      if (photo != null) {
        if (AppUtil.isImageValidate(await photo.length())) {
          setState(() {
            _selectedImages = _selectedImages != null
                ? [..._selectedImages!, photo]
                : [photo];
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _pickImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.8, // Set the height to 80% of the screen height

      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Choosephotos'.tr,
                  color: const Color(0xFF070708),
                  fontSize: 22,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: _takePhoto,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            // fit: FlexFit.loose,
            child: _selectedImages == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _selectedImages!.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(_selectedImages![index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomButton(
              onPressed: () {
                widget.onImagesSelected(_selectedImages ?? []);
                Navigator.of(context).pop();
              },
              title: 'add'.tr,
            ),
          ),
        ],
      ),
    );
  }
}

class AddGuests extends StatefulWidget {
  const AddGuests({
    Key? key,
    required this.hospitalityController,
  }) : super(key: key);

  final HospitalityController hospitalityController;

  @override
  _AddGuestsState createState() => _AddGuestsState();
}

class _AddGuestsState extends State<AddGuests> {
  final TextEditingController _textField1Controller = TextEditingController();
  int? _selectedRadio;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _updateGender(int? newValue) {
    setState(() {
      _selectedRadio = newValue;
      if (_selectedRadio == 1) {
        widget.hospitalityController.selectedGender.value = "FEMALE";
      } else if (_selectedRadio == 2) {
        widget.hospitalityController.selectedGender.value = "MALE";
      } else if (_selectedRadio == 3) {
        widget.hospitalityController.selectedGender.value = "BOTH";
      }
      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppUtil.rtlDirection2(context)
              ? 'عدد الضيوف في اليوم'
              : "Number of Guests ",
          color: black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        SizedBox(
          height: width * 0.02,
        ),
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
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
                    side: const BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    CustomText(
                      text: "guests".tr,
                      fontWeight: FontWeight.w400,
                      color: Graytext,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontSize: 15,
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          if (widget.hospitalityController.seletedSeat.value >
                              0) {
                            setState(() {
                              widget.hospitalityController.seletedSeat.value =
                                  widget.hospitalityController.seletedSeat
                                          .value -
                                      1;
                            });
                          }
                        },
                        child: const Icon(Icons.horizontal_rule_outlined,
                            color: Graytext, size: 24)),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomText(
                      text: widget.hospitalityController.seletedSeat.value
                          .toString(),
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
                            widget.hospitalityController.seletedSeat.value =
                                widget.hospitalityController.seletedSeat.value +
                                    1;
                          });
                        },
                        child:
                            const Icon(Icons.add, color: Graytext, size: 24)),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.047,
              ),
              CustomText(
                text: AppUtil.rtlDirection2(context) ? "يستقبل فقط" : "Accepts",
                color: black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              ),
              SizedBox(
                height: width * 0.025,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 1,
                          groupValue: _selectedRadio,
                          onChanged: _updateGender,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return colorGreen;
                            }
                            return dotGreyColor;
                          }),
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: "female".tr,
                          color: const Color(0xFF41404A),
                          fontSize: 13,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 2,
                          groupValue: _selectedRadio,
                          onChanged: _updateGender,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return colorGreen;
                            }
                            return dotGreyColor;
                          }),
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: 'male'.tr,
                          color: const Color(0xFF41404A),
                          fontSize: 13,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio<int>(
                        value: 3,
                        groupValue: _selectedRadio,
                        onChanged: _updateGender,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return colorGreen;
                          }
                          return dotGreyColor;
                        }),
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: 'both'.tr,
                        color: const Color(0xFF41404A),
                        fontSize: 13,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectDateTime extends StatefulWidget {
  const SelectDateTime({
    Key? key,
    required this.hospitalityController,
  }) : super(key: key);

  final HospitalityController hospitalityController;

  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  // bool? DateErrorMessage;

  @override
  void initState() {
    super.initState();
    // checkDate();
  }

  final TextEditingController _textField1Controller = TextEditingController();
  int? _selectedRadio;

  final _formKey = GlobalKey<FormState>();

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
  final String timeZoneName = 'Asia/Riyadh';
//  late tz.Location location;
  bool? DurationErrorMessage;

  bool? GuestErrorMessage;
  bool? vehicleErrorMessage;
  int selectedChoice = 3;
  final srvicesController = Get.put(HospitalityController());

  late final Hospitality? hospitality;

  late DateTime newTimeToGoInRiyadh;
  void _updateMeal(int? newValue) {
    setState(() {
      _selectedRadio = newValue;
      if (_selectedRadio == 1) {
        widget.hospitalityController.selectedMealEn.value = "BREAKFAST";
        widget.hospitalityController.selectedMealAr.value = "إفطار";
      } else if (_selectedRadio == 3) {
        widget.hospitalityController.selectedMealEn.value = "Dinner";
        widget.hospitalityController.selectedMealAr.value = "عشاء";
      } else if (_selectedRadio == 2) {
        widget.hospitalityController.selectedMealEn.value = "LUNCH";
        widget.hospitalityController.selectedMealAr.value = "غداء";
      }

      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: width * 0.012,
              ),
              CustomText(
                text: 'AvailableDates'.tr,
                color: black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
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
                          color: widget.hospitalityController
                                      .isHospatilityDateSelcted.value &&
                                  widget.hospitalityController.DateErrorMessage
                                      .value
                              // !widget.hospitalityController.DateErrorMessage
                              //     .value
                              ? colorRed
                              : const Color(0xFFB9B8C1)),
                      borderRadius: BorderRadius.circular(8),
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
                              builder: (BuildContext context) {
                                // return HostCalenderDialog(
                                //   type: 'hospitality',
                                //   srvicesController:
                                //       widget.hospitalityController,
                                // );
                                return EventCalenderDialog(
                                  type: 'hospitality',
                                  srvicesController:
                                      widget.hospitalityController,
                                );
                              });
                        },
                        child: CustomText(
                          text: widget.hospitalityController
                                  .isHospatilityDateSelcted.value
                              // ? AppUtil.formatBookingDate(
                              //     context,
                              //     widget
                              //         .hospitalityController.selectedDate.value)
                              ? AppUtil.formatSelectedDates(
                                  widget.hospitalityController.selectedDates,
                                  context)
                              : 'DD/MM/YYYY'.tr,
                          fontWeight: FontWeight.w400,
                          color: Graytext,
                          fontFamily: AppUtil.rtlDirection2(context)
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
                () => widget.hospitalityController.isHospatilityDateSelcted
                            .value &&
                        widget.hospitalityController.DateErrorMessage.value

                    // !widget.hospitalityController.DateErrorMessage.value
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? "يجب اختيار تاريخ بعد اليوم الحالي"
                              : "Please choose a date after today",
                          color: colorRed,
                          fontSize: width * 0.028,
                        ),
                      )
                    : Container(),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? "وقت الاستضافة"
                            : "Start Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection(context)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Obx(
                          () => Container(
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
                                    color: widget.hospitalityController
                                            .newRangeTimeErrorMessage.value
                                        ? colorRed
                                        : DurationErrorMessage ?? false
                                            ? colorRed
                                            : const Color(0xFFB9B8C1)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 0.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      onPressed: () {
                                                        widget
                                                            .hospitalityController
                                                            .isHospatilityTimeSelcted(
                                                                true);
                                                        setState(() {
                                                          Get.back();
                                                          time = newTimeToGo;
                                                          widget
                                                              .hospitalityController
                                                              .selectedStartTime
                                                              .value = newTimeToGo;
                                                          widget
                                                                  .hospitalityController
                                                                  .TimeErrorMessage
                                                                  .value =
                                                              AppUtil.isEndTimeLessThanStartTime(
                                                                  widget
                                                                      .hospitalityController
                                                                      .selectedStartTime
                                                                      .value,
                                                                  newTimeToReturn);
                                                          //newww  SRS
                                                          if (widget
                                                              .hospitalityController
                                                              .isHospatilityDateSelcted
                                                              .value) {
                                                            widget
                                                                    .hospitalityController
                                                                    .newRangeTimeErrorMessage
                                                                    .value =
                                                                AppUtil.areAllDatesTimeBefore(
                                                                    widget
                                                                        .hospitalityController
                                                                        .selectedDates,
                                                                    widget
                                                                        .hospitalityController
                                                                        .selectedStartTime
                                                                        .value);
                                                          }
                                                          //  widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                          //   .format(newTimeToGo) as RxString;
                                                        });
                                                      },
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 5.0,
                                                      ),
                                                      child: CustomText(
                                                        text: "confirm".tr,
                                                        color: colorGreen,
                                                        fontSize: 15,
                                                        fontFamily: AppUtil
                                                                .rtlDirection2(
                                                                    context)
                                                            ? 'SF Arabic'
                                                            : 'SF Pro',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 220,
                                                width: width,
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: Container(
                                                  width: width,
                                                  color: Colors.white,
                                                  child: CupertinoDatePicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    initialDateTime:
                                                        newTimeToGo,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    use24hFormat: false,
                                                    onDateTimeChanged:
                                                        (DateTime newT) {
                                                      setState(() {
                                                        newTimeToGo = newT;
                                                        widget
                                                            .hospitalityController
                                                            .selectedStartTime
                                                            .value = newT;
                                                        widget
                                                                .hospitalityController
                                                                .TimeErrorMessage
                                                                .value =
                                                            AppUtil.isEndTimeLessThanStartTime(
                                                                widget
                                                                    .hospitalityController
                                                                    .selectedStartTime
                                                                    .value,
                                                                newTimeToReturn);
                                                        //newww  SRS
                                                        if (widget
                                                            .hospitalityController
                                                            .isHospatilityDateSelcted
                                                            .value) {
                                                          widget
                                                                  .hospitalityController
                                                                  .newRangeTimeErrorMessage
                                                                  .value =
                                                              AppUtil.areAllDatesTimeBefore(
                                                                  widget
                                                                      .hospitalityController
                                                                      .selectedDates,
                                                                  widget
                                                                      .hospitalityController
                                                                      .selectedStartTime
                                                                      .value);
                                                        }

                                                        //    widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                        // .format(newTimeToGo) as RxString;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: CustomText(
                                    text: !widget.hospitalityController
                                            .isHospatilityTimeSelcted.value
                                        ? AppUtil.rtlDirection2(context)
                                            ? "00:00 مساء"
                                            : "00 :00 PM"
                                        : AppUtil.formatStringTimeWithLocale(
                                            context,
                                            intel.DateFormat('HH:mm:ss').format(
                                                widget.hospitalityController
                                                    .selectedStartTime.value)),
                                    // : intel.DateFormat('hh:mm a').format(
                                    //     widget.hospitalityController
                                    //         .selectedStartTime.value),

                                    fontWeight: FontWeight.w400,
                                    color: Graytext,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //newww  SRS
                      Obx(
                        () => widget.hospitalityController.TimeErrorMessage
                                    .value ||
                                widget.hospitalityController
                                    .newRangeTimeErrorMessage.value
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, top: 1),
                                child: CustomText(
                                  text: widget.hospitalityController
                                          .newRangeTimeErrorMessage.value
                                      ? 'StartTimeDuration'.tr
                                      : '',
                                  // AppUtil.rtlDirection2(context)
                                  //     ? "اختر الوقت"
                                  //     : "Select Time",
                                  color: colorRed,
                                  fontSize: width * 0.028,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text:
                            AppUtil.rtlDirection2(context) ? "إلى" : "End Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection(context)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Obx(
                          () => Container(
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
                                    color: widget.hospitalityController
                                                .TimeErrorMessage.value ??
                                            false
                                        ? colorRed
                                        : DurationErrorMessage ?? false
                                            ? colorRed
                                            : const Color(0xFFB9B8C1)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 0.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      onPressed: () {
                                                        widget
                                                            .hospitalityController
                                                            .isHospatilityTimeSelcted(
                                                                true);
                                                        print(widget
                                                            .hospitalityController
                                                            .isHospatilityTimeSelcted
                                                            .value);
                                                        setState(() {
                                                          Get.back();
                                                          returnTime =
                                                              newTimeToReturn;
                                                          widget
                                                                  .hospitalityController
                                                                  .selectedEndTime
                                                                  .value =
                                                              newTimeToReturn;
                                                          widget
                                                                  .hospitalityController
                                                                  .TimeErrorMessage
                                                                  .value =
                                                              AppUtil.isEndTimeLessThanStartTime(
                                                                  widget
                                                                      .hospitalityController
                                                                      .selectedStartTime
                                                                      .value,
                                                                  widget
                                                                      .hospitalityController
                                                                      .selectedEndTime
                                                                      .value);

                                                          //      widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                          // .format( newTimeToReturn) as RxString;
                                                        });
                                                        log(
                                                          widget
                                                              .hospitalityController
                                                              .selectedStartTime
                                                              .value
                                                              .toString(),
                                                        );
                                                        log(widget
                                                            .hospitalityController
                                                            .selectedEndTime
                                                            .value
                                                            .toString());
                                                      },
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 5.0,
                                                      ),
                                                      child: CustomText(
                                                        text: "confirm".tr,
                                                        color: colorGreen,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 220,
                                                width: width,
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: Container(
                                                  width: width,
                                                  color: Colors.white,
                                                  child: CupertinoDatePicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    initialDateTime:
                                                        newTimeToReturn,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    use24hFormat: false,
                                                    onDateTimeChanged:
                                                        (DateTime newT) {
                                                      print(intel.DateFormat(
                                                              'HH:mm:ss')
                                                          .format(
                                                              newTimeToReturn));
                                                      setState(() {
                                                        newTimeToReturn = newT;
                                                        widget
                                                            .hospitalityController
                                                            .selectedEndTime
                                                            .value = newT;
                                                        widget
                                                                .hospitalityController
                                                                .TimeErrorMessage
                                                                .value =
                                                            AppUtil.isEndTimeLessThanStartTime(
                                                                widget
                                                                    .hospitalityController
                                                                    .selectedStartTime
                                                                    .value,
                                                                widget
                                                                    .hospitalityController
                                                                    .selectedEndTime
                                                                    .value);
                                                        //  widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                        //     .format( newTimeToReturn) as RxString;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: CustomText(
                                    text: !widget.hospitalityController
                                            .isHospatilityTimeSelcted.value
                                        ? AppUtil.rtlDirection2(context)
                                            ? "00:00 مساء"
                                            : "00 :00 PM"
                                        : AppUtil.formatStringTimeWithLocale(
                                            context,
                                            intel.DateFormat('HH:mm:ss').format(
                                                widget.hospitalityController
                                                    .selectedEndTime.value)),
                                    // : intel.DateFormat('hh:mm a').format(
                                    //     widget.hospitalityController
                                    //         .selectedEndTime.value),
                                    fontWeight: FontWeight.w400,
                                    color: Graytext,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () =>
                            //new srs
                            widget.hospitalityController.TimeErrorMessage
                                        .value ||
                                    widget.hospitalityController
                                        .newRangeTimeErrorMessage.value
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: CustomText(
                                      text: AppUtil.rtlDirection2(context)
                                          ? widget.hospitalityController
                                                  .TimeErrorMessage.value
                                              ? "يجب أن لايسبق وقت بدء التجربة"
                                              : ''
                                          : widget.hospitalityController
                                                  .TimeErrorMessage.value
                                              ? "Can’t be before start time"
                                              : '',
                                      color: colorRed,
                                      fontSize: width * 0.028,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                  )
                                : Container(),
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
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              ),
              SizedBox(
                height: width * 0.025,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedRadio,
                        onChanged: _updateMeal,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return colorGreen;
                          }
                          return dotGreyColor;
                        }),
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: 'Breakfast'.tr,
                        color: const Color(0xFF41404A),
                        fontSize: 13,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio<int>(
                        value: 2,
                        groupValue: _selectedRadio,
                        onChanged: _updateMeal,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return colorGreen;
                          }
                          return dotGreyColor;
                        }),
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: 'Lunch'.tr,
                        color: const Color(0xFF41404A),
                        fontSize: 13,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio<int>(
                        value: 3,
                        groupValue: _selectedRadio,
                        onChanged: _updateMeal,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return colorGreen;
                          }
                          return dotGreyColor;
                        }),
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: 'Dinner'.tr,
                        color: const Color(0xFF41404A),
                        fontSize: 13,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PriceDecisionCard extends StatefulWidget {
  const PriceDecisionCard({
    Key? key,
    required this.priceController,
  }) : super(key: key);

  final TextEditingController priceController;

  @override
  _PriceDecisionCardState createState() => _PriceDecisionCardState();
}

class _PriceDecisionCardState extends State<PriceDecisionCard> {
  int price = 0;

  void _setPrice(int newPrice) {
    setState(() {
      price = newPrice;
    });
  }

  bool isEditing = false;
  // final TextEditingController _priceController = TextEditingController();
  double hidoFee = 0.00;
  double earn = 0.00;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.priceController.text = price.toString();

    // widget.priceController.text = '0.00';
    widget.priceController.addListener(_validatePrice);
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_validatePrice);
    super.dispose();
  }

  void _validatePrice() {
    if (!mounted) return; // Check if the widget is still mounted
    String priceText = widget.priceController.text;
    RegExp doubleRegex =
        RegExp(r'^[0-9]*\.[0-9]+$'); // Regular expression to match doubles

    if (doubleRegex.hasMatch(priceText)) {
      setState(() {
        errorMessage = AppUtil.rtlDirection2(context)
            ? '*السعر يجب أن يكون عدد صحيح فقط'
            : '*The price must be an integer value only';
      });
    } else {
      int price = int.tryParse(priceText) ?? 0;
      if (price < 150) {
        setState(() {
          errorMessage = AppUtil.rtlDirection2(context)
              ? '*الحد الأدنى لسعر التجربة هو 150 ريال سعودي'
              : '*The minimum price for an experience is 150 SAR';
        });
      } else {
        setState(() {
          errorMessage = '';
        });
      }
    }
    _updateFees();
  }

  void _updateFees() {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      int price = int.tryParse(widget.priceController.text) ?? 0;
      hidoFee = price * 0.25;
      earn = price - hidoFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'setPrice'.tr,
          color: black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        const SizedBox(height: 2),
        CustomText(
          text: 'changePrice'.tr,
          color: starGreyColor,
          fontSize: 15,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 121,
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorMessage.isNotEmpty ? Colors.red : Colors.white,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3FC7C7C7),
                blurRadius: 15,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/editPin.svg'),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 1),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isEditing)
                      Expanded(
                        child: TextField(
                          controller: widget.priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.all(0), // Optional: Remove padding
                          ),
                          style: const TextStyle(
                            color: Color(0xFF070708),
                            fontSize: 34,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                          onSubmitted: (newValue) {
                            _updateFees();

                            setState(() {
                              isEditing = false;
                            });
                          },
                        ),
                      )
                    else
                      CustomText(
                        text: widget.priceController.text,
                        color: const Color(0xFF070708),
                        fontSize: 34,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: 'sar'.tr,
                      color: const Color(0xFF070708),
                      fontSize: 34,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                        text: 'Perperson'.tr,
                        color: Graytext,
                        fontSize: 12,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 3),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (errorMessage.isNotEmpty && price != 150.0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomText(
              text: errorMessage,
              color: Colors.red,
              fontSize: 14,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 50),
        Container(
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFDCDCE0)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Baseprice'.tr,
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: ' ${widget.priceController.text} ${'sar'.tr}',
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Hidofee'.tr,
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: ' ${hidoFee.toStringAsFixed(2)} ${'sar'.tr}',
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              const Divider(
                color: lightGrey,
                thickness: 1,
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Yourearn'.tr,
                      color: const Color(0xFF070708),
                      fontSize: 17,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: ' ${earn.toStringAsFixed(2)} ${'sar'.tr}',
                      textAlign: TextAlign.right,
                      color: const Color(0xFF36B268),
                      fontSize: 17,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  final intel.DateFormat dayFormatter =
      intel.DateFormat('d', isArabic ? 'ar' : 'en');
  final intel.DateFormat monthYearFormatter =
      intel.DateFormat('MMMM yyyy', isArabic ? 'ar' : 'en');

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
