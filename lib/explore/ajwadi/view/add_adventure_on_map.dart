import 'dart:io';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/set_location.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddAdventureOnMap extends StatefulWidget {
  const AddAdventureOnMap({Key? key}) : super(key: key);

  @override
  State<AddAdventureOnMap> createState() => _AddAdventureOnMapState();
}

class _AddAdventureOnMapState extends State<AddAdventureOnMap> {
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  final _advNameArController = TextEditingController();
  final _advNameEnController = TextEditingController();
  final _advDescArController = TextEditingController();
  final _advDescEnController = TextEditingController();

  final _getStorage = GetStorage();
  final _authController = Get.put(AuthController());
  final _ajwadiExploreController = Get.put(AjwadiExploreController());

  String lat = '24.774265';
  String lang = '46.738586';

  String price = '';
  String selectedDate = '';
  var pickedFile;
  late XFile xfilePick = XFile('');

  List pickedFileList = [];
  late List<XFile> xfilePickList = [];

  bool isLatLangEmpty = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String token = _getStorage.read('accessToken');
    AppUtil.isTokeValidate(token);
    if (AppUtil.isTokeValidate(token)) {
      String refreshToken = _getStorage.read('refreshToken');
      _authController.refreshToken(
          refreshToken: refreshToken, context: context);
    }
  }

  Future getImage(ImageSource media, BuildContext context) async {
    xfilePickList = [];
    pickedFile = await picker.pickMultiImage(
      imageQuality: 30,
    );
    if (pickedFile != null) {
      for (int i = 0; i < pickedFile.length; i++) {
        print(await pickedFile[i].length());
        if (AppUtil.isImageValidate(await pickedFile[i].length())) {
          //   print(await pickedFile[i].length());
          print(" is asdded");
          xfilePickList.add(pickedFile[i]);
        } else {
          AppUtil.errorToast(context,
              'imageValidSize'.tr);
        }
      }

      print(xfilePickList.length);

      _ajwadiExploreController.numOfImages.value = xfilePickList.length;
    }
  }

  late double width, height;
  bool isChecked = true;
  int selectedChoice = 3;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        "adventures".tr,
        color: darkBlue,
      ),
      body: Obx(
        () => Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: height * 0.14,
                  bottom: height * 0.01,
                  left: 10,
                  right: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: Align(
                            alignment: AppUtil.rtlDirection(context)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: CustomText(
                              text: "tellUsAboutAdventure".tr,
                              color: dividerColor,
                              fontSize: 16,
                              textAlign: TextAlign.end,
                            )),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        onChanged: print,
                        controller: _advNameArController,
                        hintText: "advName".tr + ' AR',
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        onChanged: print,
                        controller: _advNameEnController,
                        hintText: "advName".tr + " En",
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Align(
                        // alignment: AppUtil.rtlDirection(context)
                        //     ? Alignment.centerLeft
                        //     : Alignment.centerRight,
                        child: CustomTextWithIconButton(
                          onTap: () {
                            Get.to(() => SetLocationScreen());
                          },
                          height: height * 0.06,
                          width: width * 0.87,
                          title: 'advLoc'.tr,
                          borderColor: _ajwadiExploreController.isLatLangEmpty.value
                              ? colorDarkRed
                              : dividerColor,
                          prefixIcon: SvgPicture.asset(
                            "assets/icons/map-pin.svg",
                          ),
                          suffixIcon:const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: dividerColor,
                          ),
                          textColor: colorDarkGrey,
                        ),
                      ),
                      SizedBox(
                        height: _ajwadiExploreController.isLatLangEmpty.value ? 5 : 0,
                      ),
                      _ajwadiExploreController.isLatLangEmpty.value
                          ? Align(
                              alignment: AppUtil.rtlDirection(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: 'fieldRequired'.tr,
                                color: colorDarkRed,
                                fontSize: 10,
                                fontFamily: 'Noto Kufi Arabic',
                              ))
                          : Container(),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        onChanged: (String value) {},
                        hintText: "aboutTheAdv".tr + " Ar",
                        controller: _advDescArController,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        height: 140,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        onChanged: (String value) {},
                        hintText: "aboutTheAdv".tr + " En",
                        controller: _advDescEnController,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        height: 140,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                        child: Container(
                          height: 60,
                          width: width * 0.87,
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              baseStyle: const TextStyle(color: dividerColor),
                              dropdownSearchDecoration: InputDecoration(
                                prefixIcon: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: SvgPicture.asset(
                                      "assets/icons/price_icon.svg"),
                                ),
                                hintText: "price".tr,
                                hintStyle: const TextStyle(color: dividerColor),
                                suffixIconColor: dividerColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                      color: _ajwadiExploreController.isPriceEmpty.value
                                          ? colorDarkRed
                                          : dividerColor),
                                ),
                                // suffix: Icon(Icons.arrow_back_ios_new)
                              ),
                            ),

                            items: const ['50', '100', '150', '200', '250'],
                            onChanged: (selctedPrice) {
                              price = selctedPrice!;
                            },
                            //  selectedItem: "Brazil"
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Align(
                          alignment: !AppUtil.rtlDirection(context)
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: CustomText(
                            text: "timeDate".tr,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Align(
                        alignment: !AppUtil.rtlDirection(context)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: CustomTextWithIconButton(
                          onTap: () {
                            print("object");
                            setState(() {
                              selectedChoice = 3;
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CalenderDialog(
                                    type: 'adv',
                                    ajwadiExploreController: _ajwadiExploreController,
                                    fromAjwady: false,
                                  );
                                });
                          },
                          height: height * 0.06,
                          width: width * 0.65,
                          title: _ajwadiExploreController.isDateEmpty.value
                              ? 'chooseFromCalender'.tr
                              : _ajwadiExploreController.selectedAdvDate.value.isNotEmpty
                                  ? _ajwadiExploreController.selectedAdvDate.value
                                      .substring(0, 10)
                                  : 'chooseFromCalender'.tr,
                          borderColor: _ajwadiExploreController.isDateEmpty.value
                              ? colorDarkRed
                              : dividerColor,
                          prefixIcon: SvgPicture.asset(
                            "assets/icons/red_calendar.svg",
                            color: pink,
                          ),
                          suffixIcon: Icon(
                            Icons.arrow_forward_ios,
                           color: pink,
                            size: 15,
                          ),
                          textColor: dividerColor,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: _ajwadiExploreController.isImageEmpty.value
                                    ? colorDarkRed
                                    : dividerColor)),
                        child: Row(
                          children: [
                            CustomText(
                              text: _ajwadiExploreController.numOfImages.value == 0
                                  ? "uploadImage".tr
                                  : "Num of Images " +
                                      _ajwadiExploreController.numOfImages.value
                                          .toString(),
                              color: dividerColor,
                            ),
                            Spacer(),
                            _ajwadiExploreController.isImagesLoading.value
                                ? Container()
                                : CustomButton(
                                    onPressed: () {
                                      getImage(ImageSource.gallery, context);
                                      //   pickFile();
                                    },
                                    buttonColor: pink,
                                    iconColor: darkPink,
                                    title: "",
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    customWidth: 80.0,
                                  )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          onPressed: () async {
                            var token = _getStorage.read('accessToken') ?? '';
                            if (AppUtil.isTokeValidate(token)) {
                              String refreshToken =
                                  _getStorage.read('refreshToken');
                              _authController.refreshToken(
                                  refreshToken: refreshToken, context: context);
                            }

                            _ajwadiExploreController.isLatLangEmpty.value = false;
                            _ajwadiExploreController.isPriceEmpty.value = false;
                            _ajwadiExploreController.isDateEmpty.value = false;
                            _ajwadiExploreController.isImageEmpty.value = false;

                            if (lang.isEmpty || lat.isEmpty) {
                              _ajwadiExploreController.isLatLangEmpty.value = true;
                            }

                            if (price.isEmpty) {
                              _ajwadiExploreController.isPriceEmpty.value = true;
                            }

                            if (_ajwadiExploreController.selectedAdvDate.isEmpty) {
                              _ajwadiExploreController.isDateEmpty.value = true;
                              // return;
                            }

                            if (pickedFile == null) {
                              _ajwadiExploreController.isImageEmpty.value = true;
                              //  return;
                            }
                            if (_formKey.currentState!.validate()) {
                              List<UploadImage> uploadImages = [];
                              for (int i = 0; i < xfilePickList.length; i++) {
                                final image =
                                    await _ajwadiExploreController.uploadImages(
                                        file: File(xfilePickList[i].path),
                                        fileType: 'adventures',
                                        context: context);
                                        
                                uploadImages.add(image!);

                                print("image!.publicId");
                                //   print(image!.publicId);
                              }

                              if (context.mounted) {
                                final trip = await _ajwadiExploreController.addTrip(
                                    tripOption: 'adventures',
                                    nameAr: _advNameArController.text,
                                    nameEn: _advNameEnController.text,
                                    descriptionAr: _advDescArController.text,
                                    descriptionEn: _advDescEnController.text,
                                    price: price,
                                    date: _ajwadiExploreController.selectedAdvDate.value,
                                    lat: lat,
                                    lang: lang,
                                    imag: uploadImages,
                                    context: context);
                                Get.back();
                                if (context.mounted)
                                  AppUtil.successToast(context,
                                      'addventure was added successfully ');
                              }
                            }
                          },
                          title: "addAdv".tr,
                          buttonColor: pink,
                          icon: Icon(Icons.check),
                          iconColor: darkPink,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _ajwadiExploreController.isAddingTripLoading.value ||
                    _ajwadiExploreController.isImagesLoading.value
                ? Center(
                    child: CircularProgressIndicator(color: colorDarkRed),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget dateChoice() {
    return Container(
      child: Wrap(
          direction: Axis.horizontal,
          spacing: 20.0,
          // runSpacing: 100.0,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedChoice = 0;
                });
              },
              child: Container(
                height: height * 0.06,
                width: width * 0.2,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: selectedChoice == 0
                            ? Colors.transparent
                            : dividerColor),
                    color: selectedChoice == 0 ? colorRed : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: CustomText(
                    text: 'today'.tr,
                    fontSize: 16,
                    color: selectedChoice == 0 ? Colors.white : dividerColor,
                  )),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedChoice = 1;
                });
              },
              child: Container(
                height: height * 0.06,
                width: width * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: selectedChoice == 1
                            ? Colors.transparent
                            : dividerColor),
                    color: selectedChoice == 1 ? colorRed : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: CustomText(
                    text: 'tomorrow'.tr,
                    fontSize: 16,
                    color: selectedChoice == 1 ? Colors.white : dividerColor,
                  )),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedChoice = 2;
                });
              },
              child: Container(
                height: height * 0.06,
                width: width * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: selectedChoice == 2
                            ? Colors.transparent
                            : dividerColor),
                    color: selectedChoice == 2 ? colorRed : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: CustomText(
                    text: 'thisWeek'.tr,
                    fontSize: 16,
                    color: selectedChoice == 2 ? Colors.white : dividerColor,
                  )),
                ),
              ),
            ),
          ]),
    );
  }
}
