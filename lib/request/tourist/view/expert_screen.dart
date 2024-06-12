import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/widgets/expert_card.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CustomText(
            text: "There are no expertise yet",
            color: almostGrey,
          ),
        ));
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