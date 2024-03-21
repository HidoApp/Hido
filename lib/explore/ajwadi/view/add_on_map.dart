import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_adventure_on_map.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_event_on_map.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOnMapSheet extends StatefulWidget {
  const AddOnMapSheet({Key? key,required this.token}) : super(key: key);

  final String token;
  @override
  State<AddOnMapSheet> createState() => _AddOnMapSheetState();
}

class _AddOnMapSheetState extends State<AddOnMapSheet> {
  late double width, height;



  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: GestureDetector(
        child: DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 1,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        // bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: height * 0.01,
                        left: width * 0.03,
                        right: width * 0.03,
                        // bottom: height
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_up,
                              size: 25,
                              color: dividerColor,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Align(
                                alignment: !AppUtil.rtlDirection(context)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: CustomText(
                                  text: "add".tr,
                                  color:black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Align(
                                alignment: !AppUtil.rtlDirection(context)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: CustomText(
                                  text: "whatYouWillAdd".tr,
                                  color: colorDarkGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            CustomButton(
                              onPressed: () {
                                Get.off(() => AddAdventureOnMap());
                              },
                              title: "adventures".tr,
                              buttonColor: pink,
                              icon: Icon(Icons.add),
                              iconColor: darkPink,
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            CustomButton(
                              onPressed: () {
                                Get.off(() => AddEventOnMap());
                              },
                              title: "event".tr,
                              buttonColor: lightYellow,
                              icon: Icon(Icons.add),
                              iconColor: gold,
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                          ]),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
