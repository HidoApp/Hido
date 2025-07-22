import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/bottom_bar/local/view/local_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/local/controllers/request_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/itenrary_review_tile.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  // import 'package:intl/intl.dart';

  String convertTime(String time) {
    time = time.trim().replaceAll(RegExp(r'\s+'), ' ');
    final inputFormat = DateFormat('h:mma'); // Allow leading zeros for hours
    final outputFormat = DateFormat('HH:mm:ss');

    DateTime dateTime = inputFormat.parse(time);
    return outputFormat.format(dateTime);
  }

  void convertAllTimes() {
    for (var i = 0; i < widget.requestController.reviewItenrary.length; i++) {
      String convertedTo = convertTime(
          widget.requestController.reviewItenrary[i].scheduleTime!.to!);
      if (convertedTo.isNotEmpty) {
        widget.requestController.reviewItenrary[i].scheduleTime!.to =
            convertedTo;
      }
      widget.requestController.reviewItenrary[i].scheduleTime!.from =
          convertTime(
              widget.requestController.reviewItenrary[i].scheduleTime!.from!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: CustomAppBar(
        'reviewItenrary'.tr,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: width * 0.03,
          left: width * 0.04,
          right: width * 0.04,
          bottom: width * 0.08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "ItineraryDetails".tr,
              fontSize: width * 0.044,
              color: black,
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
            SizedBox(
              height: width * 0.05,
            ),
            const Divider(
              color: lightGrey,
            ),
            const Spacer(),
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
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                          'assets/images/paymentSuccess.gif',
                                          width: 38),
                                      CustomText(
                                        text: "offerSent".tr,
                                        fontSize: width * 0.038,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).then((val) {
                              AmplitudeService.amplitude.track(BaseEvent(
                                'Local send itenrary successfully',
                              ));
                              Get.offAll(() => const LocalBottomBar());
                            });
                          } else {
                            AmplitudeService.amplitude.track(BaseEvent(
                              'Local faild to send itenrary',
                            ));
                            // AppUtil.errorToast(context, 'error'.tr);
                          }
                        }
                      },
                      title: 'send'.tr,
                      icon: Icon(
                        AppUtil.rtlDirection2(context)
                            ? Icons.arrow_back_ios
                            : Icons.arrow_forward_ios,
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
