import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_oval_text.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
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
    return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (_, controller) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
              return Container(
                decoration: BoxDecoration(
                    color: widget.fromAjwady ? lightBlack : Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => ListView(
                    controller: controller,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          // bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: height * 0.01,
                          left: width * 0.03,
                          right: width * 0.03,
                          // bottom: height
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.keyboard_arrow_up,
                                size: 25,
                                color: colorDarkGrey,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  getImage(ImageSource.gallery, context);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: widget
                                          .profileController!.isImagesLoading.value
                                      ? CircularProgressIndicator(
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
                              CustomText(
                                text: widget.profileController!.profile.name ??
                                    "NAME",
                                color: widget.fromAjwady ? Colors.white : black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    text: "aboutMe".tr,
                                    color: widget.fromAjwady ? Colors.white : black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
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
                                height: 15,
                              ),
                              CustomText(
                                text: widget.profileController!.profile
                                        .descriptionAboutMe ??
                                    "DESC",
                                color: colorDarkGrey,
                                fontSize: 14,
                                height: 1.785,
                                fontWeight: FontWeight.w400,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    text: "interest".tr,
                                    color: widget.fromAjwady ? Colors.white : black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  // const Spacer(),
                                  // GestureDetector(
                                  //     onTap: () {},
                                  //     child: SvgPicture.asset( !AppUtil.rtlDirection(context) ?
                                  //       "assets/icons/Change_Button.svg":
                                  //       "assets/icons/Change_Button_arabic.svg",
                                  //       height: 90,
                                  //     ))
                                ],
                              ),
                              // widget.profileController!.profile.userInterests ==
                              //         null
                              //     ? Container()
                              //     : Wrap(
                              //         direction: Axis.horizontal,
                              //         spacing: 10.0,
                              //         runSpacing: 5.0,
                              //         children: List.generate(interestList.length,
                              //             (index) {
                              //           return CustomOvalText(
                              //             index: index % 4,
                              //             title: interestList[index],
                              //           );
                              //         })),
                              // const SizedBox(
                              //   height: 60,
                              // ),
                              // CustomElevatedButton(
                              //     title: !isEditing ? 'edite'.tr : "update".tr,
                              //     onPressed: () {})
                            ]),
                      )
                    ],
                  ),
                ),
              );
            }
          );
        });
  }
}
