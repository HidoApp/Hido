import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/view/event_info_review.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/widget/add_event_info.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/widget/add_guests.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/widget/add_location.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/widget/add_price.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/widget/photo_gallery.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/widget/select_date_time.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';

import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter/material.dart';

class EventAddProgress extends StatefulWidget {
  // int activeIndex;

  const EventAddProgress({
    super.key,
  });

  @override
  _EventAddProgressState createState() => _EventAddProgressState();
}

class _EventAddProgressState extends State<EventAddProgress> {
  bool isFirstButtonPressed = false;
  bool isSecondButtonPressed = false;
  final int totalIndex = 6;
  int activeIndex = 0;

  final TextEditingController EventTitleControllerEn = TextEditingController();
  final TextEditingController EventBioControllerEn = TextEditingController();

  final TextEditingController EventTitleControllerAr = TextEditingController();
  final TextEditingController EventBioControllerAr = TextEditingController();

  final TextEditingController EventLocation = TextEditingController();
  final TextEditingController EventPrice = TextEditingController();

  final EventController _EventController = Get.put(EventController());

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
      ),
    );
  }

  Widget nextStep() {
    switch (activeIndex) {
      case 0:
        print("0");
        return AddInfo(
          textField1ControllerAR: EventTitleControllerAr,
          textField2ControllerAR: EventBioControllerAr,
          textField1ControllerEN: EventTitleControllerEn,
          textField2ControllerEN: EventBioControllerEn,
        );
      case 1:
        print(_EventController.bioAr.value);
        print(_EventController.bioEn.value);
        //print('1');

        return AddEventLocation(
          textField1Controller: EventLocation,
        );
      case 2:
        print(_EventController.pickUpLocLatLang.value.toString());
        print('2');

        return PhotoGalleryPage();
      case 3:
        print(_EventController.selectedImages.length);
        print('length image');
        return AddGuests();
      case 4:
        print(_EventController.seletedSeat.value);
        print("4");

        return SelectDateTime();
      case 5:
        print(_EventController.selectedEndTime.value);

        print('Selected Start Time: ${_EventController.selectedDates.value}');

        print("5");

        return PriceDecisionCard(priceController: EventPrice);

      default:
        print("2");
        return PhotoGalleryPage();
    }
  }

  bool _validateFields() {
    if (activeIndex == 0) {
      return _EventController.titleAr.isNotEmpty &&
          _EventController.bioAr.isNotEmpty &&
          _EventController.bioEn.isNotEmpty &&
          _EventController.titleEn.isNotEmpty;
      // EventTitleControllerEn.text.isNotEmpty &&
      //     EventBioControllerEn.text.isNotEmpty &&
      //     EventTitleControllerAr.text.isNotEmpty &&
      //    EventBioControllerAr.text.isNotEmpty;
    }
    if (activeIndex == 1) {
      return _EventController.pickUpLocLatLang.value !=
              const LatLng(0.0, 0.0) &&
          _EventController.ragionAr.isNotEmpty &&
          _EventController.ragionEn.isNotEmpty;
    }
    if (activeIndex == 2) {
      return _EventController.selectedImages.length >= 3;
    }
    if (activeIndex == 3) {
      return _EventController.seletedSeat.value != 0;
    }
    if (activeIndex == 4) {
      return _EventController.selectedDates.isNotEmpty &&
          _EventController.isEventTimeSelcted.value &&
          !_EventController.TimeErrorMessage.value &&
          !_EventController.DateErrorMessage.value;
    }
    if (activeIndex == 5) {
      if (EventPrice.text.isNotEmpty) {
        int? price = int.tryParse(EventPrice.text);
        if (price != null && price > 0) {
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
      return "eventLoc".tr;
    }
    if (activeIndex == 2) {
      return "PhotoGallery".tr;
    }
    if (activeIndex == 3) {
      return "peopleNumber".tr;
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
    return Obx(
      () => IgnorePointer(
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
                Get.to(() => EventInfoReview(
                      hospitalityTitleEn: _EventController.titleEn.value,
                      hospitalityBioEn: _EventController.bioEn.value,
                      hospitalityTitleAr: _EventController.titleAr.value,
                      hospitalityBioAr: _EventController.bioAr.value,
                      adventurePrice: double.parse(EventPrice.text),
                      hospitalityLocation: EventLocation.text,
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
        child: CustomText(
          text: 'Back'.tr,
          textAlign: TextAlign.center,
          color: Color(0xFF070708),
          fontSize: 17,
          fontFamily: 'HT Rakik',
          fontWeight: FontWeight.w500,
          height: 0.10,
        ),
      ),
    );
  }
}
