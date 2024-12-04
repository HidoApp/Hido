import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionText extends StatefulWidget {
  const VersionText({super.key, this.fromSplash = false});
  final fromSplash;
  @override
  State<VersionText> createState() => _VerionTextState();
}

class _VerionTextState extends State<VersionText> {
  var version = '';
  void getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version = packageInfo.version;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: '${'hidoVer'.tr} $version',
      fontSize: MediaQuery.of(context).size.width * 0.03,
      fontWeight: FontWeight.w400,
      fontFamily: AppUtil.SfFontType(context),
      color: widget.fromSplash ? Colors.white : Graytext,
    );
  }
}
