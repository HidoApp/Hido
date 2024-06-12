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
import '../../../../../widgets/custom_app_bar.dart';

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
  final int totalIndex = 4;
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        "General Information",
        isAjwadi: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // Your main content here
                  child: nextStep(),
                ),
                Column(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [previousButton(), nextButton()],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //   return Column(
  //     children: [

  //       DotStepper(
  //         dotCount: 6,
  //         dotRadius: 30.0,
  //         activeStep: widget.activeIndex,
  //         shape: Shape.pipe,
  //         spacing: 5.0,
  //         indicator: Indicator.shift,
  //         onDotTapped: (tappedDotIndex) {
  //           setState(() {
  //             widget.activeIndex = tappedDotIndex;
  //           });
  //         },
  //         fixedDotDecoration: FixedDotDecoration(
  //           color: const Color.fromARGB(255, 250, 183, 183),
  //         ),
  //         indicatorDecoration: IndicatorDecoration(
  //           color:  Color(0xFF36B268),
  //         ),
  //         lineConnectorDecoration: LineConnectorDecoration(
  //           color:  Colors.white,
  //           strokeWidth: 0,
  //         ),
  //       ),
  //       // Padding(
  //       //   padding: const EdgeInsets.all(18.0),
  //       //   child: steps(),
  //       // ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [previousButton(), nextButton()],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  /// Generates jump steps for dotCount number of steps, and returns them in a row.
  // Row steps() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: List.generate(totalIndex, (index) {
  //       return ElevatedButton(
  //         child: Text('${index + 1}'),
  //         onPressed: () {
  //           setState(() {
  //             widget.activeIndex = index;
  //           });
  //         },
  //       );
  //     }),
  //   );
  // }
  Widget nextStep() {
    switch (activeIndex) {
      case 0:
        print("0");
        return AddHospitalityInfo();
      case 1:
        print("1");
        return AddHospitalityLocation(); // Replace with your actual widget
      // Add more cases as needed
      default:
        print("2");
        return PhotoGalleryPage(); // Replace with your actual widget
    }
  }

  Widget nextButton() {
    return GestureDetector(
      onTap: () {
        if (activeIndex < totalIndex - 1) {
          setState(() {
            activeIndex++;
          });
        }
      },
      child: Container(
        width: 157,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xFF36B268),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        alignment: Alignment.center,
        child: Text(
          'Next',
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
          'Back',
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
  @override
  _AddHospitalityInfoState createState() => _AddHospitalityInfoState();
}

class _AddHospitalityInfoState extends State<AddHospitalityInfo> {
  final TextEditingController _textField1Controller = TextEditingController();
  final TextEditingController _textField2Controller = TextEditingController();
  int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                          controller: _textField1Controller,
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
                          controller: _textField2Controller,
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
              SizedBox(height: _selectedLanguageIndex == 0 ? 0 : 20),
            ],
          ),
        ),
      ],
    );
  }
}

class AddHospitalityLocation extends StatefulWidget {
  @override
  _AddHospitalityLocationState createState() => _AddHospitalityLocationState();
}

class _AddHospitalityLocationState extends State<AddHospitalityLocation> {
  final TextEditingController _textField1Controller = TextEditingController();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late final GoogleMapController _googleMapController;

  String? _darkMapStyle;

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
                'Is the pin in the right spot ?',
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
                      'Your address is only shared with the guests after confirming the reservation.',
                      style: TextStyle(
                        color: starGreyColor,
                        fontSize: 16,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: _textField1Controller,
                          decoration: InputDecoration(
                            hintText: "Riyadh,Al-Majma'ah, Saudi Arabia",
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
                  ],
                ),
              ),
              SizedBox(height: 3),

              Stack(
                children: [
                  Container(
                    height: height * 0.42,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: lightGrey,
                    ),
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });

                        _loadMapStyles();
                      },
                      initialCameraPosition: CameraPosition(
                        target:
                            _touristExploreController.pickUpLocLatLang.value,
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("marker1"),
                          position:
                              _touristExploreController.pickUpLocLatLang.value,
                          draggable: true,
                          onDragEnd: (value) {
                            // value is the new position
                          },
                          icon: markerIcon,
                        ),
                      },
                      zoomControlsEnabled: false, // Removes zoom controls
                    ),
                  ),
                  // GestureDetector(
                  //     onTap: () {
                  //       Get.to(() => SetLocationScreen(

                  //           ));
                  //     },
                  //     child: Container(
                  //       height: 100,
                  //       width: 320,
                  //       color: Colors.transparent,
                  //     ))
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
  @override
  _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  List<XFile> _selectedImages = [];

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
          _selectedImages?.addAll(pickedImages);
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
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
                      height: 530,
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
                            text: 'Upload Photos',
                            color: Color(0xFF070708),
                            fontSize: 15,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'upload at least 3 photo ',
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
                                  'Cover photo',
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
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                    File(_selectedImages![index + 1].path)),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
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
                                    Icon(Icons.add,
                                        size: 24,  color: Color(0xFFB9B8C1),),
                                    SizedBox(height: 4),
                                    Text(
                                      'Add more',
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
                                        size: 32,  color: Color(0xFFB9B8C1)),
                                   
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
                Text('Choose photos',
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 22,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    )),
                IconButton(
                  icon: Icon(Icons.camera_alt),
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
              title: 'Add',
            ),
          ),
        ],
      ),
    );
  }
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
