import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/view/edit_adventure.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';

class CustomSuccessDialog extends StatelessWidget {

   CustomSuccessDialog({
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
             'assets/images/paymentSuccess.gif',width: 38,
           
            ),
            SizedBox(height: 16),
            Text(
               !AppUtil.rtlDirection2(context)
                          ? "Changes have been saved successfully!"
                          : "تم حفظ التغييرات بنجاح ",
              style: TextStyle(fontSize: 14),
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
