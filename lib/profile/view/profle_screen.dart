import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/booking_screen.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/profile/view/profile_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';

import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_list_tile.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'ticket_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {Key? key, this.fromAjwady = false, required this.profileController})
      : super(key: key);

  final bool fromAjwady;
  final ProfileController profileController;
  // final Profile? profile;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double width, height;
//
  final _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    print("  _profileController.getProfile(context: context);");
    getProfile();
  }

  void getProfile() async {
    await _profileController.getProfile(context: context);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Obx(
      () => Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              height: height * .94, // was .9
              padding: EdgeInsets.only(top: height * 0.09),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: _profileController.isImagesLoading.value ||
                                _profileController.isProfileLoading.value
                            ? Image.asset(
                                "assets/images/profile_image.png",
                                height: 65,
                                width: 65,
                                fit: BoxFit.cover,
                              )
                            : _profileController.profile.profileImage != "" &&
                                    _profileController.profile.profileImage !=
                                        null
                                ? Image.network(
                                    _profileController.profile.profileImage!,
                                    height: 65,
                                    width: 65,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/profile_image.png",
                                    height: 65,
                                    width: 65,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            _profileController.isProfileLoading.value
                                ? ""
                                : _profileController.profile.name ?? "NO",
                            //   widget.profileController.,
                            style: (const TextStyle(color: black)),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.fromAjwady
                                    ? "Ajwady   | ${_profileController.isProfileLoading.value ? "" : _profileController.profile.rating}  "
                                    : "Tourist   | ${_profileController.isProfileLoading.value ? "" : _profileController.profile.rating}  ",
                                style: (const TextStyle(color: colorDarkGrey)),
                              ),
                              SvgPicture.asset("assets/icons/star.svg")
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Divider(
                      color: lightGrey,
                      thickness: 2,
                    ),
                  ),
                  Column(
                    children: [
                      // CustomListTile(
                      //   title: widget.fromAjwady
                      //       ? "switchAccountToTourist".tr
                      //       : "switchAccountToAjwadi".tr,
                      //   leading: widget.fromAjwady
                      //       ? "assets/icons/switch_icon2.svg"
                      //       : "assets/icons/switch_icon.svg",
                      //   fromAjwady: widget.fromAjwady,
                      //   onTap: () {
                      //     showModalBottomSheet(
                      //         isScrollControlled: true,
                      //         backgroundColor: Colors.transparent,
                      //         shape: const RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.only(
                      //           topRight: Radius.circular(30),
                      //           topLeft: Radius.circular(30),
                      //         )),
                      //         context: context,
                      //         builder: (context) {
                      //           return widget.fromAjwady
                      //               ? SwitchAcount()
                      //               : SwitchAcount(fromAjwady: false);
                      //         });
                      //   },
                      // ),
                      CustomListTile(
                        title: "myProfile".tr,
                        leading: "assets/icons/profile_icon.svg",
                        iconColor: colorGreen,
                        //   fromAjwady: false,
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              )),
                              context: context,
                              builder: (context) {
                                return ProfileDetails(
                                  fromAjwady: false,
                                  profileController: _profileController,
                                );
                              });
                        },
                      ),
                      CustomListTile(
                        title: "massage".tr,
                        leading: "assets/icons/myChat_icon.svg",
                        iconColor: colorGreen,
                        //  fromAjwady: widget.fromAjwady,
                        onTap: () {
                          Get.to(
                            () => MessagesScreen(
                              profileController: widget.profileController,
                            ),
                          );
                        },
                      ),
                      // widget.fromAjwady
                      //     ? Container()
                      //     : CustomListTile(
                      //         title: "myOrders".tr,
                      //         leading: "assets/icons/myorder_icon.svg",
                      //         iconColor: colorGreen,
                      //         //  fromAjwady: widget.fromAjwady,
                      //         onTap: () {
                      //           Get.to(() => OrderScreen());
                      //         },
                      //       ),
                      // widget.fromAjwady
                      //     ? Container()
                      //     : CustomListTile(
                      //         title: "bookmark".tr,
                      //         leading: "assets/icons/bookmark_icon.svg",
                      //         iconColor: colorGreen,
                      //         //  fromAjwady: widget.fromAjwady,
                      //         onTap: () {
                      //           Get.to(() => const BookmarkScreen());
                      //         },
                      //       ),

                      if (!widget.fromAjwady)
                        CustomListTile(
                          title: "tourHistory".tr,
                          leading: "assets/icons/Time.svg",
                          iconColor: colorGreen,
                          onTap: () {
                            Get.to(() => BookingScreen());
                          },
                        ),

                      if (!widget.fromAjwady)
                        CustomListTile(
                          title: "myTickets".tr,
                          leading: "assets/icons/trips_icon.svg",
                          iconColor: colorGreen,
                          onTap: () {
                            Get.to(() => TicketScreen(
                                  profileController: widget.profileController,
                                ));
                          },
                        ),

                      // widget.fromAjwady
                      //     ? Container()
                      //     : CustomListTile(
                      //         title: "myFav".tr,
                      //         leading: "assets/icons/fav_icon.svg",
                      //         onTap: () {
                      //           Get.to(() => const BookmarkScreen());
                      //         },
                      //       ),
                    ],
                  ),
                  const Divider(
                    color: lightGrey,
                    thickness: 2,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // CustomListTile(
                        //   title: "paymentMethods".tr,
                        //   leading: "assets/icons/payment_icon.svg",
                        //   iconColor: colorGreen,
                        //   onTap: () {
                        //     showModalBottomSheet(
                        //         isScrollControlled: true,
                        //         backgroundColor: Colors.transparent,
                        //         shape: const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(30),
                        //           topLeft: Radius.circular(30),
                        //         )),
                        //         context: context,
                        //         builder: (context) {
                        //           return PaymentMethod();
                        //         });
                        //   },
                        // ),
                        // CustomListTile(
                        //   title: "contactUs".tr,
                        //   leading: "assets/icons/profile_icon.svg",
                        //   iconColor: colorGreen,
                        //   onTap: () {
                        //     showModalBottomSheet(
                        //         isScrollControlled: true,
                        //         backgroundColor: Colors.transparent,
                        //         shape: const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(30),
                        //           topLeft: Radius.circular(30),
                        //         )),
                        //         context: context,
                        //         builder: (context) {
                        //           return const ContactUs();
                        //         });
                        //   },
                        // ),
                        // CustomListTile(
                        //   title: "helpsFAQs".tr,
                        //   leading: "assets/icons/help_icon.svg",
                        //   // fromAjwady: widget.fromAjwady,
                        //   iconColor: colorGreen,
                        //   onTap: () {
                        //     Get.to(() => widget.fromAjwady
                        //         ? HelpAndFAQsScreen(
                        //             fromAjwady: false,
                        //           )
                        //         : HelpAndFAQsScreen(
                        //             fromAjwady: false,
                        //           ));
                        //   },
                        // ),
                        CustomListTile(
                          title: "signOut".tr,
                          leading: "assets/icons/signout_icon.svg",
                          // fromAjwady: widget.fromAjwady,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                          textAlign: TextAlign.center,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: dividerColor,
                                          text: "youWantSiginOut".tr),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: CustomButton(
                                          height: 25,
                                          title: "signOut".tr,
                                          onPressed: () {
                                            AuthService.logOut();
                                            Get.offAll(() =>
                                                const AccountTypeScreen());
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: CustomText(
                                            textAlign: TextAlign.center,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: colorRed,
                                            text: "cancel".tr.toUpperCase()),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        CustomListTile(
                          title: "deleteAccount".tr,
                          leading: "assets/icons/delete_icon.svg",
                          // fromAjwady: widget.fromAjwady,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                          textAlign: TextAlign.center,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: dividerColor,
                                          text: "youWantDeleteYourAccount".tr),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: CustomButton(
                                          height: 25,
                                          title: "deleteAccount".tr,
                                          onPressed: () async {
                                            final authController =
                                                Get.put(AuthController());
                                            final isSuccess =
                                                await authController
                                                    .deleteAccount(
                                                        context: context);

                                            if (isSuccess) {
                                              Get.offAll(() =>
                                                  const AccountTypeScreen());
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: CustomText(
                                            textAlign: TextAlign.center,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: colorRed,
                                            text: "cancel".tr.toUpperCase()),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
