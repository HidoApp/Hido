import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:get/get.dart';

class LastStepScreen extends StatefulWidget {
  const LastStepScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.password,
      required this.authController,
      required this.countries})
      : super(key: key);

  final String name;
  final String email;
  final String password;
  final AuthController authController;
  final List<String> countries;

  @override
  State<LastStepScreen> createState() => _LastStepScreenState();
}

class _LastStepScreenState extends State<LastStepScreen> {
  late double width, height;
  bool isSwitched = false;
  final _formKey = GlobalKey<FormState>();
  String _selectedNationality = "NO";
  bool isNatSelected = true;

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
    print(widget.password);
    print(widget.name);
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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(""),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height * 0.18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: !AppUtil.rtlDirection(context)
                            ? const EdgeInsets.only(right: 20)
                            : const EdgeInsets.only(left: 20),
                        child: CustomText(
                          text: "lastStep".tr,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: CustomTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: 'phoneNum'.tr,
                          prefixIcon: const Icon(
                            Icons.local_phone_outlined,
                            color: colorDarkGrey,
                          ),
                          onChanged: (String value) {},
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                prefixIcon: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: SvgPicture.asset(
                                    'assets/icons/nationality.svg',
                                  ),
                                ),
                                hintText: 'nationality'.tr,
                                hintStyle: const TextStyle(color: dividerColor),
                                suffixIconColor: dividerColor,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            items: widget.countries,
                            onChanged: (v) {
                              setState(() {
                                isNatSelected = true;
                                _selectedNationality = v.toString();
                              });
                              print(_selectedNationality);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      isNatSelected
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: CustomText(
                                text: 'fieldRequired'.tr,
                                color: colorRed,
                                fontSize: 10,
                              ),
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: widget.authController.isRegisterLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: colorGreen,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: CustomElevatedButton(
                                    title: 'continue'.tr.toUpperCase(),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {}
                                      if (_selectedNationality == "NO") {
                                        setState(() {
                                          isNatSelected = false;
                                        });
                                        return;
                                      }

                                      if (!AppUtil.isPhoneValidate(
                                          _phoneController.text)) {
                                        AppUtil.errorToast(
                                            context, "invalidPhone".tr);
                                        return;
                                      }

                                      bool isSuccess = await widget
                                          .authController
                                          .touristRegister(
                                              email: widget.email,
                                              password: widget.password,
                                              name: widget.name,
                                              phoneNumber:
                                                  _phoneController.text,
                                              nationality: _selectedNationality,
                                              rememberMe: true,
                                              context: context);
                                      print(isSuccess);
                                      if (isSuccess) {
                                        Get.offAll(
                                            () => const TouristBottomBar());
                                      }
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
