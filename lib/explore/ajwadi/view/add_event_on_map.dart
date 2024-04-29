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


class AddEventOnMap extends StatefulWidget {
  const AddEventOnMap({Key? key}) : super(key: key);

  @override
  State<AddEventOnMap> createState() => _AddEventOnMapState();
}

class _AddEventOnMapState extends State<AddEventOnMap> {
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  final _eventNameArController = TextEditingController();
  final _eventNameEnController = TextEditingController();
  final _eventDescArController = TextEditingController();
  final _eventDescEnController = TextEditingController();

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
              'Image is too large, you can only upload less than 2 MB');
        }
      }

      print(xfilePickList.length);

      _ajwadiExploreController.numOfImages.value = xfilePickList.length;
      //   xfilePick = pickedFile!;
      //  final imgLength = await File(xfilePick!.path).length();

      //  print(imgLength);
      //print(AppUtil.isImageValidate(imgLength));
      //   if (AppUtil.isImageValidate(imgLength)) {
      //     // final image = await _tripController.uploadImages(
      //     //     file: File(xfilePick!.path),
      //     //     fileType: 'adventures',
      //     //     context: context);
      //     // print(image!.publicId);
      //   } else {
      //  //   pickedFile = null;
      //   //  xfilePick = XFile('');
      //     AppUtil.errorToast(
      //         context, 'Image is too large, you can only upload less than 2 GB');
      //   }
    }

    //
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
        "events".tr,
        color:darkBlue,
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
                              text: "tellUsAboutEvent".tr,
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
                        controller: _eventNameArController,
                        hintText: "eventName".tr + ' AR',
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        onChanged: print,
                        controller: _eventNameEnController,
                        hintText: "eventName".tr + " En",
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
                          title: 'eventLoc'.tr,
                          borderColor: _ajwadiExploreController.isLatLangEmpty.value
                              ? colorPurple
                              : dividerColor,
                          prefixIcon: SvgPicture.asset(
                            "assets/icons/map-pin.svg",
                          ),
                          suffixIcon: Icon(
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
                                color: colorPurple,
                                fontSize: 10,
                                fontFamily: 'Noto Kufi Arabic',
                              ))
                          : Container(),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        onChanged: (String value) {},
                        hintText: "aboutTheEvent".tr + " Ar",
                        controller: _eventDescArController,
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
                        hintText: "aboutTheEvent".tr + " En",
                        controller: _eventDescEnController,
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
                                    type: 'event',
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
                            color: lightYellow,
                          ),
                          suffixIcon: const Icon(
                            Icons.arrow_forward_ios,
                            color: lightYellow,
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
                                    buttonColor: lightYellow,
                                    iconColor: gold,
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
                                        fileType: 'event',
                                        context: context);
                                uploadImages.add(image!);

                                print("image!.publicId");
                                //   print(image!.publicId);
                              }

                              if (context.mounted) {
                                final trip = await _ajwadiExploreController.addTrip(
                                    tripOption: 'events',
                                    nameAr: _eventNameArController.text,
                                    nameEn: _eventNameEnController.text,
                                    descriptionAr: _eventDescArController.text,
                                    descriptionEn: _eventDescEnController.text,
                                    price: price,
                                    date: _ajwadiExploreController.selectedAdvDate.value,
                                    lat: lat,
                                    lang: lang,
                                    imag: uploadImages,
                                    context: context);
                                Get.back();
                                if (context.mounted)
                                  AppUtil.successToast(context,
                                      'event was added successfully ');
                              }
                            }
                          },
                          title: "addEvent".tr,
                          buttonColor: lightYellow,
                             icon: Icon(Icons.check),
                          iconColor: gold,
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
                ? const Center(
                    child: CircularProgressIndicator(color: colorPurple),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget dateChoice() {
    return SizedBox(
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
