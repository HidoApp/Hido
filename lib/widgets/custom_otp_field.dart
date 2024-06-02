import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOTPField extends StatelessWidget {
  const CustomOTPField({
    super.key,
    required this.onChanged,
    this.validator = true,
    this.isAjwadi = false,
  });

  final ValueChanged<String> onChanged;
  final bool validator;
  final bool isAjwadi;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 57,
      height: 95,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        autofocus: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        validator: validator
            ? (v) {
                if (v!.isEmpty) {
                  return '*';
                }
                return null;
              }
            : null,
        textInputAction: TextInputAction.next,
        cursorColor: const Color(0xFF969696),
        decoration: const InputDecoration(
          //   errorText: '*',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorGreen,
                width: 0.9,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorDarkRed,
                width: 0.9,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorDarkRed,
                width: 0.9,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          // border: OutlineInputBorder(
          //   borderRadius:BorderRadius.only(
          //   topLeft: Radius.circular(5),
          //   topRight:  Radius.circular(45),
          //   bottomLeft:  Radius.circular(45),
          //   bottomRight:  Radius.circular(45),
          // )
          //
          //   ,),
          hintText: "",
          helperText: ' ',
        ),
        style: TextStyle(color: colorGreen, fontSize: 23),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
      ),
    );
  }
}
