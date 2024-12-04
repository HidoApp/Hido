import 'package:ajwad_v4/auth/view/ajwadi_register/local_sign_up.dart';
import 'package:ajwad_v4/auth/view/tourist_register/register/register_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/terms&conditions.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_list_tile.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/verion_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../new-onboarding/view/intro_screen.dart';

class GuestSignInScreen extends StatefulWidget {
  const GuestSignInScreen({Key? key, this.isProfile = true}) : super(key: key);

  final bool isProfile;

  @override
  State<GuestSignInScreen> createState() => _GuestSignInScreenState();
}

class _GuestSignInScreenState extends State<GuestSignInScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: width * 0.128, bottom: width * .051),
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "welcomeHido".tr,
                fontSize: width * 0.051,
              ),
              SizedBox(
                height: width * 0.04,
              ),
              CustomText(
                text: "guestSubtitle".tr,
                fontSize: width * 0.038,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: width * 0.030,
              ),
              Center(
                child: CustomButton(
                  height: width * 0.107,
                  onPressed: () {
                    // Get.offAll(() => AccountTypeScreen());
                    Get.offAll(() => const OnboardingScreen());

                    Get.to(() => const RegisterScreen());
                  },
                  title: "signUpTourist".tr,
                  customWidth: width * 0.91,
                  raduis: 4,
                ),
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.offAll(() => const OnboardingScreen());
                    Get.to(
                      () => const LocalSignUpScreen(),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: width * 0.107,
                    width: width * 0.91,
                    decoration: BoxDecoration(
                        border: Border.all(color: colorGreen, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: CustomText(
                      text: "guestLocalSignUp".tr,
                      color: colorGreen,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
              ),
              if (widget.isProfile) ...[
                SizedBox(
                  height: width * 0.09,
                ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: width * .012,
                ),
                CustomListTile(
                  title: "terms".tr,
                  leading: "assets/icons/help_icon.svg",
                  iconColor: colorGreen,
                  onTap: () {
                    Get.to(() => const TermsAndConditions(fromAjwady: false));
                  },
                ),
                SizedBox(
                  height: width * .012,
                ),
                const Divider(
                  color: lightGrey,
                ),
              ],
              const Spacer(),
              const Center(
                child: VersionText(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
