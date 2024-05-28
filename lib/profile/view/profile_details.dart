import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_oval_text.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_area.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/review_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails(
      {Key? key, this.fromAjwady = true, required this.profileController})
      : super(key: key);

  final bool fromAjwady;
  final ProfileController profileController;
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

final ImagePicker picker = ImagePicker();

var pickedFile;
late XFile xfilePick;
bool isEditing = false;
late String newProfileImage;
bool isStarChecked = false;
int startIndex = -1;
bool isSendTapped = false;

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.profileController!.getProfile(context: context);
  }

  Future getImage(ImageSource media, BuildContext context) async {
    // pickedFile = PickedFile('');
    pickedFile = await picker.pickImage(
      source: media,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      if (AppUtil.isImageValidate(await pickedFile.length())) {
        print(" is asdded");
        setState(() {
          xfilePick = pickedFile;
        });

        final image = await widget.profileController!.uploadProfileImages(
            file: File(xfilePick.path),
            uploadOrUpdate: "upload",
            // widget.profileController!.profile.profileImage == null ||
            //         widget.profileController!.profile.profileImage == ""
            //     ? 'upload'
            //     : 'update',
            context: context);

        if (image != null) {
          newProfileImage = image!.filePath;
          print(image.filePath);

          await widget.profileController!
              .editProfile(context: context, profileImage: image.filePath);

          setState(() {
            widget.profileController!.profile.profileImage = image.filePath;
          });
          await widget.profileController!.getProfile(
            context: context,
          );
        }
      } else {
        AppUtil.errorToast(
            context, 'Image is too large, you can only upload less than 2 MB');
      }
    }
  }

  late double width, height;
  final _controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                widget.profileController.isEditing.value =
                    !widget.profileController.isEditing.value;
              },
              child: Padding(
                padding: EdgeInsets.only(right: 24),
                child: Text(
                  widget.profileController.isEditing.value
                      ? 'save'.tr
                      : 'edit'.tr,
                  style: TextStyle(
                      color: darkBlue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: darkBlue),
                ),
              ),
            ),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: black,
            ),
            onPressed: () => Get.back(),
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22
                        // bottom: height
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child:
                                widget.profileController!.isImagesLoading.value
                                    ? const CircularProgressIndicator(
                                        color: colorGreen,
                                      )
                                    : widget.profileController!.profile
                                                    .profileImage !=
                                                "" &&
                                            widget.profileController!.profile
                                                    .profileImage !=
                                                null
                                        ? Image.network(
                                            widget.profileController!.profile
                                                .profileImage!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
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
                          height: 5,
                        ),
                        if (widget.profileController.isEditing.value)
                          GestureDetector(
                            onTap: () => getImage(ImageSource.gallery, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                CustomText(
                                  text: 'change'.tr,
                                  textDecoration: TextDecoration.underline,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Divider(
                          color: lightGrey,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: width * 0.061,
                        ),
                        CustomText(
                          text: "fullName".tr,
                          color: black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        widget.profileController.isEditing.value
                            ? CustomTextField(
                                height: 42,
                                onChanged: (value) {},
                                hintText:
                                    widget.profileController.profile.name ??
                                        "NAME",
                              )
                            : CustomText(
                                text: widget.profileController.profile.name ??
                                    "NAME",
                                color: almostGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: widget.profileController.profile
                                    .descriptionAboutMe ??
                                "DESC",
                            color: lightGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            color: lightGrey,
                            thickness: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        CustomText(
                          text: "languages".tr,
                          color: black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        widget.profileController.isEditing.value
                            ? MultiSelectDropDown(
                                controller: _controller,
                                onOptionSelected: (options) {
                                  debugPrint(options.toString());
                                },
                                options: const <ValueItem>[
                                  ValueItem(label: 'Option 1', value: '1'),
                                  ValueItem(label: 'Option 2', value: '2'),
                                  ValueItem(label: 'Option 3', value: '3'),
                                  ValueItem(label: 'Option 4', value: '4'),
                                  ValueItem(label: 'Option 5', value: '5'),
                                  ValueItem(label: 'Option 6', value: '6'),
                                ],
                                disabledOptions: const [
                                  ValueItem(label: 'Option 1', value: '1')
                                ],
                                selectionType: SelectionType.multi,
                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.wrap),
                                dropdownHeight: 300,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionIcon:
                                    const Icon(Icons.check_circle),
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
                                    () => CustomChips(
                                        title: widget.profileController.profile
                                            .spokenLanguage![index],
                                        backgroundColor: Colors.transparent,
                                        borderColor: almostGrey,
                                        textColor: almostGrey),
                                  ),
                                ),
                              ),
                        if (widget.profileController.isEditing.value)
                          SizedBox(
                            height: 8,
                          ),
                        const Divider(
                          color: lightGrey,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// GestureDetector(
//                               onTap: () => Get.bottomSheet(
//                                 Text("data"),
//                               ),
//                               child: CustomTextField(
//                                 hintText: "languages".tr,
//                                 enable: false,
//                                 height: 42,
//                                 onChanged: (value) {},
//                                 suffixIcon: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: black,
//                                 ),
//                               ),
//                             )