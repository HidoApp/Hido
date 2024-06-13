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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    super.initState();
    requestController.itineraryList.add(ItineraryCard(
      requestController: requestController,
      indx: requestController.intinraryCount.value,
    ));
    requestController.intinraryCount++;
  }

  @override
  void dispose() {
    super.dispose();
    requestController.itineraryList.clear();
    requestController.intinraryCount(0);
    requestController.reviewItenrary.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightGreyBackground,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: width * 0.03,
          left: width * 0.04,
          right: width * 0.04,
          bottom: width * 0.08,
        ),
        child: CustomButton(
          onPressed: () {
            if (requestController.reviewItenrary.length < 3) {
              AppUtil.errorToast(context, "atLeastItenrary".tr);
            } else {
              Get.to(
                () => ReviewIenraryScreen(
                  requestController: requestController,
                  requestId: widget.requestId,
                ),
              );
            }
          },
          title: "next".tr,
          icon: Icon(
            AppUtil.rtlDirection2(context)
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
            size: width * 0.046,
          ),
        ),
      ),
      appBar: CustomAppBar(
        'itinerary'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: width * 0.03,
          horizontal: width * 0.04,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomText(
                text: "atLeastItenrary".tr,
                fontWeight: FontWeight.w400,
                color: almostGrey,
                fontSize: width * 0.033,
              ),
              SizedBox(
                height: width * 0.05,
              ),
              Obx(() => ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: width * 0.03,
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
                height: width * 0.06,
              ),
              Obx(
                () => ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                          height: width * 0.06,
                        ),
                    itemBuilder: (context, index) {
                      return requestController.itineraryList[index];
                    },
                    itemCount: requestController.itineraryList.length),
              ),
              SizedBox(
                height: width * 0.06,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (requestController.intinraryCount >= 1) {
                        return;
                      }
                      requestController.itineraryList.add(ItineraryCard(
                        requestController: requestController,
                        indx: requestController.intinraryCount.value,
                      ));
                      requestController.intinraryCount++;
                    },
                    child: Container(
                      height: width * 0.08,
                      width: width * 0.08,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(4)),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: width * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  CustomText(
                    text: "addActicity".tr,
                    fontSize: width * 0.04,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
