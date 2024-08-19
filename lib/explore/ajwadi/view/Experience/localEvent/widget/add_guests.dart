import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../../services/controller/adventure_controller.dart';

class AddGuests extends StatefulWidget {
  AddGuests({
    Key? key,
  }) : super(key: key);

  @override
  _AddGuestsState createState() => _AddGuestsState();
}

class _AddGuestsState extends State<AddGuests> {
  final EventController _EventController = Get.put(EventController());

  TextEditingController _textField1Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    if (_EventController.seletedSeat.value.toString() != '0')
      _textField1Controller = TextEditingController(
        text: _EventController.seletedSeat.value.toString(),
      );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textField1Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "people".tr,
          color: black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        SizedBox(height: width * 0.02),
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: width * 0.012),
              Container(
                width: double.infinity,
                height: height * 0.063,
                padding: const EdgeInsets.only(left: 6, right: 6),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _textField1Controller,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'seatHint'.tr,
                      hintStyle: TextStyle(
                        color: Graytext,
                        fontSize: 15,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (newValue) => _EventController
                        .seletedSeat.value = int.tryParse(newValue) ?? 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
