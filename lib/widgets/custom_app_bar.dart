import 'package:ajwad_v4/constants/colors.dart';
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
    this.isAjwadi = false,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  final String title;
  final Color? color;
  final Color? iconColor;
  final bool action;
  final bool isAjwadi;
  final VoidCallback? onPressedAction;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: false,
        // forceMaterialTransparency: true,
        title: CustomText(
          text: title,
          color: color ?? const Color(0xFF333333),
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SizedBox(
              child: Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: iconColor ?? black,
          )),
          onPressed: () => Get.back(),
          color: color ?? Colors.black,
        ),
        actions: action
            ? [
                IconButton(
                    onPressed: onPressedAction,
                    icon: Icon(
                      Icons.more_vert,
                      size: 32,
                      color: color ?? Colors.black,
                    ))
              ]
            : []);
  }
}
