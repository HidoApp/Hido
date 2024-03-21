import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../widgets/custom_onboarding_widget.dart';
import 'onboarding_tasting.dart';

class OnBoardingDiscover extends StatelessWidget {
  const OnBoardingDiscover({Key? key, required this.getStorage}) : super(key: key);
    final GetStorage getStorage;

  @override
  Widget build(BuildContext context) {
         return CustomOnBoardingWidget(nextScreen: (){
           Get.off(() => OnBoardingTasting(getStorage: getStorage,),  transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000));
         }, text:'discover'.tr, backgroundImage: 'on_boarding_discover', description: 'from_start_to_finish'.tr,);

  }
}
