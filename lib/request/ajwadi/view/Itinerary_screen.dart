import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/review_itenrary_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/card_itenrary.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/review_itenrary_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';

class AddItinerary extends StatefulWidget {
  const AddItinerary({super.key, required this.requestId});
  final String requestId;
  @override
  State<AddItinerary> createState() => _AddItineraryState();
}

class _AddItineraryState extends State<AddItinerary> {
  var count = 0;

  var flag = false;
  final requestController = Get.put(RequestController());
  // late ExpandedTileController _controller;

  // List<ItineraryCard> list = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    requestController.itineraryList.add(ItineraryCard(
      requestController: requestController,
      indx: requestController.intinraryCount.value,
    ));
    requestController.intinraryCount++;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    requestController.itineraryList.clear();
    requestController.intinraryCount(0);
    requestController.reviewItenrary.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyBackground,
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 32),
        child: CustomButton(
          onPressed: () {
            Get.to(
              () => ReviewIenraryScreen(
                requestController: requestController,
                requestId: widget.requestId,
              ),
            );
          },
          title: "next".tr,
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 18,
          ),
        ),
      ),
      appBar: CustomAppBar('Itinerary'),
      body: Padding(
        padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomText(
                text:
                    "*At least 3 activities are required to send the itinerary",
                color: almostGrey,
                fontSize: 13,
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() => ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 12,
                    ),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: requestController.reviewItenrary.length,
                    itemBuilder: (context, index) => ReivewItentraryCard(
                      requestController: requestController,
                      indx: index,
                      schedule: requestController.reviewItenrary[index],
                    ),
                  )),
              SizedBox(
                height: 24,
              ),
              Obx(
                () => ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 24,
                        ),
                    itemBuilder: (context, index) {
                      // list[index].indx = index;
                      return requestController.itineraryList[index];
                    },
                    itemCount: requestController.itineraryList.length),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print(requestController.itineraryList.length);
                      if (requestController.intinraryCount >= 1) {
                        // AppUtil.errorToast(context, "you cant add ");
                        return;
                      }
                      requestController.itineraryList.add(ItineraryCard(
                        requestController: requestController,
                        indx: requestController.intinraryCount.value,
                      ));
                      requestController.intinraryCount++;
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(4)),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CustomText(text: 'Add Activity ')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
