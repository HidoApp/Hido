import 'dart:io';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
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


  
  late double width, height;
  bool isChecked = true;
  int selectedChoice = 3;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: lightBlack,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        "events".tr,
        color: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: height * 0.12, bottom: height * 0.01, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Align(
                    alignment: !AppUtil.rtlDirection(context)
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
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
                hintText: "eventName".tr,
                textColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextWithIconButton(
                  onTap: () {
                    Get.to(() => SetLocationScreen());
                  },
                  height: height * 0.06,
                  width: width * 0.95,
                  title: 'eventLoc'.tr,
                  borderColor: dividerColor,
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
                height: height * 0.02,
              ),
              CustomTextField(
                onChanged: (String value) {},
                hintText: "aboutTheEvent".tr,
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
                  child: DropdownSearch<String>(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle: const TextStyle(color: dividerColor),
                      dropdownSearchDecoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child:
                              SvgPicture.asset("assets/icons/price_icon.svg"),
                        ),
                        hintText: "price".tr,
                        hintStyle: const TextStyle(color: dividerColor),
                        suffixIconColor: dividerColor,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: dividerColor),
                        ),
                        // suffix: Icon(Icons.arrow_back_ios_new)
                      ),
                    ),

                    items: const ['50', '100', '150', '200', '250'],
                    onChanged: print,
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
              dateChoice(),
              SizedBox(
                height: height * 0.02,
              ),
              Align(
                alignment: !AppUtil.rtlDirection(context)
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: CustomTextWithIconButton(
                  onTap: () {
                    setState(() {
                      selectedChoice = 3;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  CalenderDialog(type: 'event',);
                        });
                  },
                  height: height * 0.06,
                  width: width * 0.65,
                  title: 'chooseFromCalender'.tr,
                  borderColor: dividerColor,
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/purple_calendar.svg",
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: colorPurple,
                    size: 15,
                  ),
                  textColor: dividerColor,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                height: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: dividerColor)),
                child: Row(
                  children: [
                    CustomText(
                      text: "uploadImage".tr,
                      color: dividerColor,
                    ),
                    Spacer(),
                    CustomButton(
                      onPressed: () {},
                      buttonColor: colorPurple,
                      iconColor: colorDarkPurple,
                      title: "",
                      icon: Icon(
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
                  onPressed: () {},
                  title: "addEvent".tr,
                  buttonColor: colorPurple,
                  iconColor: colorDarkPurple,
                  icon: Icon(Icons.add),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
            ],
          ),
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
                    color:
                        selectedChoice == 0 ? colorPurple : Colors.transparent,
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
                    color:
                        selectedChoice == 1 ? colorPurple : Colors.transparent,
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
                    color:
                        selectedChoice == 2 ? colorPurple : Colors.transparent,
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
