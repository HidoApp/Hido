import 'package:ajwad_v4/auth/view/ajwadi_register/id_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';

import 'package:ajwad_v4/widgets/custom_ajwadi_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OneMoreStepScreen extends StatefulWidget {
  const OneMoreStepScreen({Key? key}) : super(key: key);

  @override
  State<OneMoreStepScreen> createState() => _OneMoreStepScreenState();
}

class _OneMoreStepScreenState extends State<OneMoreStepScreen> {
  late double width, height;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: lightBlack,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: CustomAjwadiAppBar(""),
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
                  padding: EdgeInsets.only(top: height * 0.16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: CustomText(
                          text: "One more step",
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.phone,
                        hintText: 'Phone Number',
                        icon: const Icon(
                          Icons.local_phone_outlined,
                          color: colorDarkGrey,
                        ),
                        onChanged: (String value) {},
                      ),
                      const SizedBox(
                        height: 30,
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
                              baseStyle: const TextStyle(color: dividerColor),
                              dropdownSearchDecoration: InputDecoration(
                                prefixIcon: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: SvgPicture.asset(
                                    'assets/icons/nationality.svg',
                                  ),
                                ),
                                hintText: "Nationality",
                                hintStyle: const TextStyle(color: dividerColor),
                                suffixIconColor: dividerColor,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(color: dividerColor),
                                ),
                                // suffix: Icon(Icons.arrow_back_ios_new)
                              ),
                            ),
                            items: [
                              "Brazil",
                              "Italia",
                              "Tunisia",
                              'Canada',
                              "Brazil",
                              "Italia",
                              "Tunisia",
                              'Canada' "Brazil",
                              "Italia",
                              "Tunisia",
                              'Canada'
                            ],
                            onChanged: print,
                            //  selectedItem: "Brazil"
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.phone,
                        hintText: 'Nationality',
                        icon: SizedBox(
                          child: SvgPicture.asset(
                            'assets/icons/nationality.svg',
                          ),
                        ),
                        onChanged: (String value) {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            FlutterSwitch(
                              width: 45.0,
                              height: 28.0,
                              activeColor: const Color(0xFF5AC28F),
                              inactiveColor: const Color(0xFFE8ECEF),
                              onToggle: (bool value) {
                                //  toggleSwitch();
                                //  bookingController.toggleSwitch();
                                setState(() {
                                  isSwitched = !isSwitched;
                                });
                              },
                              value: isSwitched,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const CustomText(
                              text: "Remember Me",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomElevatedButton(
                            title: 'CONTINUE',
                            onPressed: () {
                              Get.to(() => const IdScreen());
                            },
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
