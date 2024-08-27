import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/phone_otp.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_ajwadi_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:get_storage/get_storage.dart';

class AjwadiVehicleInfo extends StatefulWidget {
  const AjwadiVehicleInfo({Key? key}) : super(key: key);
  @override
  State<AjwadiVehicleInfo> createState() => _AjwadiVehicleInfoState();
}

class _AjwadiVehicleInfoState extends State<AjwadiVehicleInfo> {
  late double width, height;
  bool isSwitched = false;

  final _formKey = GlobalKey<FormState>();

  final authController = Get.put(AuthController());

  final _nationalIdController = TextEditingController();
  final _vehicleNumberController = TextEditingController();

  final getStorage = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CustomAjwadiAppBar(
            "",
            isBack: false,
          ),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                // Container(
                //   height: height,
                //   width: width,
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //     image: AssetImage("assets/images/background_ajwadi.png"),
                //     fit: BoxFit.fill,
                //   )),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.14,
                      left: width * 0.05,
                      right: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'vehicleInformation'.tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomText(
                        text: 'youWillPickUpTourists'.tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: black,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              controller: _vehicleNumberController,
                              hintText: 'Vehicle Serial Number'.tr,
                              textColor: Colors.grey,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.grey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              controller: _nationalIdController,
                              hintText: 'nationalId'.tr,
                              textColor: Colors.grey,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.grey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: authController.isVicheleOTPLoading.value ==
                                    true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: colorGreen),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: CustomButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (!AppUtil.isNationalIdValidate(
                                              _nationalIdController.text)) {
                                            AppUtil.errorToast(context,
                                                "nationalIdMustbe10".tr);
                                            return;
                                          }

                                        var   isSuccess =
                                              await authController.vehicleOTP(
                                                
                                                  vehicleSerialNumber:
                                                      _vehicleNumberController
                                                          .text,
                                                  context: context);
                                          print(isSuccess);
                                          if (isSuccess!=null) {
                                            String accessToken =
                                                getStorage.read('accessToken');

                                            Get.to(() => PhoneOTPScreen(
                                                isAjwadi: true,
                                                authController: authController,
                                                birthDate:
                                                    _vehicleNumberController
                                                        .text,
                                                isLiencese: false,
                                                nationalID:
                                                    _nationalIdController.text,
                                                accessToken: accessToken));
                                          }

                                          // Get.to(()=>PhoneOTPScreen(isAjwadi: true,authController: authController,nationalID: _nationalIdController.text, isLiencese: false));
                                        }
                                      },
                                      title: 'signUp'.tr,
                                      icon: !AppUtil.rtlDirection(context)
                                          ? const Icon(
                                              Icons.arrow_back_ios,
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            ),
                                    ),
                                  ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
