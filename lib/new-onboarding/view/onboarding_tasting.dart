import 'package:ajwad_v4/new-onboarding/view/onboarding_enjoy.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../widgets/custom_onboarding_widget.dart';
class OnBoardingTasting extends StatelessWidget {
  const OnBoardingTasting({Key? key, required this.getStorage}) : super(key: key);
    final GetStorage getStorage;

  @override
  Widget build(BuildContext context) {
    return CustomOnBoardingWidget(nextScreen: (){
      Get.off(() =>  OnBoardingEnjoy(getStorage: getStorage,),  transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500));}, text:'taste'.tr, backgroundImage: 'on_boarding_tasting', description: 'popular_saudi'.tr,);

  }
}
