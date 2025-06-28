import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/include_card.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/review_include_card.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final EventController _eventController = Get.put(EventController());
  @override
  void initState() {
    super.initState();
    widget.priceController.text = '0'; // Assuming price is initially 0
    widget.priceController.addListener(_validatePrice);
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_validatePrice);
    super.dispose();
  }

  void _validatePrice() {
    if (!mounted) return;
    String priceText = widget.priceController.text;
    RegExp doubleRegex =
        RegExp(r'^[0-9]*\.[0-9]+$'); // Regular expression to match doubles

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (doubleRegex.hasMatch(priceText)) {
        setState(() {
          errorMessage = AppUtil.rtlDirection2(context)
              ? '*السعر يجب أن يكون عدد صحيح فقط'
              : '*The price must be an integer value only';
        });
        return;
      } else {
        setState(() {
          errorMessage = '';
        });
      }
      _updateFees();
    });
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
    final width = MediaQuery.sizeOf(context).width;

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
          // height: 121,
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
            bottom: 30,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorMessage.isNotEmpty ? colorRed : borderGreyColor,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                focusColor: null,
                color: null,
                highlightColor: null,
                splashColor: null,
                disabledColor: null,
                icon: SvgPicture.asset('assets/icons/editPin.svg'),
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
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
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
                          child: TextField(
                            controller: widget.priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                              color: black,
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
                        ),
                      )
                    else
                      CustomText(
                        text: widget.priceController.text,
                        color: black,
                        fontSize: 34,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: 'sar'.tr,
                      color: black,
                      fontSize: 34,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                        text: 'Perperson'.tr,
                        color: black,
                        fontSize: 15,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 2.1),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CustomText(
              text: errorMessage,
              color: colorRed,
              fontSize: 11,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 12),
        Container(
          // height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: borderGreyColor),
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
                height: 6,
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
              const Divider(
                color: lightGrey,
                thickness: 1,
              ),
              const SizedBox(
                height: 2,
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
                      fontWeight: FontWeight.w400,
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
              const SizedBox(
                height: 2,
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.01,
                  top: width * 0.055,
                  // bottom: width * 0.050,
                  right: width * 0.01),
              child: CustomText(
                text: 'priceInclude'.tr,
                color: black,
                fontSize: 17,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: width * 0.020,
            ),
            CustomText(
              text: 'priceIncludeDes'.tr,
              textAlign: TextAlign.right,
              color: const Color(0xFFB0B0B0) /* text-textTertiary */,
              fontSize: 15,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
            ),
            // SizedBox(height: width * 0.05),
            SizedBox(
              height: width * 0.050,
            ),
            Obx(
              () => ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: width * 0.02,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _eventController.reviewincludeItenrary.length,
                itemBuilder: (context, index) => ReivewIncludeCard(
                  indx: index,
                  include: _eventController.reviewincludeItenrary[index],
                  experienceController: _eventController,
                ),
              ),
            ),
            Obx(() => _eventController.reviewincludeItenrary.isNotEmpty
                ? SizedBox(
                    height: width * 0.050,
                  )
                : const SizedBox.shrink()),

            Obx(() => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: width * 0.06),
                  itemCount: _eventController.includeList.length,
                  itemBuilder: (context, index) {
                    return _eventController.includeList[index];
                  },
                )),

            // Add Button
            GestureDetector(
              onTap: () {
                if (_eventController.includeCount >= 1) {
                  return;
                }
                _eventController.includeList.add(
                  IncludeCard(
                    indx: _eventController.includeCount.value,
                    experienceController: _eventController,
                  ),
                );
                _eventController.includeCount++;
              },
              child: Obx(
                () => Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.01,
                      top: _eventController.includeList.isEmpty
                          ? 0
                          : width * 0.050,
                      bottom: width * 0.06,
                      right: width * 0.01),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // height: width * 0.06,
                        // width: width * 0.06,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: colorGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: width * 0.06,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      CustomText(
                        text: "addNewPoint".tr,
                        fontSize: width * 0.038,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: width * 0.06),
          ],
        )
      ],
    );
  }
}
