import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        content: Container(
          width: dialogWidth,
          height: 118,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
                  width: buttonWidth,
                  height: 40,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF37B268)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "mail".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF37B268),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri.parse('tel:0533606069');
                  if (!await launcher.launchUrl(uri)) {
                    debugPrint(
                        "Could not launch the uri"); // because the simulator doesn't have the phone app
                  }
                },
                child: Container(
                  width: 251,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF37B268)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Call",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF37B268),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
