import 'dart:developer';

import 'package:ajwad_v4/api/translation_api.dart';
import 'package:ajwad_v4/explore/local/controllers/local_explore_controller.dart';
import 'package:ajwad_v4/explore/local/view/Experience/adventure/widget/add_adventure_info.dart';
import 'package:ajwad_v4/explore/local/view/Experience/adventure/widget/add_guests.dart';
import 'package:ajwad_v4/explore/local/view/Experience/adventure/widget/add_location.dart';
import 'package:ajwad_v4/explore/local/view/Experience/adventure/widget/add_price.dart';
import 'package:ajwad_v4/explore/local/view/Experience/adventure/widget/photo_gallery.dart';
import 'package:ajwad_v4/explore/local/view/Experience/adventure/widget/select_date_time.dart';
import 'package:ajwad_v4/explore/local/view/hoapatility/view/host_info_review.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';

import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter/material.dart';

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

  @override
  dispose() {
    super.dispose();
    AdventureBioControllerAr.dispose();
    // AdventureBioControllerEn.dispose();
    AdventureLocation.dispose();
    AdventurePrice.dispose();
    AdventureTitleControllerAr.dispose();
    // AdventureTitleControllerEn.dispose();
  }

  final List<String> _AdventureImages = [];
  int seats = 0;
  String gender = '';
  final AdventureController _AdventureControllerController =
      Get.put(AdventureController());
  final LocalExploreController localExploreController =
      Get.put(LocalExploreController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
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

  Future<void> translateTitleIfChanged() async {
    final current = AdventureTitleControllerAr.text;

    if (current.isNotEmpty &&
        current != _AdventureControllerController.lastTranslatedTitleAr) {
      final translated = await TranslationApi.translate(current, 'en');
      AdventureTitleControllerEn.text = translated;
      _AdventureControllerController.lastTranslatedTitleAr = current;
    }
  }

  Widget nextStep() {
    switch (activeIndex) {
      case 0:
        return AddInfo(
          textField1ControllerAR: AdventureTitleControllerAr,
          textField2ControllerAR: AdventureBioControllerAr,
          // textField1ControllerEN: AdventureTitleControllerEn,
          // textField2ControllerEN: AdventureBioControllerEn,
        );
      case 1:
        return AddLocation(
          textField1Controller: AdventureLocation,
        );
      case 2:
        return PhotoGalleryPage(selectedImages: _AdventureImages);
      case 3:
        return AddGuests(adventureController: _AdventureControllerController);
      case 4:
        return SelectDateTime(
          adventureController: _AdventureControllerController,
          localExploreController: localExploreController,
        );
      case 5:
        return PriceDecisionCard(priceController: AdventurePrice);

      default:
        return PhotoGalleryPage(
            selectedImages:
                _AdventureImages); // Replace with your actual widget
    }
  }

  bool _validateFields() {
    if (activeIndex == 0) {
      return
          //  AdventureTitleControllerEn.text.isNotEmpty &&
          //   AdventureBioControllerEn.text.isNotEmpty &&
          AdventureTitleControllerAr.text.isNotEmpty &&
              AdventureBioControllerAr.text.isNotEmpty;
    }
    if (activeIndex == 1) {
      return _AdventureControllerController.pickUpLocLatLang.value !=
              const LatLng(0.0, 0.0) &&
          _AdventureControllerController.ragionAr.isNotEmpty &&
          _AdventureControllerController.ragionEn.isNotEmpty;
    }
    if (activeIndex == 2) {
      return _AdventureControllerController.selectedImages.length >= 3;
    }

    if (activeIndex == 3) {
      log(activeIndex.toString());

      return _AdventureControllerController.seletedSeat.value != 0;
    }

    if (activeIndex == 4) {
      // return  _AdventureControllerController.selectedDates.value.isNotEmpty && _AdventureControllerController.isAdventureTimeSelcted.value ;

      return _AdventureControllerController.selectedDates.isNotEmpty &&
          _AdventureControllerController.isAdventureTimeSelcted.value &&
          !_AdventureControllerController.TimeErrorMessage.value &&
          !_AdventureControllerController.newRangeTimeErrorMessage.value &&
          !_AdventureControllerController.DateErrorMessage.value;
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
      return 'peopleNumber'.tr;
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
              onTap: () async {
                if (activeIndex < totalIndex - 1) {
                  setState(() {
                    activeIndex++;
                  });
                } else if (activeIndex == totalIndex - 1) {
                  // final translatedText = await TranslationApi.translate(
                  //   AdventureTitleControllerAr.text,
                  //   'en',
                  // );
                  // AdventureTitleControllerEn.text = translatedText;
                  await translateTitleIfChanged();
                  Get.to(() => HostInfoReview(
                        hospitalityTitleEn: AdventureTitleControllerEn.text,
                        // hospitalityBioEn: AdventureBioControllerEn.text,
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
