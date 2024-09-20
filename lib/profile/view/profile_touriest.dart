import 'dart:developer';
import 'dart:io';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';

import 'package:ajwad_v4/widgets/custom_text.dart';

import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class TouriestProfile extends StatefulWidget {
  const TouriestProfile(
      {Key? key, this.fromAjwady = true, required this.profileController})
      : super(key: key);

  final bool fromAjwady;
  final ProfileController profileController;
  @override
  State<TouriestProfile> createState() => _ProfileDetailsState();
}

final ImagePicker picker = ImagePicker();

var pickedFile;
late XFile xfilePick;
bool isEditing = false;
String? newProfileImage;
bool isStarChecked = false;
int startIndex = -1;
bool isSendTapped = false;
List<String> languages = [];
List<ValueItem> nationalites = [];
var nationality = '';

class _ProfileDetailsState extends State<TouriestProfile> {
  @override
  void dispose() {
    _userName.dispose();
    widget.profileController.isEditing(false);

    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountries();

    // widget.profileController.getProfile(context: context);
  }

  void getCountries() async {
    final authController = Get.put(AuthController());
    var countries = await authController.getListOfCountries(context);
    generateCountries(countries!);
  }

  Future getImage(ImageSource media, BuildContext context) async {
    // pickedFile = PickedFile('');
    pickedFile = await picker.pickImage(
      source: media,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      if (AppUtil.isImageValidate(await pickedFile.length())) {
         
        setState(() {
          xfilePick = pickedFile;
        });

        final image = await widget.profileController.uploadProfileImages(
          file: File(xfilePick.path),
          uploadOrUpdate: "upload",
          context: context,
        );

        if (image != null) {
          newProfileImage = image.filePath;
           
        }
      } else {
        AppUtil.errorToast(
            context, 'imageValidSize'.tr);
      }
    }
  }

  void generateSpokenLanguges() {
    languages = List.generate(_controller.selectedOptions.length,
        (index) => _controller.selectedOptions[index].value);
  }

  void generateCountries(List<String> countries) {
    nationalites = List.generate(countries.length,
        (index) => ValueItem(label: countries[index], value: countries[index]));
  }

  final _userName = TextEditingController();
  late double width, height;
  final _controller = MultiSelectController();
  final _controllerNationalies = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          actions: [
            Obx(
              () => GestureDetector(
                onTap: () async {
                  generateSpokenLanguges();
                  if (languages.isNotEmpty ||
                      newProfileImage != null ||
                      _userName.text.isNotEmpty ||
                      nationality.isNotEmpty) {
                    _controller.clearAllSelection();
                    await widget.profileController.editProfile(
                        context: context,
                        nationality: nationality.isEmpty ? null : nationality,
                        name: _userName.text.isEmpty
                            ? widget.profileController.profile.name
                            : _userName.text,
                        spokenLanguage: languages.isEmpty
                            ? widget.profileController.profile.spokenLanguage
                            : languages,
                        profileImage: newProfileImage ??
                            widget.profileController.profile.profileImage);

                    // _controllerNationalies.clearAllSelection();

                    await widget.profileController.getProfile(
                      context: context,
                    );

                    if (context.mounted) {
                      AppUtil.successToast(context, "accountUpadted".tr);
                    }
                    newProfileImage = null;
                  } else {
                    log("message");
                  }
                  nationality = '';
                  widget.profileController.isEditing.value =
                      !widget.profileController.isEditing.value;
                  _controllerNationalies.clearAllSelection();
                  _userName.clear();
                },
                child: Padding(
                     padding: AppUtil.rtlDirection2(context)
                    ? EdgeInsets.only(left: 30, bottom: 4)
                    : EdgeInsets.only(right: 30, bottom: 4),
                  //padding: EdgeInsets.symmetric(horizontal: width * 0.041),
                  child: CustomText(
                    text: widget.profileController.isEditing.value
                        ? 'save'.tr
                        : 'edit'.tr,
                    color: almostGrey,
                    textDecoration: TextDecoration.underline,
                    fontSize: width * 0.041,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppUtil.SfFontType(context),
                  ),
                ),
              ),
            )
          ],
          leading: Padding(
          padding: AppUtil.rtlDirection2(context)
              ? EdgeInsets.only(bottom: 4, right: 30, top: 4)
              // : EdgeInsets.only(top: 9, right: 30)
              : EdgeInsets.only(bottom: 4, left: 30, top: 4),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 19,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        ),
        body: Obx(
          () => widget.profileController.isProfileLoading.value ||
                  widget.profileController.isEditProfileLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  // padding: const EdgeInsets.all(8.0),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.041),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child:
                                widget.profileController.isImagesLoading.value
                                    ? const CircularProgressIndicator(
                                        color: colorGreen,
                                      )
                                    : widget.profileController.profile
                                                    .profileImage !=
                                                "" &&
                                            widget.profileController.profile
                                                    .profileImage !=
                                                null
                                        ? ImageCacheWidget(
                                            image: widget.profileController
                                                .profile.profileImage!,
                                            height: 100,
                                            width: 100,
                                            placeholder:
                                                "assets/images/profile_image.png",
                                          )
                                        : Image.asset(
                                            "assets/images/profile_image.png",
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.0128,
                        ),
                        if (widget.profileController.isEditing.value)
                          GestureDetector(
                            onTap: () => getImage(ImageSource.gallery, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: width * 0.046,
                                ),
                                SizedBox(
                                  width: width * 0.00512,
                                ),
                                CustomText(
                                  text: 'change'.tr,
                                  fontFamily: AppUtil.SfFontType(context),
                                  fontSize: width * .038,
                                  fontWeight: FontWeight.w500,
                                  textDecoration: TextDecoration.underline,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: width * .051,
                        ),
                        const Divider(color: lightGrey),
                        SizedBox(
                          height: width * 0.061,
                        ),
                        CustomText(
                          text: "fullName".tr,
                          color: black,
                          fontSize: width * 0.041,
                          fontFamily: AppUtil.SfFontType(context),
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: width * .0205,
                        ),
                        widget.profileController.isEditing.value
                            ? CustomTextField(
                                controller: _userName,
                                onChanged: (value) {},
                                hintText:
                                    widget.profileController.profile.name ??
                                        "NAME",
                              )
                            : CustomText(
                                text: widget.profileController.profile.name ??
                                    "NAME",
                                color: almostGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w400,
                              ),
                        SizedBox(
                          height: width * 0.061,
                        ),
                        const Divider(
                          color: lightGrey,
                        ),
                        SizedBox(
                          height: width * 0.061,
                        ),
                        CustomText(
                          text: "nationality".tr,
                          color: black,
                          fontSize: width * 0.041,
                          fontFamily: AppUtil.SfFontType(context),
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: width * .0205,
                        ),
                        widget.profileController.isEditing.value
                            ? MultiSelectDropDown(
                                controller: _controllerNationalies,
                                dropdownHeight: 250,

                                inputDecoration: BoxDecoration(
                                    border: Border.all(color: borderGrey),
                                    borderRadius: BorderRadius.circular(11)),
                                hint: 'chooseNationality'.tr,
                                borderRadius: 8,
                                hintPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                //   searchEnabled: true,
                                searchLabel: 'search'.tr,
                                suffixIcon: const Icon(Icons.keyboard_arrow_up),
                                clearIcon: null,
                                singleSelectItemStyle: TextStyle(
                                    fontSize: width * 0.038,
                                    fontFamily: AppUtil.SfFontType(context),
                                    color: black,
                                    fontWeight: FontWeight.w500),

                                onOptionSelected: (options) {
                                  if (options.isNotEmpty) {
                                    nationality = options.first.label;
                                  }
                                },

                                options: nationalites,
                                selectionType: SelectionType.single,

                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.scroll),
                                optionTextStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: AppUtil.SfFontType(context),
                                    color: starGreyColor,
                                    fontWeight: FontWeight.w500),

                                // selectedOptionIcon:
                                //     const Icon(Icons.check_circle),
                              )
                            : CustomText(
                                text: widget.profileController.profile
                                        .nationality ??
                                    "NAME",
                                color: almostGrey,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w400,
                              ),
                        SizedBox(
                          height: width * 0.061,
                        ),
                        const Divider(
                          color: lightGrey,
                        ),
                        SizedBox(
                          height: width * 0.061,
                        ),
                        CustomText(
                          text: "languages".tr,
                          color: black,
                          fontFamily: AppUtil.SfFontType(context),
                          fontSize: width * 0.041,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: width * 0.0205,
                        ),
                        widget.profileController.isEditing.value
                            ? MultiSelectDropDown(
                                controller: _controller,
                                hint: 'languages'.tr,
                                borderRadius: 8,
                                suffixIcon: const Icon(Icons.keyboard_arrow_up),
                                onOptionSelected: (options) {
                                   
                                },
                                options:  <ValueItem>[
                                ValueItem(
                                label: 'Arabic'.tr,
                                value: 'Arabic',
                              ),
                              ValueItem(label: 'English'.tr, value: 'English'),
                              ValueItem(
                                label: 'French'.tr,
                                value: 'French',
                              ),
                              ValueItem(
                                label: 'German'.tr,
                                value: 'German',
                              ),
                              ValueItem(label: 'Chinese'.tr, value: 'Chinese'),
                              ValueItem(label: 'Spanish'.tr, value: 'Spanish'),
                              ValueItem(label: 'Russian'.tr, value: 'Russian'),
                                ],

                                selectionType: SelectionType.multi,
                                chipConfig:
                                    ChipConfig(
                                      wrapType: WrapType.scroll,backgroundColor:graySubSmallText, 
                                      labelColor: black,

                                    labelPadding: EdgeInsets.symmetric(horizontal: width*0.02),
                                    deleteIconColor: black
                                    
                                    
                                    ),
                                dropdownHeight: 300,
                                optionTextStyle:
                                    TextStyle(fontSize: width * 0.041),

                                // selectedOptionIcon:
                                //     const Icon(Icons.check_circle),
                              )
                            : SizedBox(
                                height: width * 0.087,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.profileController.profile
                                      .spokenLanguage!.length,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 5,
                                  ),
                                  itemBuilder: (context, index) => Obx(
                                    () => widget.profileController
                                            .isProfileLoading.value
                                        ? const CircularProgressIndicator
                                            .adaptive()
                                        : CustomChips(
                                            title: widget.profileController
                                                .profile.spokenLanguage![index].tr,
                                            backgroundColor: Colors.transparent,
                                            borderColor: almostGrey,
                                            textColor: almostGrey),
                                  ),
                                ),
                              ),
                        if (widget.profileController.isEditing.value)
                          SizedBox(
                            height: width * .020,
                          ),
                        const Divider(
                          color: lightGrey,
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}
