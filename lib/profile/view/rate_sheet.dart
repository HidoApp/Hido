import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_order_rate_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRateSheet extends StatefulWidget {
  const OrderRateSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderRateSheet> createState() => _OrderRateSheetState();
}

class _OrderRateSheetState extends State<OrderRateSheet> {
  late double width, height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          //   Navigator.of(context).pop();
        },
        child: GestureDetector(
            child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.9,
                maxChildSize: 1,
                builder: (_, controller) {
                  return DraggableScrollableSheet(
                    maxChildSize: 0.8,
                    expand: false,
                    builder: (_, controller) {
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                  child: Icon(
                                    Icons.keyboard_arrow_up_outlined,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    controller: controller,
                                    itemCount: 3,
                                    separatorBuilder: (_, i) => const SizedBox(
                                      height: 40,
                                    ),
                                    itemBuilder: (_, i) =>
                                        CustomRateOrderCard(),
                                  ),
                                ),
                                Container(
                                  height: height * 0.1,
                                )
                              ],
                            ),
                            Positioned(
                              left: width * 0.04,
                              bottom: height * 0.02,
                              child: CustomButton(
                                title: "Send".tr,
                                onPressed: () {},
                                icon: AppUtil.rtlDirection(context)
                                    ? const Icon(Icons.arrow_back)
                                    : const Icon(Icons.arrow_forward),
                                customWidth: width * 0.9,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                })));
  }
}
