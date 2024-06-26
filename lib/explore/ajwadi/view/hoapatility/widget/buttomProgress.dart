import 'dart:async';
import 'dart:io';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/set_location.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/request_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/accept_bottom_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_request_item.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart' as intel;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../services/controller/hospitality_controller.dart';
import '../../../../../services/model/hospitality.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/custom_text_with_icon_button.dart';
import '../../../../tourist/model/coordinates.dart';
import '../../calender_dialog.dart';
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
  final List<String> _hospitalityImages = [];
  int seats = 0;
  String gender = '';

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

  final HospitalityController _hospitalityController =
      Get.put(HospitalityController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        "General Information",
        isAjwadi: true,
        isBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  // const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  const EdgeInsets.symmetric(horizontal: 16),

              // Your main content here
              child: nextStep(),
            ),
            // Column(
            //   children: [

            //     DotStepper(
            //       dotCount: 6,
            //       dotRadius: 30.0,
            //       activeStep: activeIndex,
            //       shape: Shape.pipe,
            //       spacing: 5.0,
            //       indicator: Indicator.shift,
            //       onDotTapped: (tappedDotIndex) {
            //         setState(() {
            //           activeIndex = tappedDotIndex;
            //         });
            //       },
            //       fixedDotDecoration: FixedDotDecoration(
            //         color: Color(0xFFDCDCE0),
            //       ),
            //       indicatorDecoration: IndicatorDecoration(
            //         color: Color(0xFF36B268),
            //       ),
            //       lineConnectorDecoration: LineConnectorDecoration(
            //         color: Colors.white,
            //         strokeWidth: 0,
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 16, vertical: 12),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [previousButton(), nextButton()],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DotStepper(
              dotCount: 6,
              dotRadius: 30.0,
              activeStep: activeIndex,
              shape: Shape.pipe,
              spacing: 5.0,
              indicator: Indicator.shift,
              onDotTapped: (tappedDotIndex) {
                setState(() {
                  activeIndex = tappedDotIndex;
                });
              },
              fixedDotDecoration: FixedDotDecoration(
                color: Color(0xFFDCDCE0),
              ),
              indicatorDecoration: IndicatorDecoration(
                color: Color(0xFF36B268),
              ),
              lineConnectorDecoration: LineConnectorDecoration(
                color: Colors.white,
                strokeWidth: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  Widget nextStep() {
    switch (activeIndex) {
      case 0:
        print("0");
        return AddHospitalityInfo(
          textField1ControllerAR: hospitalityTitleControllerAr,
          textField2ControllerAR: hospitalityBioControllerAr,
          textField1ControllerEN: hospitalityTitleControllerEn,
          textField2ControllerEN: hospitalityBioControllerEn,
        );
      case 1:
        print(hospitalityTitleControllerAr.text);
        print(hospitalityTitleControllerEn.text);
        print('1');

        return AddHospitalityLocation(
          textField1Controller: hospitalityLocation,
          hospitalityController: _hospitalityController,
        ); // Replace with your actual widget
      // Add more cases as needed
      case 2:
        print(_hospitalityController.pickUpLocLatLang.value.toString());
        print('2');

        return PhotoGalleryPage(selectedImages: _hospitalityImages);
      case 3:
        print(_hospitalityImages.first);
        print(_hospitalityImages.length);

        print('3');

        return AddGuests(hospitalityController: _hospitalityController);
      case 4:
        print(_hospitalityController.seletedSeat.value);
        print(_hospitalityController.selectedGender.value);
        print("4");
        return SelectDateTime(hospitalityController: _hospitalityController);
      case 5:
        print(_hospitalityController.selectedMeal.value);
        print(_hospitalityController.selectedStartTime.value);
        print( _hospitalityController.isHospatilityTimeSelcted);
        print("5");
        return PriceDecisionCard();

      default:
        print("2");
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
          const LatLng(24.9470921, 45.9903698);
    }
    if (activeIndex == 2) {
      return _hospitalityImages.length >= 3;
    }
    return true; // Add validation for other steps if needed
  }

  Widget nextButton() {
    return IgnorePointer(
      ignoring: !_validateFields(),
      child: Opacity(
        opacity: _validateFields() ? 1.0 : 0.5,
        child: GestureDetector(
          onTap: () {
            if (activeIndex < totalIndex - 1) {
              setState(() {
                activeIndex++;
                print(activeIndex < totalIndex - 1);
                print(totalIndex);
                print(activeIndex);
              });
            } else if (activeIndex == totalIndex - 1) {
              Get.to(HostInfoReview());
            }
          },
          child: Container(
            width: 157,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFF36B268),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            alignment: Alignment.center,
            child: Text(
              'Next'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'HT Rakik',
                fontWeight: FontWeight.w500,
                height: 0.10,
              ),
            ),
          ),
        ),
      ),
    );
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
        child: Text(
          'Back'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF070708),
            fontSize: 17,
            fontFamily: 'HT Rakik',
            fontWeight: FontWeight.w500,
            height: 0.10,
          ),
        ),
      ),
    );
  }
}

class AddHospitalityInfo extends StatefulWidget {
  AddHospitalityInfo({
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                activeBgColors: [
                  [Colors.white],
                  [Colors.white]
                ],
                activeBorders: [
                  Border.all(color: Color(0xFFF5F5F5), width: 2.0),
                  Border.all(color: Color(0xFFF5F5F5), width: 2.0),
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
                    fontSize: _selectedLanguageIndex == 0 ? 11.5 : 13,
                    fontFamily: 'SF Pro',
                    fontWeight: _selectedLanguageIndex == 0
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  TextStyle(
                    fontSize: _selectedLanguageIndex == 0 ? 11.5 : 13,
                    fontFamily: 'SF Pro',
                    fontWeight: _selectedLanguageIndex == 0
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
              //  FlutterSwitch(
              //   width: 106,
              //   height: 40,
              //   borderRadius: 12,

              //       showOnOff: true,
              //       value: isFirstButtonPressed,
              //       activeIcon: Text("SELL"),
              //       toggleSize: 47,
              //       valueFontSize:30.0,

              //       activeText: "BUY",
              //       inactiveIcon: Text("BUY"),
              //       inactiveText: "SELL",
              //       inactiveColor: Colors.blue,
              //       activeTextFontWeight: FontWeight.w800,
              //       inactiveTextFontWeight: FontWeight.normal,
              //       onToggle: (val) {
              //         setState(() {
              //           isFirstButtonPressed = val;
              //         });
              //       },
              //     )
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
                    Text(
                      _selectedLanguageIndex == 0
                          ? 'عنوان التجربة'
                          : 'Experience title',
                      style: TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 17,
                        fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: _selectedLanguageIndex == 0
                            ? FontWeight.w600
                            : FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: _selectedLanguageIndex == 0 ? 5.5 : 8),
                    Container(
                      width: double.infinity,
                      height: 54,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                        child: TextField(
                          controller: textField1Controller,
                          decoration: InputDecoration(
                            hintText: _selectedLanguageIndex == 0
                                ? 'مثال: منزل دانا'
                                : 'example: Dana’s house',
                            hintStyle: TextStyle(
                              color: Color(0xFFB9B8C1),
                              fontSize: 15,
                              fontFamily: 'SF Pro',
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
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLanguageIndex == 0 ? 'الوصف' : 'Description',
                      style: TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 17,
                        fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: _selectedLanguageIndex == 0
                            ? FontWeight.w600
                            : FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: _selectedLanguageIndex == 0 ? 4 : 9),
                    Container(
                      width: double.infinity,
                      height: 133,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: TextField(
                          maxLines: 8,
                          minLines: 1,
                          controller: textField2Controller,
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
                          decoration: InputDecoration(
                            hintText: _selectedLanguageIndex == 0
                                ? 'أذكر أبرز ما يميزها ولماذا يجب على السياح زيارتها'
                                : 'highlight what makes it unique and why tourists should visit',
                            hintStyle: TextStyle(
                              color: Color(0xFFB9B8C1),
                              fontSize: 15,
                              fontFamily: 'SF Pro',
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
                      child: Text(
                        _selectedLanguageIndex == 0
                            ? '*يجب ألا يتجاوز الوصف 150 كلمة'
                            : '*the description must not exceed 150 words',
                        style: TextStyle(
                          color: Color(0xFFB9B8C1),
                          fontSize: 11,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(height: 20),
              // SizedBox(height: _selectedLanguageIndex == 0 ? 0 : 20),
            ],
          ),
        ),
      ],
    );
  }
}

class AddHospitalityLocation extends StatefulWidget {
  AddHospitalityLocation({
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

  late GoogleMapController mapController;

  String? _darkMapStyle;
  FocusNode _focusNode = FocusNode();

  Future<void> _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style.json');
    final controller = await _controller.future;
    await controller.setMapStyle(_darkMapStyle);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (widget.userLocation != null) {
    //   _touristExploreController.pickUpLocLatLang(LatLng(
    //     widget.userLocation!.latitude,
    //     widget.userLocation!.longitude,
    //   ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'locationCheck'.tr,
                style: TextStyle(
                  color: black,
                  fontSize: 17,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
        Directionality(
          textDirection: AppUtil.rtlDirection2(context)
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
                    Text(
                      'locationMSG'.tr,
                      style: TextStyle(
                        color: starGreyColor,
                        fontSize: 16,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 25),
                    RawKeyboardListener(
                      focusNode: _focusNode,
                      onKey: (RawKeyEvent event) {
                        if (event.runtimeType == RawKeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter) {
                          // Move the marker to the new location
                          String coordinates = widget.textField1Controller.text;
                          List<String> parts = coordinates.split(',');
                          if (parts.length == 2) {
                            double lat =
                                double.tryParse(parts[0].trim()) ?? 0.0;
                            double lng =
                                double.tryParse(parts[1].trim()) ?? 0.0;
                            LatLng newPosition = LatLng(lat, lng);

                            setState(() {
                              widget.hospitalityController.pickUpLocLatLang
                                  .value = newPosition;
                              mapController.animateCamera(
                                  CameraUpdate.newLatLng(newPosition));
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: widget.textField1Controller,
                            decoration: InputDecoration(
                              hintText: "hintLocation".tr,
                              hintStyle: TextStyle(
                                color: Color(0xFFB9B8C1),
                                fontSize: 15,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, bottom: 14),
                                child: SvgPicture.asset(
                                  'assets/icons/map_pin.svg',
                                  color: Color(0xFFB9B8C1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),

              Stack(
                children: [
                  Container(
                    height: height * 0.555,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: lightGrey,
                    ),
                    child: Obx(
                      () => GoogleMap(
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });

                          _loadMapStyles();
                        },
                        initialCameraPosition: CameraPosition(
                          target: widget
                              .hospitalityController.pickUpLocLatLang.value,
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("marker1"),
                            position: widget
                                .hospitalityController.pickUpLocLatLang.value,
                            draggable: true,
                            onDragEnd: (LatLng newPosition) {
                              setState(() {
                                widget.hospitalityController.pickUpLocLatLang
                                    .value = newPosition;
                              });
                            },
                            icon: markerIcon,
                          ),
                        },
                        zoomControlsEnabled: false, // Removes zoom controls
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        print('location');
                        print(
                            'New Marker Position: ${widget.hospitalityController.pickUpLocLatLang.value}');
                      },
                      child: Container(
                        height: 100,
                        width: 320,
                        color: Colors.black,
                      ))
                ],
              ),
              // SizedBox(height: 20),
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
  List<XFile> _selectedImages = [];

  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages.map((path) => XFile(path)).toList();
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ImagePickerBottomSheet(
          onImagesSelected: (images) {
            setState(() {
              _selectedImages = images;
              widget.selectedImages.addAll(images.map((file) => file.path));
            });
          },
        );
      },
    );
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final image = await picker.pickImage(source: source);
  //   if (image != null) {
  //     setState(() {
  //       _selectedImages!.add(image);

  //     });
  //   }
  // }
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          _selectedImages.addAll(pickedImages);
          widget.selectedImages.addAll(pickedImages.map((file) => file.path));
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _showImageOptions(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          width: 390,
          height: 184,
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 44,
          ),
          decoration: ShapeDecoration(
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
                        final selectedImage = _selectedImages.removeAt(index);
                        _selectedImages.insert(0, selectedImage);

                        final selectedImagePath =
                            widget.selectedImages.removeAt(index);
                        widget.selectedImages.insert(0, selectedImagePath);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: Color(0xFF37B268),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'makeCover'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages.removeAt(index);
                        widget.selectedImages.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.5, color: Color(0xFFDC362E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Delete'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFDC362E),
                          fontSize: 17,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w500,
                        ),
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
        _selectedImages.isEmpty
            ? Center(
                child: DottedBorder(
                  strokeWidth: 1,
                  color: Color(0xFFDCDCE0),
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  dashPattern: [5, 5],
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
                                color: Color(0xFFECF9F1),
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
                            color: Color(0xFF070708),
                            fontSize: 15,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'uploadLimit'.tr,
                            textAlign: TextAlign.center,
                            color: Color(0xFFB9B8C1),
                            fontSize: 11,
                            fontFamily: 'SF Pro',
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
                          image: FileImage(File(_selectedImages![0].path)),
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
                                child: Text(
                                  'Coverphoto'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 360,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: (_selectedImages!.length - 1) + 3,
                      itemBuilder: (context, index) {
                        if (index < _selectedImages!.length - 1) {
                          return GestureDetector(
                            onTap: () => _showImageOptions(context, index + 1),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                      File(_selectedImages![index + 1].path)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        } else if (index == _selectedImages!.length - 1) {
                          return GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: DottedBorder(
                              strokeWidth: 1,
                              color: Color(0xFFDCDCE0),
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              dashPattern: [5, 5],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Color(0xFFB9B8C1),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Addmore'.tr,
                                      style: TextStyle(
                                        color: Color(0xFFB9B8C1),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (index == _selectedImages!.length) {
                          return GestureDetector(
                            onTap: () => _pickImage(ImageSource.camera),
                            child: DottedBorder(
                              strokeWidth: 1,
                              color: Color(0xFFDCDCE0),
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              dashPattern: [5, 5],
                              child: Center(
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

  ImagePickerBottomSheet({required this.onImagesSelected});

  @override
  _ImagePickerBottomSheetState createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          _selectedImages = pickedImages;
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _selectedImages =
              _selectedImages != null ? [..._selectedImages!, photo] : [photo];
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
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
      decoration: BoxDecoration(
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
                Text('Choosephotos'.tr,
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 22,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    )),
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: _takePhoto,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            // fit: FlexFit.loose,
            child: _selectedImages == null
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
  AddGuests({
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
        widget.hospitalityController.selectedGender.value = "female";
      } else if (_selectedRadio == 2) {
        widget.hospitalityController.selectedGender.value = "male";
      } else if (_selectedRadio == 3) {
        widget.hospitalityController.selectedGender.value = "both";
      }
      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "guests2".tr,
          color: black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro',
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
                    side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    CustomText(
                      text: "guests".tr,
                      fontWeight: FontWeight.w400,
                      color: Graytext,
                      fontFamily: 'SF Pro',
                      fontSize: 15,
                    ),
                    Spacer(),
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
                text: "Accepts".tr,
                color: black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro',
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
                              VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return colorGreen;
                            }
                            return dotGreyColor;
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "female".tr,
                          style: TextStyle(
                            color: Color(0xFF41404A),
                            fontSize: 13,
                            fontFamily: 'SF Pro',
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
                              VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return colorGreen;
                            }
                            return dotGreyColor;
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'male'.tr,
                          style: TextStyle(
                            color: Color(0xFF41404A),
                            fontSize: 13,
                            fontFamily: 'SF Pro',
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 3,
                          groupValue: _selectedRadio,
                          onChanged: _updateGender,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return colorGreen;
                            }
                            return dotGreyColor;
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'both'.tr,
                          style: TextStyle(
                            color: Color(0xFF41404A),
                            fontSize: 13,
                            fontFamily: 'SF Pro',
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
        ),
      ],
    );
  }
}

class SelectDateTime extends StatefulWidget {

SelectDateTime({
    Key? key,
    required this.hospitalityController,
  }) : super(key: key);

  final HospitalityController hospitalityController;
  



  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  final TextEditingController _textField1Controller = TextEditingController();
  int? _selectedRadio;

  final _formKey = GlobalKey<FormState>();

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
  final String timeZoneName = 'Asia/Riyadh';
//  late tz.Location location;
  bool? DateErrorMessage;
  bool? TimeErrorMessage;
  bool? DurationErrorMessage;

  bool? GuestErrorMessage;
  bool? vehicleErrorMessage;
  int selectedChoice = 3;
  final srvicesController = Get.put(HospitalityController());

// late final HospitalityController serviceController;
  late final Hospitality? hospitality;

  //var locLatLang = const LatLng(24.9470921, 45.9903698);
  late DateTime newTimeToGoInRiyadh;
void _updateMeal(int? newValue) {
    setState(() {
      _selectedRadio = newValue;
      if (_selectedRadio == 1) {
        widget.hospitalityController.selectedMeal.value = "Breakfast";
      } else if (_selectedRadio == 2) {
        widget.hospitalityController.selectedMeal.value = "Dinner";
      } else if (_selectedRadio == 3) {
        widget.hospitalityController.selectedMeal.value = "Lunch";
      }
      // widget.onGenderChanged(gender!);  // Call the callback with the new gender value
    });
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                fontFamily: 'SF Pro',
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
                          color: DateErrorMessage ?? false
                              ? Colors.red
                              : Color(0xFFB9B8C1)),
                      borderRadius: BorderRadius.circular(8),
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
                              builder: (BuildContext context) {
                                return CalenderDialog(
                                  fromAjwady: true,
                                  type: 'hospitality',
                                  srvicesController: widget.hospitalityController,
                                );
                              });
                        },
                        child: CustomText(
                          text: widget.hospitalityController.isHospatilityDateSelcted.value
                              ? formatSelectedDates(
                                  srvicesController.selectedDates)
                              // srvicesController.selectedDates.map((date) => intel.DateFormat('dd/MM/yyyy').format(date)).join(', ')
                              : 'DD/MM/YYYY'.tr,
                          fontWeight: FontWeight.w400,
                          color: Graytext,
                          fontFamily: 'SF Pro',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (DateErrorMessage ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    AppUtil.rtlDirection2(context)
                        ? "اختر التاريخ"
                        : "Select Date",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
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
                            ? "وقت الذهاب"
                            : "Start Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection(context)
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
                                  color: TimeErrorMessage ?? false
                                      ? Colors.red
                                      : DurationErrorMessage ?? false
                                          ? Colors.red
                                          : Color(0xFFB9B8C1)),
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
                                              decoration: BoxDecoration(
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
                                                     widget.hospitalityController
                                                          .isHospatilityTimeSelcted(
                                                              true);
                                                      setState(() {
                                                        Get.back();
                                                        time = newTimeToGo;
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
                                                      fontFamily: 'SF Pro',
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
                                                  backgroundColor: Colors.white,
                                                  initialDateTime: newTimeToGo,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  use24hFormat: false,
                                                  onDateTimeChanged:
                                                      (DateTime newT) {
                                                    setState(() {
                                                      newTimeToGo = newT;
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
                                  text:! widget.hospitalityController.isHospatilityTimeSelcted.value
                                  ? "00 :00 PM"
                                  :intel.DateFormat('hh:mm a')
                                      .format(newTimeToGo),
                                  fontWeight: FontWeight.w400,
                                  color: Graytext,
                                  fontFamily: 'SF Pro',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (TimeErrorMessage ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            AppUtil.rtlDirection2(context)
                                ? "اختر الوقت"
                                : "Select Time",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
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
                        text: AppUtil.rtlDirection2(context)
                            ? "وقت العودة"
                            : "End Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection(context)
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
                                  color: TimeErrorMessage ?? false
                                      ? Colors.red
                                      : DurationErrorMessage ?? false
                                          ? Colors.red
                                          : Color(0xFFB9B8C1)),
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
                                              decoration: BoxDecoration(
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
                                                      widget.hospitalityController.isHospatilityTimeSelcted(true);
                                                      print( widget.hospitalityController.isHospatilityTimeSelcted.value);
                                                      setState(() {
                                                        Get.back();
                                                        returnTime =
                                                            newTimeToReturn;
                                                    //      widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                    // .format( newTimeToReturn) as RxString;
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
                                                  backgroundColor: Colors.white,
                                                  initialDateTime:
                                                      newTimeToReturn,
                                                  mode: CupertinoDatePickerMode
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
                                  text: !widget.hospitalityController.isHospatilityTimeSelcted.value
                                  ? "00 :00 PM"
                                 : intel.DateFormat('hh:mm a')
                                          .format(newTimeToReturn),
                                  fontWeight: FontWeight.w400,
                                  color: Graytext,
                                  fontFamily: 'SF Pro',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (TimeErrorMessage ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            AppUtil.rtlDirection2(context)
                                ? "اختر الوقت"
                                : "Select Time",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
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
                fontFamily: 'SF Pro',
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
                          onChanged: _updateMeal,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
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
                            fontFamily: 'SF Pro',
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 2,
                          groupValue: _selectedRadio,
                          onChanged: _updateMeal,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
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
                            fontFamily: 'SF Pro',
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 3,
                          groupValue: _selectedRadio,
                          onChanged:_updateMeal,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
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
                            fontFamily: 'SF Pro',
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
        ),
      ],
    );
  }
}

class PriceDecisionCard extends StatefulWidget {
  @override
  _PriceDecisionCardState createState() => _PriceDecisionCardState();
}

class _PriceDecisionCardState extends State<PriceDecisionCard> {
  double price = 0.0;

  void _setPrice(double newPrice) {
    setState(() {
      price = newPrice;
    });
  }

  bool isEditing = false;
  final TextEditingController _priceController = TextEditingController();
  double hidoFee = 0.00;
  double earn = 0.00;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _priceController.text = '0.00';
    _priceController.addListener(_validatePrice);
  }

  void _validatePrice() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    if (price < 150) {
      setState(() {
        errorMessage = 'Price cannot be less than 150';
        //    price= 150.0;
        // _priceController.text = price.toStringAsFixed(2);
      });
    } else {
      setState(() {
        errorMessage = '';
      });
    }
    _updateFees();
  }

  void _updateFees() {
    setState(() {
      double price = double.tryParse(_priceController.text) ?? 0.00;

      hidoFee = price * 0.25;
      earn = price - hidoFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double hidoFee = price * 0.25;
    // double earn = price - hidoFee;

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
          fontFamily: 'SF Pro',
        ),
        const SizedBox(height: 2),
        Text(
          'changePrice'.tr,
          style: TextStyle(
            color: starGreyColor,
            fontSize: 15,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
          ),
        ),
        // width: 390,
        // height: 436,
        // padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 121,
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 20),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3FC7C7C7),
                blurRadius: 15,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
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
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isEditing)
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.all(0), // Optional: Remove padding
                          ),
                          style: TextStyle(
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
                      Text(
                        _priceController.text,
                        style: TextStyle(
                          color: Color(0xFF070708),
                          fontSize: 34,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      'sar'.tr,
                      style: TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 34,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Perperson'.tr,
                      style: TextStyle(
                          color: Graytext,
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 3),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (errorMessage.isNotEmpty && price != 150.0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
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
              side: BorderSide(width: 1, color: Color(0xFFDCDCE0)),
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
                    Text(
                      'Baseprice'.tr,
                      style: TextStyle(
                        color: graySmallText,
                        fontSize: 15,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ' ${_priceController.text} ${'sar'.tr}',
                      style: TextStyle(
                        color: graySmallText,
                        fontSize: 15,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hidofee'.tr,
                      style: TextStyle(
                        color: graySmallText,
                        fontSize: 15,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ' ${hidoFee.toStringAsFixed(2)} ${'sar'.tr}',
                      style: TextStyle(
                        color: graySmallText,
                        fontSize: 15,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
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
                height: 8,
              ),
              Container(
                width: double.infinity,
                //clipBehavior: Clip.antiAlias,
                // decoration: ShapeDecoration(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(4)),
                //   shadows: [
                //     BoxShadow(
                //       color: shadowColor,
                //       blurRadius: 20,
                //       offset: Offset(4, 4),
                //       spreadRadius: 0,
                //     )
                //   ],
                // ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Yourearn'.tr,
                      style: TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ' ${earn.toStringAsFixed(2)} ${'sar'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF36B268),
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
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

String formatSelectedDates(RxList<dynamic> dates) {
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

  final intel.DateFormat dayFormatter = intel.DateFormat('d');
  final intel.DateFormat monthYearFormatter = intel.DateFormat('MMMM yyyy');

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
//     return Column(
//       children: [
//         DotStepper(
//           activeStep: widget.activeIndex,
//           dotRadius: 30.0,
//           shape: Shape.pipe,
//           spacing: 6.0,
//           dotCount: 6,
//           indicator: Indicator.slide, // You can customize the indicator
//           fixedDotDecoration: FixedDotDecoration(
//             color: Colors.blue,
//             strokeWidth: 0,
//           ),
//           indicatorDecoration: IndicatorDecoration(
//             color: Colors.green,
//             strokeWidth: 0,
//           ),
//         ),

//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
// width: 157,
// height: 48,
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// clipBehavior: Clip.antiAlias,
// decoration: ShapeDecoration(
// color: Colors.white,
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// ),
//                 // onPressed: () {
//                 //   setState(() {
//                 //     if (widget.activeIndex < totalIndex - 1) {
//                 //       widget.activeIndex++;
//                 //       isFirstButtonPressed = !isFirstButtonPressed;
//                 //     }
//                 //   });
//                 // },
//                 child: Text('Back'),
//               ),
//               // SizedBox(width: 10),
//              Container(
//            width: 157,
//           height: 48,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//            clipBehavior: Clip.antiAlias,
//            decoration: ShapeDecoration(
//           color: Color(0xFF36B268),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//              ),
//                 // onPressed: () {
//                 //   Get.back();
//                 //   setState(() {
//                 //     isSecondButtonPressed = !isSecondButtonPressed;
//                 //   });
//                 // },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ),
//         // nextStep(),
//       ],
//       //),
//     );
//   }

//   Widget nextStep() {
//     switch (widget.activeIndex) {
//       case 0:
//         print("0");
//         return AddHospatilityInfo();
//       case 1:
//         print("1");
//         return RequestScreen(); // Replace with your actual widget
//       // Add more cases as needed
//       default:
//         print("2");
//         return RequestScreen(); // Replace with your actual widget
//     }
//   }
// }
