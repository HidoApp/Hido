import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAjwadiAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAjwadiAppBar(
    this.title, {
    Key? key,  this.isBack = true
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  final String title;
  final bool isBack ;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: CustomText(
        text: title,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      forceMaterialTransparency: true,
      leading: isBack ? IconButton(
        icon: const SizedBox(
            child: Icon(
          Icons.arrow_back_ios,
          size: 25,
        )),
        onPressed: () => Get.back(),
        color: Colors.black,
      ) : Container(),
    );
  }
}
