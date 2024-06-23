import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CreditForm extends StatelessWidget {
  const CreditForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Cardholder name",
          fontSize: 17,
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 48,
          child: TextFormField(
            cursorHeight: 20,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Enter the holder name of this card',
              helperStyle: const TextStyle(
                color: borderGrey,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: borderGrey, width: 1)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderGrey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        CustomText(
          text: "Card number",
          fontSize: 17,
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 48,
          child: TextFormField(
            cursorHeight: 20,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12)
            ],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Enter 12 digital card number',
              helperStyle: const TextStyle(
                color: borderGrey,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: borderGrey, width: 1)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderGrey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Expiration Date",
                    fontSize: 17,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 48,
                    width: 171,
                    child: TextFormField(
                      cursorHeight: 20,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12)
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        hintText: 'MM/YYYY',
                        helperStyle: const TextStyle(
                          color: borderGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: borderGrey, width: 1)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderGrey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "CVV",
                    fontSize: 17,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 48,
                    width: 171,
                    child: TextFormField(
                      cursorHeight: 20,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12)
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        hintText: 'CVV',
                        helperStyle: const TextStyle(
                          color: borderGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: borderGrey, width: 1)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderGrey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
