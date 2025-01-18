import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../share/controller/dynamic_link_controller.dart';
import '../utils/app_util.dart';

class ShareWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final controller = Get.find<DynamicLinkController>();
        try {
          final shortLink = await controller.createDynamicLink(
            id: id,
            type: type,
            title: title,
            description: description,
            image: image,
            validTo: validTo,
          );

          final result = await Share.share(shortLink.toString());
          if (result.status == ShareResultStatus.success) {
            if (!context.mounted) return;
            AppUtil.successToast(context, "Share was succes");
          }
        } catch (e) {
          print('Error sharing: $e');
        }
      },
      child: Container(
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
    );
  }
}
