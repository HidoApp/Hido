import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOTPField extends StatelessWidget {
  const CustomOTPField({
    super.key,
    required this.validator,
    required this.onChanged,
    required this.formatter,
    required this.hint,
    this.keyboardType,
  });

  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final TextInputFormatter formatter;
  final TextInputType? keyboardType;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 70,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        //  autofocus: true,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        validator: validator,
        textInputAction: TextInputAction.next,
        cursorColor: const Color(0xFF969696),
        cursorHeight: 10,
        decoration: InputDecoration(
          //   errorText: '*',
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: borderGrey, width: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: colorGreen,
                width: 0.9,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: colorDarkRed,
                width: 0.9,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: colorDarkRed,
                width: 0.9,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
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
          hintText: hint,
          helperText: ' ',
          hintStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.038,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              color: Graytext,
              fontWeight: FontWeight.w400),
        ),
        style: const TextStyle(color: colorGreen, fontSize: 15),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          formatter,
          // FilteringTextInputFormatter.allow(
          //     RegExp(r'[0-9]')), // English numbers only
        ],
        onChanged: onChanged,
      ),
    );
  }
}
