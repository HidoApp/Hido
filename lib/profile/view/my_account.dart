import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar("My account"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
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
