import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(this.title,
      {Key? key,
      this.color = black,
      this.iconColor,
      this.action = false,
      this.onPressedAction,
      this.backgroundColor,
      this.isAjwadi = false,
      this.isBack = false,
      this.isDeleteIcon = false,
      this.isTimer = false})
      : preferredSize = const Size.fromHeight(75.0),
        super(key: key);

  final String title;
  final Color? color;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool action;
  final bool isAjwadi;
  final bool isBack;
  final bool isTimer;
  final VoidCallback? onPressedAction;
  final bool? isDeleteIcon;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(79.0),
        child: Directionality(
            textDirection: AppUtil.rtlDirection2(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: AppBar(
                  forceMaterialTransparency: true,
                  backgroundColor: backgroundColor ?? Colors.transparent,
                  elevation: 0,
                  title: Padding(
                    padding: AppUtil.rtlDirection2(context)
                        ? !isAjwadi
                            ? EdgeInsets.only(
                                top: 12, left: 0, right: 0, bottom: 18)
                            : EdgeInsets.only(
                                top: 12, left: 0, right: 0, bottom: 0)
                        : !isAjwadi
                            ? EdgeInsets.only(
                                top: 16, left: 20, right: 20, bottom: 18)
                            : EdgeInsets.only(
                                top: 16, left: 0, right: 0, bottom: 20),
                    child: CustomText(
                      text: title,
                      color: color ?? black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      fontFamily: 'HT Rakik',
                    ),
                  ),
                  actions: <Widget>[
                    if (!isDeleteIcon!)
                      if (action)
                        Padding(
                          padding: AppUtil.rtlDirection2(context)
                              ? EdgeInsets.only(left: 18, top: 4)
                              : EdgeInsets.only(right: 18, bottom: 4),
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 29,
                              color: color ?? Colors.black,
                            ),
                            tooltip: "more",
                            onPressed: onPressedAction,
                          ),
                        ),
                    if (isDeleteIcon!)
                      Padding(
                        padding: AppUtil.rtlDirection2(context)
                            ? EdgeInsets.only(left: 18, top: 4)
                            : EdgeInsets.only(right: 18, bottom: 4),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            size: 29,
                            color: colorRed,
                          ),
                          tooltip: "more",
                          onPressed: onPressedAction,
                        ),
                      )
                  ],
                  centerTitle: true,
                  leading: !isBack
                      ? Padding(
                          padding: AppUtil.rtlDirection2(context)
                              ? !isAjwadi
                                  ? EdgeInsets.only(bottom: 6, right: 30)
                                  : EdgeInsets.only(top: 9, right: 30)
                              : !isAjwadi
                                  ? EdgeInsets.only(bottom: 6, left: 30, top: 2)
                                  : EdgeInsets.only(
                                      bottom: 23, left: 30, top: 8),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 19,
                              color: iconColor ?? Colors.black,
                            ),
                            onPressed: () {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.of(context).pop();
                                // Get.off(() => TouristBottomBar());
                              });
                            },
                          ),
                        )
                      : const CustomText(text: ''),
                ))));
  }
}
