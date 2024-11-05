import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../constants/colors.dart';
import '../../utils/app_util.dart';
import '../../widgets/custom_text.dart';

class ContactDialog extends StatelessWidget {
  final double dialogWidth;
  final double buttonWidth;

  const ContactDialog({
    Key? key,
    required this.dialogWidth,
    required this.buttonWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        content: Container(
          width: double.infinity,

          //  height:  AppUtil.rtlDirection2(context)?170: 155,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              CustomText(
                textAlign: TextAlign.center,
                color: Color(0xFF070708),
                fontSize: 15,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                text: AppUtil.rtlDirection2(context)
                    ? "نعتذر عن أي مشكلة واجهتك "
                    : "Contact our support team via email or call for assistance. We're here to help!",
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri.parse(
                    'mailto:info@hido.app?subject=Hido tourists complaint&body=Hi, We are Hido Team',
                  );
                  if (!await launcher.launchUrl(uri)) {
                    debugPrint(
                        "Could not launch the uri"); // because the simulator doesn't have the email app
                  }
                },
                child: Container(
                  //  height:34,
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: "mail".tr,
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri.parse('tel:0533606069');
                  if (!await launcher.launchUrl(uri)) {
                    debugPrint(
                        "Could not launch the uri"); // because the simulator doesn't have the phone app
                  }
                },
                child: Container(
                    width: double.infinity,
                    // height: 34,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF37B268),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomText(
                        textAlign: TextAlign.center,
                        fontSize: 15,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF37B268),
                        text:
                            AppUtil.rtlDirection2(context) ? 'اتصل' : 'Call')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
