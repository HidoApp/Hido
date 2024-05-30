import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
    this.title, {
    Key? key,
    this.color = black,
    this.iconColor,
    this.action = false,
    this.onPressedAction,
    this.backgroundColor,
    this.isAjwadi = false,
  })  : preferredSize = const Size.fromHeight(75.0),
  
  
        super(key: key);

  final String title;
  final Color? color;
  final Color? iconColor;
    final Color? backgroundColor;
  final bool action;
  final bool isAjwadi;
  final VoidCallback? onPressedAction;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
   return PreferredSize(
    preferredSize: const Size.fromHeight(79.0),
    child: Directionality(
      textDirection: AppUtil.rtlDirection2(context) ? TextDirection.rtl : TextDirection.ltr,
    child:Padding(padding:EdgeInsets.only(top:0),
    
   child: AppBar(
      
    backgroundColor:  backgroundColor?? Colors.transparent,
    elevation: 0,
    title: Padding(
      padding: AppUtil.rtlDirection2(context)? EdgeInsets.only(top: 0, left: 0, right: 0,bottom: 18):EdgeInsets.only(top: 0, left: 20, right: 20,bottom: 18),
      child: CustomText(
          text: title,
          color: color ?? const Color(0xFF333333),
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
    ),
     actions: <Widget>[
      if(action)
       Padding(
        padding: AppUtil.rtlDirection2(context)
            ? EdgeInsets.only(bottom: 35, left: 15,)
            : EdgeInsets.only(bottom: 35, right: 15),
          child:IconButton(
            icon: Icon(Icons.more_vert,
              size: 29,
             color: color ?? Colors.black,
             ),
            tooltip:"more",
            onPressed: onPressedAction,
          ),
       ),
        ], //
      centerTitle: true,

        leading: Padding(
        padding: AppUtil.rtlDirection2(context)?EdgeInsets.only(bottom:10, right:30):EdgeInsets.only(bottom:23, left:30),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: iconColor ?? Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      
))));
  }
}
