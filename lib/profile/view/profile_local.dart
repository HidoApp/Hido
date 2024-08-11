import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/local_auth_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class LocalProfile extends StatefulWidget {
  const LocalProfile({super.key});

  @override
  State<LocalProfile> createState() => _LocalProfileState();
}

class _LocalProfileState extends State<LocalProfile> {
  final _profileController = Get.put(ProfileController());
  final _controller = MultiSelectController();
  List<String> languages = [];

  String descripttion = '';

  void generateSpokenLanguges() {
    languages = List.generate(_controller.selectedOptions.length,
        (index) => _controller.selectedOptions[index].value);
  }

  @override
  void dispose() {
    _profileController.isEditing(false);
    // TODO: implement dispose
    super.dispose();
  }

  void editProfile() async {
    generateSpokenLanguges();
    if (descripttion.isNotEmpty || languages.isNotEmpty) {
      if (_profileController.isEditing.value) {
        await _profileController.editProfile(
          context: context,
          descripttion: descripttion.isEmpty
              ? _profileController.profile.descriptionAboutMe
              : descripttion,
          spokenLanguage: languages.isEmpty
              ? _profileController.profile.spokenLanguage
              : languages,
        );
        await _profileController.getProfile(context: context);
        _controller.clearAllSelection();
        descripttion = '';
      }
      if (context.mounted) {
        AppUtil.successToast(context, "accountUpadted".tr);
      }
    } else {
      log("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
                padding: EdgeInsets.symmetric(horizontal: width * 0.041),
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
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.041),
            child: GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios,
                color: black,
              ),
            ),
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
                            ? const CircularProgressIndicator(
                                color: colorGreen,
                              )
                            : _profileController.profile.profileImage != "" &&
                                    _profileController.profile.profileImage !=
                                        null
                                ? Image.network(
                                    _profileController.profile.profileImage!,
                                    height: width * 0.256,
                                    width: width * 0.256,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/profile_image.png",
                                    height: width * 0.256,
                                    width: width * 0.256,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                    SizedBox(
                      height: width * 0.040,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: _profileController.profile.name ?? "",
                          fontSize: width * 0.043,
                          fontWeight: FontWeight.w500,
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
                            height: width * 0.35,
                            maxLines: 10,
                            hintText: 'tellUsMore'.tr,
                            onChanged: (desc) => descripttion = desc,
                            keyboardType: TextInputType.multiline,
                          )
                        : CustomText(
                            text: _profileController.profile.descriptionAboutMe,
                            fontSize: width * 0.038,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
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
                            onOptionSelected: (options) {
                              debugPrint(options.toString());
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
                                const ChipConfig(wrapType: WrapType.scroll),
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
                                            .profile.spokenLanguage![index],
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
