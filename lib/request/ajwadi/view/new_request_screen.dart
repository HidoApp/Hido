import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/request_card.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

bool isSwitched = true;

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _requestController = Get.put(RequestController());

  @override
  void initState() {
    super.initState();
    _requestController.getRequestList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Obx(
      () => Skeletonizer(
        ignorePointers: true,
        enabled: _requestController.isRequestListLoading.value,
        child: Scaffold(
            backgroundColor: lightGreyBackground,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Row(
                    children: [
                      CustomText(
                        text: isSwitched ? "online".tr : "offline".tr,
                        color: isSwitched ? colorGreen : colorDarkGrey,
                      ),
                      SizedBox(width: width * 0.03),
                      FlutterSwitch(
                        height: width * 0.08,
                        width: width * 0.15,
                        activeColor: colorGreen,
                        value: isSwitched,
                        onToggle: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await _requestController.getRequestList(context: context);
              },
              child: isSwitched
                  ? Obx(
                      () => Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.04,
                            right: width * 0.04,
                            top: width * 0.03),
                        child: _requestController.requestList.isNotEmpty
                            ? ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: width * 0.03,
                                ),
                                shrinkWrap: true,
                                itemCount:
                                    _requestController.requestList.length,
                                itemBuilder: (context, index) => RequestCard(
                                  onReject: () async {
                                    _requestController.requestIndex.value =
                                        index;
                                    final id = _requestController
                                        .requestList[index].id!;
                                    bool? reject =
                                        await _requestController.requestReject(
                                            id: _requestController
                                                .requestList[index].id!,
                                            context: context);
                                    if (reject!) {
                                      AmplitudeService.amplitude
                                          .track(BaseEvent(
                                        'Local reject this request $id ',
                                      ));
                                      _requestController.requestList.removeAt(
                                          _requestController
                                              .requestIndex.value);

                                      // await _requestController.getRequestList(
                                      //     context: context);
                                    }
                                  },
                                  index: index,
                                  request:
                                      _requestController.requestList[index],
                                  requestController: _requestController,
                                ),
                              )
                            : Center(
                                child: ListView(shrinkWrap: true, children: [
                                  CustomEmptyWidget(
                                    title: "No_Requests".tr,
                                    image: "emptyRequest",
                                    subtitle: 'noRequestsText'.tr,
                                  ),
                                ]),
                              ),

                        // : const EmptyRequest(),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: width * 0.03),
                      child: Center(
                        child: CustomEmptyWidget(
                          title: "offline".tr,
                          image: "offline",
                          subtitle: 'offlineText'.tr,
                        ),
                      ),
                    ),
            )
            //const OfflineRequest(),
            ),
      ),
    );
  }
}
