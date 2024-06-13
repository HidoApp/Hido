import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/app_util.dart';
import '../../widgets/custom_elevated_button_with_arrow.dart';
import '../../widgets/custom_text.dart';

class OnBoardingEnjoy extends StatelessWidget {
  const OnBoardingEnjoy({Key? key, required this.getStorage}) : super(key: key);
  final GetStorage getStorage;

  @override
  Widget build(BuildContext context) {
    print( getStorage.read('onBoarding'));
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/onboarding/on_boarding_enjoy.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            top: size.width * 0.769,
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.0666, right: size.width * 0.0666),
              child: CustomText(
                text: 'enjoy_in'.tr,
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontSize:! AppUtil.rtlDirection(context)
                    ? size.width * 0.164
                    : size.width * 0.1282,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            top: size.width * 1.0769,
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.0666, right: size.width * 0.0666),
              child: CustomText(
                text: 'saudi_arabia'.tr,
                fontStyle: FontStyle.normal,
                color: colorGreen,
                fontSize:! AppUtil.rtlDirection(context)
                    ? size.width * 0.164
                    : size.width * 0.1282,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: size.width * 0.15,
            left: size.width * 0.0384,
            right: size.width * 0.0384,
            child: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.0666, right: size.width * 0.0666),
                child: CustomElevatedButton(
                  title: 'start_tour'.tr,
                  onPressed: () async {
                  
                    await getStorage.write('onBoarding', 'yes');

                    
                    Get.off( AccountTypeScreen(),
                        transition: Transition.fade);
                  },
                  color: gold,
                )),
          ),
        ],
      ),
    );
  }
}
