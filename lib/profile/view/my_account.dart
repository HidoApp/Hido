import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/profile/widget/account_edit_sheet.dart';
import 'package:ajwad_v4/profile/widget/account_tile.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key, required this.profileController});
  final ProfileController profileController;
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late Profile profile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getPhoneNumber() {
    //to secure phone number
    final String number = widget.profileController.profile.phoneNumber!;
    return number.substring(0, 2) +
        '*' * (number.length - 4) +
        number.substring(number.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar("account".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 41),
        child: Column(
          children: [
            Obx(
              () => widget.profileController.isProfileLoading.value
                  ? Container()
                  : AccountTile(
                      title: "email".tr,
                      subtitle: widget.profileController.profile.email!,
                      onTap: () {
                        // showModalBottomSheet(
                        //   isScrollControlled: true,
                        //   enableDrag: true,
                        //   context: context,
                        //   builder: (context) => AccountEditSheet(
                        //     profileController: widget.profileController,
                        //   ),
                        // );
                      },
                    ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: lightGrey,
              ),
            ),
            Obx(
              () => widget.profileController.isProfileLoading.value
                  ? Container()
                  : AccountTile(
                      title: "Phone number",
                      subtitle: getPhoneNumber(),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) => AccountEditSheet(
                            isEditEmail: false,
                            profileController: widget.profileController,
                          ),
                        );
                      },
                    ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: lightGrey,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    final authController =
                                        Get.put(AuthController());
                                    final isSuccess = await authController
                                        .deleteAccount(context: context);

                                    if (isSuccess) {
                                      Get.offAll(
                                          () => const AccountTypeScreen());
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 357,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.red, strokeAlign: 1)),
                                    child: CustomText(
                                      text: "deleteAccount".tr,
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: black,
                                    text: "cancel".tr.toUpperCase()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const CustomText(
                  text: "Delete  account",
                  textDecoration: TextDecoration.underline,
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
