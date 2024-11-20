import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:ajwad_v4/widgets/local_auth_mark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class LocalProfile extends StatefulWidget {
  const LocalProfile({super.key});

  @override
  State<LocalProfile> createState() => _LocalProfileState();
}

class _LocalProfileState extends State<LocalProfile> {
  final _profileController = Get.put(ProfileController());
  final _controller = MultiSelectController();
  var pickedFile;
  late XFile xfilePick;
  String? newProfileImage;
  final picker = ImagePicker();

  List<String> languages = [];

  String descripttion = '';

  void generateSpokenLanguges() {
    languages = List.generate(_controller.selectedOptions.length,
        (index) => _controller.selectedOptions[index].value);
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

        final image = await _profileController.uploadProfileImages(
          file: File(xfilePick.path),
          uploadOrUpdate: "upload",
          context: context,
        );

        if (image != null) {
          newProfileImage = image.filePath;
        }
      } else {
        AppUtil.errorToast(context, 'imageValidSize'.tr);
      }
    }
  }

  @override
  void dispose() {
    _profileController.isEditing(false);
    // TODO: implement dispose
    super.dispose();
  }

  void editProfile() async {
    generateSpokenLanguges();
    if (descripttion.isNotEmpty ||
        newProfileImage != null ||
        languages.isNotEmpty) {
      if (_profileController.isEditing.value) {
        var profile = await _profileController.editProfile(
            context: context,
            descripttion: descripttion.isEmpty
                ? _profileController.profile.descriptionAboutMe
                : descripttion,
            spokenLanguage: languages.isEmpty
                ? _profileController.profile.spokenLanguage
                : languages,
            profileImage:
                newProfileImage ?? _profileController.profile.profileImage);
        if (!mounted) return;

        if (profile != null) {
          await _profileController.getProfile(context: context);
          if (context.mounted) {
            AppUtil.successToast(context, "accountUpadted".tr);
          }
          //  _profileController.localBar(0);
          _controller.clearAllSelection();
          descripttion = '';
        }
      }
    } else {
      log("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                editProfile();
                _profileController.isEditing.value =
                    !_profileController.isEditing.value;
              },
              child: Padding(
                padding: AppUtil.rtlDirection2(context)
                    ? const EdgeInsets.only(left: 30, bottom: 4)
                    : const EdgeInsets.only(right: 30, bottom: 4),
                child: CustomText(
                  text: _profileController.isEditing.value
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
              ? const EdgeInsets.only(bottom: 4, right: 30, top: 4)
              // : EdgeInsets.only(top: 9, right: 30)
              : const EdgeInsets.only(bottom: 4, left: 30, top: 4),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 19,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.041,
          right: width * 0.041,
          top: width * 0.030,
          bottom: width * 0.082,
        ),
        child: Obx(
          () => _profileController.isEditProfileLoading.value ||
                  _profileController.isProfileLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : ListView(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: _profileController.isImagesLoading.value
                            ? const CircularProgressIndicator.adaptive()
                            : _profileController.profile.profileImage != "" &&
                                    _profileController.profile.profileImage !=
                                        null
                                ? ImageCacheWidget(
                                    image: _profileController
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
                    if (_profileController.isEditing.value)
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
                      height: width * 0.040,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: CustomText(
                            text: _profileController.profile.name ?? "",
                            fontSize: width * 0.043,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.0205,
                        ),
                        if (_profileController
                            .profile.tourGuideLicense!.isNotEmpty)
                          const LocalAuthMark()
                      ],
                    ),
                    SizedBox(
                      height: width * 0.041,
                    ),
                    CustomText(
                      text: 'aboutMe'.tr,
                      fontSize: width * 0.045,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: width * 0.0205,
                    ),
                    _profileController.isEditing.value
                        ? CustomTextField(
                            initialValue:
                                _profileController.profile.descriptionAboutMe ??
                                    "",
                            height: width * 0.35,
                            hintText: 'tellUsMore'.tr,
                            onChanged: (desc) => descripttion = desc,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                          )
                        : CustomText(
                            text: _profileController.profile.descriptionAboutMe,
                            fontSize: width * 0.038,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
                            maxlines: 20,
                          ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    const Divider(
                      color: lightGrey,
                    ),
                    SizedBox(
                      height: width * 0.041,
                    ),
                    CustomText(
                      text: 'languages'.tr,
                      fontSize: width * 0.045,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: width * 0.0205,
                    ),
                    _profileController.isEditing.value
                        ? MultiSelectDropDown(
                            controller: _controller,
                            hint: 'languages'.tr,
                            borderRadius: 8,
                            suffixIcon: const Icon(Icons.keyboard_arrow_up),
                            onOptionSelected: (options) {},
                            options: <ValueItem>[
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
                            chipConfig: ChipConfig(
                                wrapType: WrapType.scroll,
                                backgroundColor: graySubSmallText,
                                labelColor: black,
                                labelPadding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02),
                                deleteIconColor: black),
                            dropdownHeight: width * 0.51,
                            optionTextStyle: const TextStyle(fontSize: 16),

                            // selectedOptionIcon:
                            //     const Icon(Icons.check_circle),
                          )
                        : SizedBox(
                            height: width * 0.087,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _profileController
                                  .profile.spokenLanguage!.length,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 5,
                              ),
                              itemBuilder: (context, index) => Obx(
                                () => _profileController.isProfileLoading.value
                                    ? const CircularProgressIndicator.adaptive()
                                    : CustomChips(
                                        title: _profileController
                                            .profile.spokenLanguage![index].tr,
                                        backgroundColor: Colors.transparent,
                                        borderColor: almostGrey,
                                        textColor: almostGrey),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    const Divider(
                      color: lightGrey,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
