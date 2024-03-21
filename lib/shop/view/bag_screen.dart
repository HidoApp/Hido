import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/shop/view/widgets/custom_bag_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({
    super.key,
    this.hasCartItems = true,
  });

  final bool hasCartItems;

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 40),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    AppUtil.rtlDirection(context)
                        ? Icons.arrow_forward
                        : Icons.arrow_back,
                    color: black,
                    size: 26,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'bag'.tr,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
              ],
            ),
          ),
          if (!widget.hasCartItems)
            CustomEmptyWidget(
              title: 'emptyBag'.tr,
              image: 'no_bag',
            )
          else
            SizedBox(
              height: height * 0.4,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(top: 40),
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 27,
                  );
                },
                itemBuilder: (context, index) {
                  return CustomBagItem(
                    image: 'soap',
                    price: '150.00',
                    description: AppUtil.rtlDirection(context)
                        ? 'مزيج فريد من الحلبة واللافندر الطبيعيين'
                        : 'Wooden bedside table featuring a raised design',
                    quantity: quantity,
                    onIncrementTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    onDecrementTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    onDeleteTap: () {},
                  );
                },
              ),
            ),
          if (widget.hasCartItems) const Spacer(),
          if (widget.hasCartItems)
            Container(
              height: height * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'promocode'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: containerGreyColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: colorGreen,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/check.svg'),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CustomText(
                              text: 'available'.tr,
                              fontWeight: FontWeight.w700,
                              color: colorGreen,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        const CustomText(
                          text: 'Aj20',
                          fontFamily: 'Kufam',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DottedSeparator(
                      color: dotGreyColor,
                      height: 0.24,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'total'.tr,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        const CustomText(
                          text: 'SAR 420.50',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'discount'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: almostGrey,
                        ),
                        const CustomText(
                          text: 'SAR 25.00',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: almostGrey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomButton(
                      onPressed: () {
                      //  Get.to(const CheckOutScreen());
                      },
                      title: 'pay'.tr,
                      icon: AppUtil.rtlDirection(context)
                          ? const Icon(Icons.arrow_back)
                          : const Icon(Icons.arrow_forward),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
