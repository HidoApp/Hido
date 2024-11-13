import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/rate_sheet.dart';
import 'package:ajwad_v4/profile/view/track_sheet.dart';
import 'package:ajwad_v4/widgets/custom_order_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomOrderCard extends StatefulWidget {
  const CustomOrderCard({Key? key, this.isPast = false}) : super(key: key);

  final bool isPast;
  @override
  State<CustomOrderCard> createState() => _CustomOrderCardState();
}

class _CustomOrderCardState extends State<CustomOrderCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              height: 115,
              width: 94,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/product_detail1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: '#162432',
                  textDecoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 2,
                ),
                const CustomText(
                  text: 'SAR 450.00',
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 8,
                ),
                const CustomText(
                  text: '3 item',
                  color: almostGrey,
                ),
                Row(
                  children: [
                    widget.isPast
                        ? CustomOrderButton(
                            onPressed: () {},
                            title: "Re-Order",
                            customWidth: width * 0.28,
                            height: 18,
                          )
                        : CustomOrderButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  // useRootNavigator: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  )),
                                  context: context,
                                  builder: (context) {
                                    return const TrackSheet();
                                  });
                            },
                            title: "Track Order",
                            customWidth: width * 0.28,
                            height: 18,
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    widget.isPast
                        ? CustomOrderButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  //  useRootNavigator: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  )),
                                  context: context,
                                  builder: (context) {
                                    return const OrderRateSheet();
                                  });
                            },
                            title: "Rate",
                            textColor: yellow,
                            borderColor: yellow,
                            buttonColor: Colors.white,
                            customWidth: width * 0.28,
                            height: 18,
                          )
                        : CustomOrderButton(
                            onPressed: () {},
                            title: "Cancel",
                            textColor: colorRed,
                            borderColor: colorRed,
                            buttonColor: Colors.white,
                            customWidth: width * 0.28,
                            height: 18,
                          ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
