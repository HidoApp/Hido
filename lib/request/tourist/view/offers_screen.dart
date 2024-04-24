import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
       final width = MediaQuery.of(context).size.width;
   final  height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar('Offers',action: true,onPressedAction: (){}
      ,),
      body: CustomText(text: "emty",)
    );
  }
  
}