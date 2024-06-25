import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    required this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.borderColor,
    this.controller,
    this.enable,
    this.maxLines = 1,
    this.isPassword = false,
    this.height,
    this.textColor,
    this.minLines,
    this.validator = true,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool isPassword;
  final String? hintText;
  final Widget? icon;
  final Widget? prefixIcon, suffixIcon;
  final ValueChanged<String> onChanged;
  final bool? enable;
  final bool validator;
  final int maxLines;
  final int? maxLength;
  final double? height;
  final String? initialValue;
  final Color? textColor, borderColor;
  final List<TextInputFormatter>? inputFormatters;

  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      child: TextFormField(
        initialValue: initialValue,
        inputFormatters: inputFormatters ?? [],
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        readOnly: readOnly,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        cursorColor: const Color(0xFF969696),
        textInputAction: TextInputAction.search,
        enabled: enable,
        validator: validator
            ? (v) {
                if (v!.isEmpty) {
                  return 'fieldRequired'.tr;
                }
                if (v!.trim().length < 8 && isPassword) {
                  return "you must enter at least 8 characters";
                }
                return null;
              }
            : null,
        style: TextStyle(color: textColor, fontFamily: 'Noto Kufi Arabic'),
        decoration: InputDecoration(
          counterStyle: const TextStyle(fontSize: 0, height: 100),
          counterText: '',
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: borderGrey, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: borderColor ?? borderGrey, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: borderColor ?? Colors.black, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: borderColor ?? Colors.black, width: 1)),
          prefixIcon: null == prefixIcon ? null : prefixIcon,
          suffixIcon: null == suffixIcon ? null : suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 16,
              fontFamily: 'HT Rakik',
              color: Color(0xFFB9B8C1),
              fontWeight: FontWeight.w400),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
