import 'package:ajwad_v4/auth/widget/countdown_timer.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/widgets/offer_timer.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TimerAppBar(
    this.title, {
    Key? key,
    this.color = black,
    this.iconColor,
    this.action = false,
    this.onPressedAction,
    this.backgroundColor,
    this.isAjwadi = false,
    this.isBack = false,
  })  : preferredSize = const Size.fromHeight(75.0),
        super(key: key);
  final String title;
  final Color? color;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool action;
  final bool isAjwadi;
  final bool isBack;
  final VoidCallback? onPressedAction;
  @override
  final Size preferredSize;
  @override
  State<TimerAppBar> createState() => _TimerAppBarState();
}

class _TimerAppBarState extends State<TimerAppBar> {
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

            backgroundColor: widget.backgroundColor ?? Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: AppUtil.rtlDirection2(context)
                  ? !widget.isAjwadi
                      ? const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 18)
                      : const EdgeInsets.only(
                          top: 12, left: 0, right: 0, bottom: 0)
                  : !widget.isAjwadi
                      ? const EdgeInsets.only(
                          top: 0, left: 20, right: 20, bottom: 18)
                      : const EdgeInsets.only(
                          top: 16, left: 0, right: 0, bottom: 20),
              child: CustomText(
                text: widget.title,
                color: widget.color ?? black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
                fontFamily: 'HT Rakik',
              ),
            ),
            actions: <Widget>[
              const Padding(
                padding: EdgeInsets.all(4),
                child: OfferTimer(),
              ),
              if (widget.action)
                Padding(
                  padding: EdgeInsets.all(4),
                  child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      size: 29,
                      color: widget.color ?? Colors.black,
                    ),
                    tooltip: "more",
                    onPressed: widget.onPressedAction,
                  ),
                ),
            ], //
            centerTitle: true,

            leading: !widget.isBack
                ? Padding(
                    padding: AppUtil.rtlDirection2(context)
                        ? !widget.isAjwadi
                            ? EdgeInsets.only(bottom: 23, right: 30)
                            : EdgeInsets.only(bottom: 23, left: 30)
                        : !widget.isAjwadi
                            ? EdgeInsets.only(bottom: 23, left: 30, top: 2)
                            : EdgeInsets.only(bottom: 23, left: 30, top: 8),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 19,
                        color: widget.iconColor ?? Colors.black,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  )
                : const Text(''),
          ),
        ),
      ),
    );
  }
}
