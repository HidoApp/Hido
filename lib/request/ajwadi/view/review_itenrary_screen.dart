import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/itenrary_review_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ReviewIenraryScreen extends StatefulWidget {
  const ReviewIenraryScreen(
      {super.key, required this.requestController, required this.requestId});
  final RequestController requestController;
  final String requestId;
  @override
  State<ReviewIenraryScreen> createState() => _ReviewIenraryScreenState();
}

class _ReviewIenraryScreenState extends State<ReviewIenraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'reviewOffer'.tr,
      ),
      backgroundColor: lightGreyBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Itinerary Details",
              fontSize: 17,
            ),
            SizedBox(
              height: 11,
            ),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => ReviewItenraryTile(
                    title: widget
                        .requestController.reviewItenrary[index].scheduleName!,
                    timeTo: widget.requestController.reviewItenrary[index]
                        .scheduleTime!.to!,
                    timeFrom: widget.requestController.reviewItenrary[index]
                        .scheduleTime!.from!,
                    price: widget.requestController.reviewItenrary[index].price
                        .toString()),
                itemCount: widget.requestController.reviewItenrary.length,
              ),
            ),
            const Divider(
              color: almostGrey,
            ),
            Spacer(),
            Obx(
              () => widget.requestController.isRequestAcceptLoading.value
                  ? CircularProgressIndicator.adaptive()
                  : CustomButton(
                      onPressed: () async {
                        await widget.requestController.requestAccept(
                            id: widget.requestId,
                            requestScheduleList:
                                widget.requestController.reviewItenrary,
                            context: context);

                        if (widget.requestController.isRequestAccept.value) {
                          if (context.mounted) {
                            AppUtil.successToast(context, 'done'.tr);
                            await widget.requestController
                                .getRequestList(context: context);
                            Get.offAll(() => const AjwadiBottomBar());
                          } else {
                            AppUtil.errorToast(context, 'error'.tr);
                          }
                        }
                      },
                      title: 'send'.tr,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
