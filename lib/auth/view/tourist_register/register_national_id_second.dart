import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/tourist_register/phone_otp.dart';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RegisterNationalIdSecond extends StatefulWidget {
  const RegisterNationalIdSecond({
    Key? key,
    this.countries,
    required this.authController,
    required this.nationalId,
    required this.birthDate,
  }) : super(key: key);
  final countries;
  final AuthController authController;
  final String nationalId;
  final String birthDate;

  @override
  State<RegisterNationalIdSecond> createState() =>
      _RegisterNationalIdSecondState();
}

class _RegisterNationalIdSecondState extends State<RegisterNationalIdSecond> {
  final _formKey = GlobalKey<FormState>();

  late double width, height;
  bool isSwitched = false;
  late bool showPassword, showConfirmPassword;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswoedController = TextEditingController();
  final _phoneController = TextEditingController();

  bool initailNationality = true;
  String _selectedNationality = "NO";
  bool isNatSelected = true;

  // final _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    showPassword = false;
    showConfirmPassword = false;
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
          appBar: CustomAppBar(""),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/background_ajwadi.png"),
                    fit: BoxFit.fill,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.04,
                      right: width * 0.05,
                      left: width * 0.05),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [],
                      ),
                      CustomText(
                        text: "لنقم بإنشاء الحساب".tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text:
                            'لأغراض الأمن والسلامة ، نحتاج إلى التحقق من هويتك. يرجى تزويدنا ببطاقة هوية صالحة صادرة عن جهة حكومية'
                                .tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              keyboardType: TextInputType.name,
                              controller: _nameController,
                              hintText: 'fullName'.tr,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'emailHint'.tr,
                              controller: _emailController,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.text,
                              obscureText: !showPassword,
                              hintText: 'password'.tr,
                              controller: _passwordController,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                              suffixIcon: GestureDetector(
                                child: Icon(
                                    showPassword == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF969696)),
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.text,
                              obscureText: !showConfirmPassword,
                              hintText: 'confirmPass'.tr,
                              controller: _confirmPasswoedController,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                              suffixIcon: GestureDetector(
                                child: Icon(
                                    showConfirmPassword == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF969696)),
                                onTap: () {
                                  setState(() {
                                    showConfirmPassword = !showConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              hintText: 'phoneNum'.tr,
                              prefixIcon: const Icon(
                                Icons.local_phone_outlined,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                height: 60,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownSearch<String>(
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      prefixIcon: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: SvgPicture.asset(
                                          'assets/icons/nationality.svg',
                                        ),
                                      ),
                                      hintText: 'nationality'.tr,
                                      hintStyle: TextStyle(
                                          color: initailNationality == true
                                              ? dividerColor
                                              : colorDarkRed),
                                      suffixIconColor: dividerColor,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        // borderSide:
                                        //     BorderSide(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  items: widget.countries,
                                  onChanged: (v) {
                                    setState(() {
                                      isNatSelected = false;
                                      _selectedNationality = v.toString();
                                    });
                                    print(_selectedNationality);
                                    print(isNatSelected);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: widget.authController.isPersonInfoLoading ==
                                  true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: colorGreen),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomElevatedButton(
                                        title: 'verify'.tr,
                                        onPressed: () async {
                                          print(_selectedNationality);
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (!AppUtil.isEmailValidate(
                                                _emailController.text)) {
                                              AppUtil.errorToast(
                                                  context, "invalidEmail".tr);
                                              return;
                                            }

                                            if (!AppUtil.isPhoneValidate(
                                                _phoneController.text)) {
                                              AppUtil.errorToast(
                                                  context, "invalidPhone".tr);
                                              return;
                                            }

                                            if (!AppUtil
                                                .isPasswordLengthValidate(
                                                    _passwordController.text)) {
                                              AppUtil.errorToast(context,
                                                  "invalidPassword".tr);
                                              return;
                                            }

                                            if (_passwordController.text !=
                                                _confirmPasswoedController
                                                    .text) {
                                              AppUtil.errorToast(
                                                  context,
                                                  "password&confirmation not matching"
                                                      .tr);
                                              return;
                                            }

                                            if (_selectedNationality == "NO") {
                                              AppUtil.errorToast(context,
                                                  "Select nationality".tr);
                                              return;
                                            }

                                            final isSuccess = await widget
                                                .authController
                                                .personInfoOTP(
                                                    nationalID:
                                                        widget.nationalId,
                                                    birthDate: widget.birthDate,
                                                    context: context);
                                            print('isSuccess UI $isSuccess');
                                            if (isSuccess) {
                                              Get.to(() => PhoneOTPScreen(
                                                  authController:
                                                      widget.authController,
                                                  name: _nameController.text,
                                                  password:
                                                      _passwordController.text,
                                                  nationalID: widget.nationalId,
                                                  email: _emailController.text,
                                                  nationality:
                                                      _selectedNationality,
                                                  phone:
                                                      _phoneController.text,
                                                      isAjwadi: false,
                                                      
                                                      ));
                                            }
                                          }
                                        }),
                                  ),
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "alreadyHaveAccount".tr,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: CustomText(
                              text: "signIn".tr,
                              color: colorGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
