import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PriceDecisionCard extends StatefulWidget {
  const PriceDecisionCard({
    Key? key,
    required this.priceController,
  }) : super(key: key);

  final TextEditingController priceController;

  @override
  _PriceDecisionCardState createState() => _PriceDecisionCardState();
}

class _PriceDecisionCardState extends State<PriceDecisionCard> {
  int price = 0;

  void _setPrice(int newPrice) {
    setState(() {
      price = newPrice;
    });
  }

  bool isEditing = false;
  final TextEditingController _priceController = TextEditingController();
  double hidoFee = 0.00;
  double earn = 0.00;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

//  if(widget.priceController.text==''|| widget.priceController.text.isEmpty)
    widget.priceController.text = price.toString();
    //  else
    // _priceController =  widget.priceController ;

    widget.priceController.addListener(_validatePrice);
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_validatePrice);
    super.dispose();
  }

  // void _validatePrice() {
  //   if (!mounted) return; // Check if the widget is still mounted
  //   double price = double.tryParse(widget.priceController.text) ?? 0.0;
  //   if (price < 150) {
  //     setState(() {
  //       errorMessage = AppUtil.rtlDirection2(context)
  //           ? '*الحد الأدنى لسعر التجربة هو 150 ريال سعودي'
  //           : '*The minimum price for an experience is 150 SAR ';
  //     });
  //   } else {
  //     setState(() {
  //       errorMessage = '';
  //     });
  //   }
  //   _updateFees();
  // }
  void _validatePrice() {
    if (!mounted) return; // Check if the widget is still mounted
    String priceText = widget.priceController.text;
    RegExp doubleRegex =
        RegExp(r'^[0-9]*\.[0-9]+$'); // Regular expression to match doubles

    if (doubleRegex.hasMatch(priceText)) {
      setState(() {
        errorMessage = AppUtil.rtlDirection2(context)
            ? '*السعر يجب أن يكون عدد صحيح فقط'
            : '*The price must be an integer value only';
      });
    } else {
      int price = int.tryParse(priceText) ?? 0;
      if (price < 150) {
        setState(() {
          errorMessage = AppUtil.rtlDirection2(context)
              ? '*الحد الأدنى لسعر التجربة هو 150 ريال سعودي'
              : '*The minimum price for an experience is 150 SAR';
        });
      } else {
        setState(() {
          errorMessage = '';
        });
      }
    }
    _updateFees();
  }

  void _updateFees() {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      int price = int.tryParse(widget.priceController.text) ?? 0;
      hidoFee = price * 0.3;
      earn = price - hidoFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'setPrice'.tr,
          color: black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        const SizedBox(height: 2),
        CustomText(
          text: 'changePrice'.tr,
          color: starGreyColor,
          fontSize: 15,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 121,
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorMessage.isNotEmpty ? Colors.red : Colors.white,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3FC7C7C7),
                blurRadius: 15,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/editPin.svg'),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 1),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isEditing)
                      Expanded(
                        child: TextField(
                          controller: widget.priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.all(0), // Optional: Remove padding
                          ),
                          style: const TextStyle(
                            color: Color(0xFF070708),
                            fontSize: 34,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                          onSubmitted: (newValue) {
                            _updateFees();

                            setState(() {
                              isEditing = false;
                            });
                          },
                        ),
                      )
                    else
                      CustomText(
                        text: widget.priceController.text,
                        color: const Color(0xFF070708),
                        fontSize: 34,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: 'sar'.tr,
                      color: const Color(0xFF070708),
                      fontSize: 34,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                        text: 'Perperson'.tr,
                        color: Graytext,
                        fontSize: 12,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 3),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (errorMessage.isNotEmpty && price != 150.0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomText(
              text: errorMessage,
              color: Colors.red,
              fontSize: 14,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 50),
        Container(
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFDCDCE0)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Baseprice'.tr,
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: ' ${widget.priceController.text} ${'sar'.tr}',
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Hidofee'.tr,
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: ' ${hidoFee.toStringAsFixed(2)} ${'sar'.tr}',
                      color: graySmallText,
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              const Divider(
                color: lightGrey,
                thickness: 1,
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Yourearn'.tr,
                      color: const Color(0xFF070708),
                      fontSize: 17,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: ' ${earn.toStringAsFixed(2)} ${'sar'.tr}',
                      textAlign: TextAlign.right,
                      color: const Color(0xFF36B268),
                      fontSize: 17,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
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
