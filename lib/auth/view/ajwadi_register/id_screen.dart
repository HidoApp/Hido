import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_ajwadi_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IdScreen extends StatefulWidget {
  const IdScreen({Key? key}) : super(key: key);

  @override
  State<IdScreen> createState() => _IdScreenState();
}

class _IdScreenState extends State<IdScreen> {
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
          appBar: CustomAjwadiAppBar("ID"),
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
                    ),
                  ),
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomText(
                          text:
                              "For security and safety purposes, we need to verify your identity. \nPlease provide us with a valid government-issued ID",
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.25,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Uplaod Image");
                        },
                        child: CustomTextField(
                          enable: false,
                          keyboardType: TextInputType.phone,
                          hintText: 'ID',
                          suffixIcon: Container(
                            padding: EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              "assets/icons/upload_icon.svg",
                            ),
                          ),
                          icon: Icon(
                            Icons.person_outline,
                            color: colorDarkGrey,
                          ),
                          onChanged: (String value) {},
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CustomText(
                          text:
                              "This information will be used for security checks and will be kept confidential.",
                          color: colorDarkGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomElevatedButton(
                            title: 'CONTINUE',
                            onPressed: () {
                          //    Get.to(() => const CarInformationScreen());
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
