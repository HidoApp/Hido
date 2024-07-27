import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/widgets/expert_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpertScreen extends StatefulWidget {
  const ExpertScreen({
    super.key,
    required this.profileController,
  });
  final ProfileController profileController;
  @override
  State<ExpertScreen> createState() => _ExpertScreenState();
}

class _ExpertScreenState extends State<ExpertScreen> {
  @override
  Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child:widget.profileController.profile.userInterests?.isEmpty??true?
         Center(
          child: CustomText(
            text: "noExpertise".tr,
            fontSize: width*0.04,
              fontFamily:!AppUtil.rtlDirection2(context)
                                  ? 'SF Pro'
                                  : 'SF Arabic',
             fontWeight: FontWeight.w400,
            color: starGreyColor,
          ),
        ):Container()
        
        );
  }
}
//  ListView.separated(
//         itemCount: widget.profileController.profile.expert,
//         separatorBuilder: (context, index) => SizedBox(height: 20,) ,
//        itemBuilder: (context, index) => ExpertCard(
//             image: "",
//             location: "ryadh",
//             rating: 5,
//             title: "shagra",
//           ),
//       ),