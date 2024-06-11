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
import 'package:intl/intl.dart';

class ReviewIenraryScreen extends StatefulWidget {
  const ReviewIenraryScreen(
      {super.key, required this.requestController, required this.requestId});
  final RequestController requestController;
  final String requestId;
  @override
  State<ReviewIenraryScreen> createState() => _ReviewIenraryScreenState();
}

class _ReviewIenraryScreenState extends State<ReviewIenraryScreen> {
  String convertTime(String time) {
    DateTime dateTime = DateFormat('h:mm a').parse(time);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String ensureSpaceBeforePeriod(String time) {
    if (time.contains('AM') || time.contains('PM')) {
      time = time.replaceAll('AM', ' AM').replaceAll('PM', ' PM');
    }
    return time;
  }

  void convertAllTimes() {
    for (var i = 0; i < widget.requestController.reviewItenrary.length; i++) {
      widget.requestController.reviewItenrary[i].scheduleTime!.to =
          ensureSpaceBeforePeriod(
              widget.requestController.reviewItenrary[i].scheduleTime!.to!);
      widget.requestController.reviewItenrary[i].scheduleTime!.from =
          ensureSpaceBeforePeriod(
              widget.requestController.reviewItenrary[i].scheduleTime!.from!);
      widget.requestController.reviewItenrary[i].scheduleTime!.to = convertTime(
          widget.requestController.reviewItenrary[i].scheduleTime!.to!);
      widget.requestController.reviewItenrary[i].scheduleTime!.from =
          convertTime(
              widget.requestController.reviewItenrary[i].scheduleTime!.from!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        'reviewOffer'.tr,
      ),
      backgroundColor: lightGreyBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Itinerary Details",
              fontSize: width * 0.044,
            ),
            SizedBox(
              height: width * 0.033,
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
                      .toString(),
                ),
                itemCount: widget.requestController.reviewItenrary.length,
              ),
            ),
            const Divider(
              color: almostGrey,
            ),
            Spacer(),
            Obx(
              () => widget.requestController.isRequestAcceptLoading.value
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : CustomButton(
                      onPressed: () async {
                        convertAllTimes();
                        await widget.requestController.requestAccept(
                          id: widget.requestId,
                          requestScheduleList:
                              widget.requestController.reviewItenrary,
                          context: context,
                        );

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
                        size: width * 0.05,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
