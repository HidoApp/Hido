import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../services/controller/adventure_controller.dart';

class AddGuests extends StatefulWidget {
  const AddGuests({
    Key? key,
    required this.adventureController,
  }) : super(key: key);

  final AdventureController adventureController;

  @override
  _AddGuestsState createState() => _AddGuestsState();
}

class _AddGuestsState extends State<AddGuests> {
  final TextEditingController _textField1Controller = TextEditingController();
  int? _selectedRadio;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "peopleNo".tr,
          color: black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        SizedBox(
          height: width * 0.02,
        ),
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: width * 0.012,
              ),
              Container(
                width: double.infinity,
                height: height * 0.063,
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    CustomText(
                      text: "persons".tr,
                      fontWeight: FontWeight.w400,
                      color: Graytext,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontSize: 15,
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          if (widget.adventureController.seletedSeat.value >
                              0) {
                            setState(() {
                              widget.adventureController.seletedSeat.value =
                                  widget.adventureController.seletedSeat.value -
                                      1;
                            });
                          }
                        },
                        child: const Icon(Icons.horizontal_rule_outlined,
                            color: Graytext, size: 24)),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomText(
                      text: widget.adventureController.seletedSeat.value
                          .toString(),
                      color: Graytext,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.adventureController.seletedSeat.value =
                                widget.adventureController.seletedSeat.value +
                                    1;
                          });
                        },
                        child:
                            const Icon(Icons.add, color: Graytext, size: 24)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
