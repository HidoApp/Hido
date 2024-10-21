import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomRequestTextField extends StatelessWidget {
  const CustomRequestTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.isWhiteHintText = false,
    this.radius = 12,
    this.hasPrefixIcon = false,
    this.isTourist = false,
    this.hintStyle,
    this.keyboardType,
    this.enabled,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool isWhiteHintText;
  final double radius;
  final bool hasPrefixIcon;
  final bool isTourist;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      cursorColor: Colors.white,
      keyboardType: keyboardType,
      
      inputFormatters: inputFormatters,
      style: const TextStyle(
        color: Colors.black, // Set the text color here
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: hasPrefixIcon && AppUtil.rtlDirection(context)
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 18,
                ),
                child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                    color: isTourist ? const Color(0xff92979E) : colorGreen,
                  ),
                ),
              )
            : null,
        suffixIcon: hasPrefixIcon && AppUtil.rtlDirection2(context)
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 18,
                ),
                child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset('assets/icons/send.svg'),
                ),
              )
            : null,
        hintStyle: hintStyle ??
            TextStyle(
                color: isWhiteHintText ? Colors.white : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: AppUtil.rtlDirection(context)
                    ? 'Noto Kufi Arabic'
                    : 'Kufam'),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isTourist ? const Color(0xffE5E6EB) : darkGrey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorRed),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isTourist ? const Color(0xffE5E6EB) : almostGrey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isTourist ? const Color(0xffE5E6EB) : darkGrey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isTourist ? const Color(0xffE5E6EB) : almostGrey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorRed),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
