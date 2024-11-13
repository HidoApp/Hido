import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSuccessDialog extends StatelessWidget {
  const CustomSuccessDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 350,
        height: 110, // Custom height
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/paymentSuccess.gif',
              width: 38,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: !AppUtil.rtlDirection2(context)
                  ? "Changes have been saved successfully!"
                  : "تم حفظ التغييرات بنجاح ",
              textDirection: AppUtil.rtlDirection2(context)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}
