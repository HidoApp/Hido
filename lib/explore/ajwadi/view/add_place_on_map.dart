import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/set_location.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddPlaceOnMap extends StatefulWidget {
  const AddPlaceOnMap({Key? key}) : super(key: key);

  @override
  State<AddPlaceOnMap> createState() => _AddPlaceOnMapState();
}

class _AddPlaceOnMapState extends State<AddPlaceOnMap> {
  late double width, height;
  bool isChecked = true;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: lightBlack,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        "place".tr,
        color: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: height * 0.12, bottom: height * 0.01, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              child: Align(
                  alignment: AppUtil.rtlDirection(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: CustomText(
                    text: "tellUsAboutPlace".tr,
                    color: dividerColor,
                    fontSize: 16,
                    textAlign: TextAlign.end,
                  )),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomTextField(
              onChanged: print,
              hintText: "placeName".tr,
              textColor: Colors.white,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Get.to(SetLocationScreen());
              },
              child: CustomTextField(
                enable: false,
                keyboardType: TextInputType.text,
                textColor: Colors.white,
                hintText: 'placeLoc'.tr,
                suffixIcon: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: dividerColor,
                  ),
                ),
                icon: SvgPicture.asset(
                  "assets/icons/map-pin.svg",
                ),
                onChanged: (String value) {},
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomTextField(
              onChanged: (String value) {},
              hintText: "aboutThePlace".tr,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              height: 140,
              textColor: Colors.white,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Container(
                height: 60,
                child: DropdownSearch<String>(
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: const TextStyle(color: dividerColor),
                    dropdownSearchDecoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: SvgPicture.asset("assets/icons/price_icon.svg"),
                      ),
                      hintText: "price".tr,
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

                  items: const ['50', '100', '150', '200', '250'],
                  onChanged: print,
                  //  selectedItem: "Brazil"
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              height: 56,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: dividerColor)),
              child: Row(
                children: [
                  CustomText(
                    text: "uploadImage".tr,
                    color: dividerColor,
                  ),
                  Spacer(),
                  CustomButton(
                    onPressed: () {},
                    title: "",
                    icon: Icon(
                      Icons.add,
                    ),
                    customWidth: 80.0,
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Container(
                        height: 22,
                        width: 22,
                        //margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: dividerColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: isChecked ? colorGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ))),
                SizedBox(
                  height: height * 0.15,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: "areYouExpertInPlace".tr,
                  color: dividerColor,
                )
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                onPressed: () {},
                title: "addPlace".tr,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
