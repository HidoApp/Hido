import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        'Driving license',
        isBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "Driving license expiry date",
                fontSize: width * 0.0435,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro'),
            Form(
              key: _formKey,
              //TODO :must change to date picker
              child: CustomTextField(
                hintText: 'Enter Vehicle License ',
                keyboardType: TextInputType.emailAddress,
                validator: false,
                validatorHandle: (vehicle) {},
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
