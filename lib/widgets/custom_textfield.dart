import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
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
      this.validatorHandle,
      this.onFieldSubmitted,
      this.expand = false,
      this.autovalidateMode,
      this.textInputAction = TextInputAction.done,
      this.verticalHintPadding = 0,
      this.focusNode,
      this.raduis});

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final AutovalidateMode?
      autovalidateMode; // 👈 this controls validation timing
  final bool obscureText;
  final bool readOnly;
  final bool isPassword;
  final String? hintText;
  final Widget? icon;
  final Widget? prefixIcon, suffixIcon;
  final ValueChanged<String> onChanged;
  final bool? enable;
  final bool validator;
  final int? maxLines;
  final int? maxLength;
  final double? height;
  final String? initialValue;
  final Color? textColor, borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validatorHandle;
  final int? minLines;
  final FocusNode? focusNode;
  final double? raduis;
  final bool expand;
  final TextInputAction? textInputAction;
  final double verticalHintPadding;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          expands: expand,
          initialValue: initialValue,
          inputFormatters: inputFormatters ?? [],
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          readOnly: readOnly,
          autovalidateMode: autovalidateMode,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          cursorColor: const Color(0xFF969696),
          textInputAction: textInputAction ?? TextInputAction.done,
          enabled: enable,
          validator: validator
              ? (v) {
                  if (v!.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (v.trim().length < 8 && isPassword) {
                    return "passwordError".tr;
                  }
                  return null;
                }
              : validatorHandle,
          style: TextStyle(
            color: textColor,
            fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
          ),
          decoration: InputDecoration(
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: colorRed, width: 1)),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: colorRed, width: 1)),
            errorStyle: TextStyle(
              color: colorRed,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: verticalHintPadding != 0 ? verticalHintPadding : 12,
                horizontal: 12),
            // const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            counterStyle: const TextStyle(fontSize: 0, height: 100),
            counterText: '',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(raduis ?? 8)),
                borderSide: const BorderSide(color: borderGrey, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(raduis ?? 8)),
                borderSide:
                    BorderSide(color: borderColor ?? borderGrey, width: 1)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(raduis ?? 8)),
                borderSide:
                    BorderSide(color: borderColor ?? borderGrey, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(raduis ?? 8)),
                borderSide:
                    BorderSide(color: borderColor ?? borderGrey, width: 1)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,

            // prefixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                color: Graytext,
                fontWeight: FontWeight.w400),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
