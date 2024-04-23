import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_oval_text.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails(
      {Key? key, this.fromAjwady = true, this.profileController})
      : super(key: key);

  final bool fromAjwady;
  final ProfileController? profileController;
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

final ImagePicker picker = ImagePicker();

var pickedFile;
late XFile xfilePick;
bool isEditing = false;
late String newProfileImage;

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

  var interestList = [
    "gamesOnline".tr,
    "concert".tr,
    "music".tr,
    "art".tr,
    "movie".tr,
    "others".tr,
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: 24),
              child: Text(
                'Edit',
                style: TextStyle(
                    color: darkBlue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: darkBlue),
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
      body: Column(
        children: [
          Obx(
            () => ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 22
                      // bottom: height
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          getImage(ImageSource.gallery, context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: widget.profileController!.isImagesLoading.value
                              ? const CircularProgressIndicator(
                                  color: colorGreen,
                                )
                              // : xfilePick.path.isNotEmpty
                              //     ? Image.file(
                              //         File(xfilePick.path),
                              //         fit: BoxFit.cover,
                              //         width: 100,
                              //         height: 100,
                              //       )
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
                      const SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        text: widget.profileController!.profile.name ?? "NAME",
                        color: widget.fromAjwady ? Colors.white : darkBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "aboutMe".tr,
                            color: widget.fromAjwady ? Colors.white : darkBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          // GestureDetector(
                          //     onTap: () {
                          //       print("About Me ");
                          //     },
                          //     child: SvgPicture.asset(
                          //         "assets/icons/edite_icon.svg"))
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: widget.profileController!.profile
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
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "interest".tr,
                            color: widget.fromAjwady ? Colors.white : darkBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
