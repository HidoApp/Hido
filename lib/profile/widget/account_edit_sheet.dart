import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/profile_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AccountEditSheet extends StatefulWidget {
  const AccountEditSheet(
      {super.key, required this.profileController, this.isEditEmail = true});
  final ProfileController profileController;
  final bool isEditEmail;
  @override
  State<AccountEditSheet> createState() => _AccountEditSheetState();
}

class _AccountEditSheetState extends State<AccountEditSheet> {
  final _textController = TextEditingController();

  void editEmail() async {
    final _authController = Get.put(AuthController());
    if (_textController.text.isEmpty ||
        !AppUtil.isEmailValidate(_textController.text)) {
      widget.profileController.isEmailNotValid(true);
    } else {
      widget.profileController.isEmailNotValid(false);
      // TODO: must change services of email reset
      final res = await _authController.sendEmailOTP(
          email: _textController.text, context: context);
      widget.profileController.isEmailOtp(true);
    }
  }

  void editNumber() async {
    if (_textController.text.isEmpty ||
        !AppUtil.isPhoneValidate(_textController.text.trim())) {
      widget.profileController.isNumberNotValid(true);
    } else {
      widget.profileController.isNumberNotValid(false);

      await widget.profileController.editProfile(
        context: context,
        name: widget.profileController.profile.name,
        profileImage: widget.profileController.profile.profileImage,
        spokenLanguage: widget.profileController.profile.spokenLanguage,
        phone: _textController.text.trim(),
      );
      await widget.profileController.getProfile(
        context: context,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: width * 0.83,
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.05,
            ),
            CustomText(
              text: widget.isEditEmail ? 'Update email' : "Edit phone number",
              fontSize: width * 0.056,
            ),
            SizedBox(
              height: width * 0.020,
            ),
            CustomText(
              text: widget.isEditEmail
                  ? 'We’ll send you an email to confirm your new email address'
                  : "We’ll text you code to verify your number ",
              fontSize: width * 0.04,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(
              height: width * 0.03,
            ),
            CustomText(
              text: widget.isEditEmail ? 'email'.tr : 'Phone number',
              fontSize: width * .0435,
            ),
            Obx(
              () => widget.isEditEmail
                  ? Form(
                      onPopInvoked: (didPop) =>
                          widget.profileController.isEmailNotValid(false),
                      child: CustomTextField(
                        controller: _textController,
                        onChanged: (value) {},
                        borderColor:
                            widget.profileController.isEmailNotValid.value
                                ? colorRed
                                : almostGrey,
                        height: 42,
                        hintText: widget.profileController.profile.email,
                      ),
                    )
                  : Form(
                      onPopInvoked: (didPop) =>
                          widget.profileController.isNumberNotValid(false),
                      child: CustomTextField(
                        controller: _textController,
                        onChanged: (value) {},
                        borderColor:
                            widget.profileController.isNumberNotValid.value
                                ? colorRed
                                : almostGrey,
                        height: 42,
                        hintText: widget.profileController.profile.phoneNumber,
                      ),
                    ),
            ),
            widget.isEditEmail
                ? Obx(() => widget.profileController.isEmailNotValid.value
                    ? Padding(
                        padding: AppUtil.rtlDirection2(context)
                            ? const EdgeInsets.only(right: 10)
                            : const EdgeInsets.only(left: 10),
                        child: const CustomText(
                          text: "*Enter a valid email",
                          color: colorRed,
                        ),
                      )
                    : Container())
                : Obx(() => widget.profileController.isNumberNotValid.value
                    ? Padding(
                        padding: AppUtil.rtlDirection2(context)
                            ? const EdgeInsets.only(right: 10)
                            : const EdgeInsets.only(left: 10),
                        child: const CustomText(
                          text: "*Enter a valid Number",
                          color: colorRed,
                        ),
                      )
                    : Container()),
            const Spacer(),
            Obx(
              () => widget.profileController.isEditProfileLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : CustomButton(
                      onPressed: () {
                        if (widget.isEditEmail) {
                          editEmail();
                        } else {
                          editNumber();
                        }
                      },
                      title: 'confirm'.tr),
            )
          ],
        ),
      ),
    );
  }
}
