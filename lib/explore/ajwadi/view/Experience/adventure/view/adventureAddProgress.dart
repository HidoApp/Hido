import 'dart:async';
import 'dart:io';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/widget/add_adventure_info.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/widget/add_guests.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/widget/add_location.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/widget/add_price.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/widget/photo_gallery.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/widget/select_date_time.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_hospitality_calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/view/host_info_review.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
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
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart' as intel;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AdventureAddProgress extends StatefulWidget {

  const AdventureAddProgress({
    super.key,
  });

  @override
  _AdventureAddProgressState createState() => _AdventureAddProgressState();
}

class _AdventureAddProgressState extends State<AdventureAddProgress> {
  bool isFirstButtonPressed = false;
  bool isSecondButtonPressed = false;
  final int totalIndex = 6;
  int activeIndex = 0;

  final TextEditingController AdventureTitleControllerEn =
      TextEditingController();
  final TextEditingController AdventureBioControllerEn =
      TextEditingController();

  final TextEditingController AdventureTitleControllerAr =
      TextEditingController();
  final TextEditingController AdventureBioControllerAr =
      TextEditingController();

  final TextEditingController AdventureLocation = TextEditingController();
  final TextEditingController AdventurePrice = TextEditingController();

  final List<String> _AdventureImages = [];
  int seats = 0;
  String gender = '';
  final AdventureController _AdventureControllerController =
      Get.put(AdventureController());
  final AjwadiExploreController ajwadiExploreController= Get.put(AjwadiExploreController());

  

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),

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
              
              selectedColor: Color(0xFF36B268),
              unselectedColor: Color(0xFFDCDCE0),
              
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
    );
  }

 Widget nextStep() {
    switch (activeIndex) {
      case 0:
        print("0");
        return AddInfo(
          textField1ControllerAR: AdventureTitleControllerAr,
          textField2ControllerAR: AdventureBioControllerAr,
          textField1ControllerEN: AdventureTitleControllerEn,
          textField2ControllerEN: AdventureBioControllerEn,
        );
      case 1:
        print(AdventureTitleControllerAr.text);
        print(AdventureTitleControllerEn.text);
        print('1');

        return AddLocation(
          textField1Controller: AdventureLocation,
        );
      case 2:
        print(_AdventureControllerController.pickUpLocLatLang.value.toString());
        print('2');

        return PhotoGalleryPage(selectedImages: _AdventureImages);
      case 3:
        print('3');
        return 
           AddGuests(adventureController:_AdventureControllerController);
      case 4:
        print(_AdventureControllerController.seletedSeat.value);
        print("4");

        return SelectDateTime(adventureController: _AdventureControllerController,ajwadiExploreController:ajwadiExploreController ,);
      case 5:
      
        print(_AdventureControllerController.selectedEndTime.value);

        print(
         'Selected Start Time: ${_AdventureControllerController.selectedDates.value}');

        print("5");
        return PriceDecisionCard(priceController: AdventurePrice);

      default:
        print("2");
        return PhotoGalleryPage(
            selectedImages:
              _AdventureImages); // Replace with your actual widget
    }
  }

  bool _validateFields() {
    if (activeIndex == 0) {
      return
      AdventureTitleControllerEn.text.isNotEmpty &&
           AdventureBioControllerEn.text.isNotEmpty &&
          AdventureTitleControllerAr.text.isNotEmpty &&
          AdventureBioControllerAr.text.isNotEmpty;
    }
    if (activeIndex == 1) {
      return
     _AdventureControllerController.pickUpLocLatLang.value !=
          const LatLng(0.0, 0.0)&&  _AdventureControllerController.ragionAr.isNotEmpty && _AdventureControllerController.ragionEn.isNotEmpty;;
    
    }
    if (activeIndex == 2) {
      return
    _AdventureControllerController.selectedImages.length >= 3;
    }
    
     if (activeIndex == 3) {
      return  _AdventureControllerController.seletedSeat.value != 0 ;
    }
     if (activeIndex == 4) {
      
     // return  _AdventureControllerController.selectedDates.value.isNotEmpty && _AdventureControllerController.isAdventureTimeSelcted.value ;

     return !ajwadiExploreController.isDateEmpty.value && _AdventureControllerController.isAdventureTimeSelcted.value &&
      !_AdventureControllerController.TimeErrorMessage.value && _AdventureControllerController.DateErrorMessage.value;
    }

     if (activeIndex == 5) {
    if (AdventurePrice.text.isNotEmpty) {
      int? price = int.tryParse(AdventurePrice.text);
      if (price != null && price >= 150) {
        return true;
      }
    }
    return false;
  }
    
    return true; 
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
      return AppUtil.rtlDirection2(context)?'عدد الأشخاص':'Pepole Number';
    }
    if (activeIndex == 4) {
      return "Date&Time".tr;
    }
    if (activeIndex == 5) {
      return "Price".tr;
    }
    return ""; 
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
                Get.to(HostInfoReview(
                  hospitalityTitleEn: AdventureTitleControllerEn.text,
                  hospitalityBioEn: AdventureBioControllerEn.text,
                  hospitalityTitleAr: AdventureTitleControllerAr.text,
                  hospitalityBioAr: AdventureBioControllerAr.text,
                  adventurePrice: int.parse(AdventurePrice.text),
                  hospitalityImages: _AdventureImages,
                  adventureController: _AdventureControllerController,
                  hospitalityLocation: AdventureLocation.text,
                  experienceType: 'adventure',
                ));
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
    );
  
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
          color: Color(0xFF36B268),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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