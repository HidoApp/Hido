import 'dart:async';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/local/model/userLocation.dart';
import 'package:ajwad_v4/explore/local/services/location_service.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({
    Key? key,
    required this.textField1Controller,
  }) : super(key: key);

  final TextEditingController textField1Controller;

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final AdventureController _AdventureController =
      Get.put(AdventureController());

  final Completer<GoogleMapController> _controller = Completer();
  bool _isLoading = true;

  late GoogleMapController mapController;
  LatLng? _currentPosition;
  String address = '';
  UserLocation? userLocation;
  final Set<Marker> _userMarkers = {};
  final Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(24.7136, 46.6753);

  final List<String> genderItems = [
    'Male',
    'Female',
  ];
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

    if (userLocation != null) {
      setState(() {
        if (mounted) {
          _currentPosition =
              LatLng(userLocation!.latitude, userLocation!.longitude);

          _AdventureController.pickUpLocLatLang.value = _currentPosition!;
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
    //
    //
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: 'locationCheckAdve'.tr,
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
              const SizedBox(height: 20),
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
                          ? height * 0.51
                          : height * 0.51,
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
                                      _AdventureController
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
                                  _AdventureController.pickUpLocLatLang.value =
                                      position;
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
                                  _AdventureController.pickUpLocLatLang.value =
                                      position.target;
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
                    MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(1.0)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          value: _AdventureController.ragionAr.isEmpty ||
                                  _AdventureController.ragionEn.isEmpty
                              ? null
                              : AppUtil.rtlDirection2(context)
                                  ? _AdventureController.ragionAr.value
                                  : _AdventureController.ragionEn.value,
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
                              return 'Please select region.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (AppUtil.rtlDirection2(context)) {
                              _AdventureController.ragionAr.value =
                                  value.toString();

                              int index =
                                  regionListAr.indexOf(value.toString());

                              if (index != -1 && index < regionListEn.length) {
                                _AdventureController.ragionEn.value =
                                    regionListEn[index];
                              }
                            } else {
                              _AdventureController.ragionEn.value =
                                  value.toString();

                              int index =
                                  regionListEn.indexOf(value.toString());

                              if (index != -1 && index < regionListAr.length) {
                                _AdventureController.ragionAr.value =
                                    regionListAr[index];
                              }
                            }
                          },
                          onSaved: (value) {
                            if (AppUtil.rtlDirection2(context)) {
                              _AdventureController.ragionAr.value =
                                  value.toString();

                              int index =
                                  regionListAr.indexOf(value.toString());

                              if (index != -1 && index < regionListEn.length) {
                                _AdventureController.ragionEn.value =
                                    regionListEn[index];
                              }
                            } else {
                              _AdventureController.ragionEn.value =
                                  value.toString();

                              int index =
                                  regionListEn.indexOf(value.toString());

                              if (index != -1 && index < regionListAr.length) {
                                _AdventureController.ragionAr.value =
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
                              thumbColor:
                                  WidgetStateProperty.all(starGreyColor),
                              trackColor:
                                  WidgetStateProperty.all(lightGreyColor),
                              trackVisibility: WidgetStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
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
