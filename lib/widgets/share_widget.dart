import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../share/controller/dynamic_link_controller.dart';
import '../utils/app_util.dart';

class ShareWidget extends StatefulWidget {
  final String id;
  final String type;
  final String? title;
  final String? description;
  final String? image;
  final String validTo;

  const ShareWidget({
    Key? key,
    required this.id,
    required this.type,
    required this.validTo,
    this.title,
    this.description,
    this.image,
  }) : super(key: key);

  @override
  State<ShareWidget> createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  final controller = Get.find<DynamicLinkController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          // Get today's date
          DateTime today = DateTime.now();

          // Get the date after one month
          DateTime oneMonthLater = DateTime(
            today.year,
            today.month + 1,
            today.day,
            today.hour,
            today.minute,
            today.second,
            today.millisecond,
            today.microsecond,
          ).toUtc();

          // Format as ISO 8601 string
          String formattedDate = oneMonthLater.toIso8601String();
          log(formattedDate);
          log(widget.validTo);
          final shortLink = await controller.createDynamicLink(
            context: context,
            id: widget.id,
            type: widget.type,
            title: widget.title,
            description: widget.description,
            image: widget.image,
            validTo: widget.validTo.isEmpty ? formattedDate : widget.validTo,
          );

          final result = await Share.share(shortLink.toString());
          if (result.status == ShareResultStatus.success) {
            if (!context.mounted) return;
            AppUtil.successToast(context, "Share was succes");
          }
        } catch (e) {
          log('Error sharing: $e');
        }
      },
      child: Obx(
        () => controller.isCreateLinkLoading.value
            ? CircularProgressIndicator.adaptive()
            : Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/icons/share.svg",
                  height: 27,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
