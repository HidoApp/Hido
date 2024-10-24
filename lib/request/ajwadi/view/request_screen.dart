import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/accept_bottom_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_request_item.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _requestController = Get.put(RequestController());

  @override
  void initState() {
    super.initState();
    _requestController.getRequestList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              right: 24,
              left: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'request'.tr,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
                InkWell(
                  // onTap: () => showBottomSheet(width, height),
                  child: SvgPicture.asset('assets/icons/more.svg'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          Expanded(
            child: Obx(
              () => _requestController.isRequestListLoading.value == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : (_requestController.requestList.isEmpty ||
                          _requestController.requestList == [])
                      ? Center(
                          child: CustomText(
                            text: "No_Requests".tr,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                        )
                      : Stack(
                          children: [
                            ListView.separated(
                                shrinkWrap: true,
                                itemCount:
                                    _requestController.requestList.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 22,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  DateTime myDate = DateTime.parse(
                                      _requestController.requestList[index].date
                                          .toString());
                                  var time = DateFormat.jm().format(myDate);

                                  return CustomRequestItem(
                                      index: index,
                                      offer: _requestController
                                          .requestList[index].offer,
                                      isChat: (_requestController
                                                  .requestList[index]
                                                  .orderStatus ==
                                              "ACCEPTED" ||
                                          // ? ==== Have Offer =====
                                          (_requestController.requestList[index]
                                                      .offer !=
                                                  null &&
                                              _requestController
                                                  .requestList[index]
                                                  .offer!
                                                  .isNotEmpty)),
                                      status: _requestController
                                          .requestList[index].orderStatus,
                                      chatId: _requestController
                                          .requestList[index].chatId,
                                      requestModel:
                                          _requestController.requestList[index],
                                      requestController: _requestController,
                                      onPressedAccept: () async {
                                        _requestController.requestScheduleList([
                                          RequestSchedule(
                                              scheduleTime: ScheduleTime())
                                        ]);
                                        final request = await _requestController
                                            .getRequestById(
                                                context: context,
                                                requestId: _requestController
                                                    .requestList[index].id!);

                                        await showAcceptBottomSheet(
                                            width: width,
                                            height: height,
                                            request: request!,
                                            requestController:
                                                _requestController,
                                            requestID: _requestController
                                                .requestList[index].id,
                                            context: context);
                                      },
                                      onPressedReject: () async {
                                        _requestController.requestIndex.value =
                                            index;
                                        bool? reject = await _requestController
                                            .requestReject(
                                                id: _requestController
                                                    .requestList[index].id!,
                                                context: context);
                                        if (reject == true && context.mounted) {
                                          await _requestController
                                              .getRequestList(context: context);
                                        }
                                      },
                                      requestId: _requestController
                                          .requestList[index].id!,
                                      senderName: _requestController
                                              .requestList[index].senderName ??
                                          "",
                                      requestName: AppUtil.rtlDirection2(context)
                                          ? _requestController
                                                  .requestList[index]
                                                  .requestName!
                                                  .nameAr ??
                                              ""
                                          : _requestController
                                                  .requestList[index]
                                                  .requestName!
                                                  .nameEn ??
                                              "",
                                      imageUrl: null,
                                      time: time.toString());
                                }),
                            if (_requestController
                                .isGetRequestByIdLoading.value)
                              Container(
                                height: height,
                                width: width,
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              )
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
