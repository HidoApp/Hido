import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({Key? key, this.boxColor}) : super(key: key);
  final boxColor ;


  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}



class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        height: 22,
        width: 22,
        //margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: dividerColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color:  isChecked ? widget.boxColor :Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
