import 'dart:developer';

import 'package:ajwad_v4/share/services/share_services.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatelessWidget {
  const ShareWidget({super.key, required this.id, required this.type});
  final String id;
  final String type;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final link = await ShareServices.generateLink(viewId: id, type: type);
        log(link.toString());
        final result = await Share.share(link.toString());
        if (result.status == ShareResultStatus.success) {
          if (!context.mounted) return;
          AppUtil.successToast(context, "Share was succes");
        }
      },
      child: Container(
          width: 35,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20000000298023224),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/icons/share.svg",
            height: 28,
            color: Colors.white,
          )),
    );
  }
}