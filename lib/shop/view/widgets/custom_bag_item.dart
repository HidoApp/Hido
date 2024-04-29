import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBagItem extends StatelessWidget {
  const CustomBagItem({
    super.key,
    required this.image,
    required this.price,
    required this.description,
    required this.quantity,
    required this.onIncrementTap,
    required this.onDecrementTap,
    required this.onDeleteTap,
  });

  final String image;
  final String price;
  final String description;
  final int quantity;
  final VoidCallback onIncrementTap;
  final VoidCallback onDecrementTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.asset('assets/images/$image.png')),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: '$price SAR',
                fontFamily: 'Kufam',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: 233,
                child: CustomText(
                  text: description,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: almostGrey,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 98,
                    height: 36,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: containerGreyColor,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: onIncrementTap,
                          child: SvgPicture.asset('assets/icons/plus.svg'),
                        ),
                        CustomText(
                          text: quantity.toString(),
                          textAlign: TextAlign.center,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kufam',
                        ),
                        InkWell(
                          onTap: onDecrementTap,
                          child: SvgPicture.asset('assets/icons/minus.svg'),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDeleteTap,
                    icon: const Icon(
                      Icons.delete,
                      color: almostGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
