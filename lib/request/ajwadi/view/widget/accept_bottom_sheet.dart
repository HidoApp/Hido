import 'dart:developer';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/widgets/custom_request_text_field.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

bool _isDetailsTapped = false;
DateTime _dateTimeFrom = DateTime.now();
DateTime _dateTimeTo = DateTime.now();

RxString _timeFrom =
    RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
RxString _timeTo =
    RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());

Future<void> showAcceptBottomSheet(
    {required RequestController requestController,
    required String? requestID,
    required double width,
    required double height,
    required RequestModel request,
    required BuildContext context}) async {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            width: width,
            height: height * 0.85,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              _isDetailsTapped = !_isDetailsTapped;
                            });
                          },
                          title: CustomText(
                            text: 'tripDetails'.tr,
                            color: darkBlue,
                          ),
                          trailing: Icon(
                            _isDetailsTapped
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: darkBlue,
                            size: 24,
                          ),
                        ),
                        if (_isDetailsTapped)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                minLeadingWidth: 0,
                                horizontalTitleGap: 8,
                                title: CustomText(
                                  text:
                                      ' ${request.booking!.guestNumber} ${'guests'.tr}',
                                  color: darkBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SvgPicture.asset(
                                    'assets/icons/guests.svg',
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              ListTile(
                                minVerticalPadding: 0,
                                minLeadingWidth: 0,
                                horizontalTitleGap: 8,
                                title: CustomText(
                                  text:
                                      '${request.booking!.date!.substring(0, 10)}',
                                  color: darkBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SvgPicture.asset(
                                    'assets/icons/date.svg',
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              ListTile(
                                minVerticalPadding: 0,
                                minLeadingWidth: 0,
                                horizontalTitleGap: 8,
                                title: CustomText(
                                  text: request.booking!.vehicleType!,
                                  color: darkBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                                leading: SvgPicture.asset(
                                  'assets/icons/car_type_icon.svg',
                                  color: darkBlue,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  CustomText(
                    text: 'writeTripSchedule'.tr,
                    color: darkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                          shrinkWrap: true,
                          itemCount:
                              requestController.requestScheduleList.length,
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 20,
                              color: Colors.grey,
                            );
                          },
                          itemBuilder: (context, index) {
                            var scheduleList =
                                requestController.requestScheduleList;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomRequestTextField(
                                        controller: TextEditingController(
                                            text: scheduleList[index]
                                                    .scheduleName ??
                                                ""),
                                        isWhiteHintText: false,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                AppUtil.rtlDirection(context)
                                                    ? 'Noto Kufi Arabic'
                                                    : 'Kufam'),
                                        hintText: 'adventureName'.tr,
                                        onChanged: (value) {
                                          requestController
                                              .requestScheduleList[index]
                                              .scheduleName = value;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CustomRequestTextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'-?[0-9]')),
                                        ],
                                        controller: TextEditingController(
                                            text: scheduleList[index].price ==
                                                    null
                                                ? ''
                                                : "${scheduleList[index].price}"),
                                        isWhiteHintText: false,
                                        hintText: 'price'.tr,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                AppUtil.rtlDirection(context)
                                                    ? 'Noto Kufi Arabic'
                                                    : 'Kufam'),
                                        onChanged: (value) {
                                          if (value.trim() == "") {
                                            requestController
                                                .requestScheduleList[index]
                                                .price = 0;
                                            return;
                                          }

                                          requestController
                                              .requestScheduleList[index]
                                              .price = int.tryParse(value) ?? 0;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // From
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await DatePickerBdaya.showTimePicker(
                                            context,
                                            showTitleActions: true,
                                            currentTime: _dateTimeFrom,
                                            onConfirm: (time) {
                                              setState(() {
                                                _dateTimeFrom = time;
                                                _timeFrom.value =
                                                    DateFormat('HH:mm:ss')
                                                        .format(_dateTimeFrom);
                                                log("   timeTo.value  ${_timeFrom.value}");
                                                requestController
                                                    .requestScheduleList[index]
                                                    .scheduleTime!
                                                    .from = _timeFrom.value;
                                                log("to ${requestController.requestScheduleList[index].scheduleTime!.from}");
                                              });
                                            },
                                          );
                                        },
                                        child: CustomRequestTextField(
                                          enabled: false,
                                          controller: TextEditingController(
                                            text: scheduleList[index]
                                                        .scheduleTime
                                                        ?.from ==
                                                    null
                                                ? 'From'.tr
                                                : "${'From'.tr} : ${scheduleList[index].scheduleTime!.from!.substring(0, 5)} ",
                                          ),
                                          isWhiteHintText: false,
                                          hintText: 'From'.tr,
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  AppUtil.rtlDirection(context)
                                                      ? 'Noto Kufi Arabic'
                                                      : 'Kufam'),
                                          onChanged: (value) {
                                            requestController
                                                .requestScheduleList[index]
                                                .scheduleTime!
                                                .from = value;
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    // To
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await DatePickerBdaya.showTimePicker(
                                            context,
                                            showTitleActions: true,
                                            currentTime: _dateTimeTo,
                                            onConfirm: (time) {
                                              setState(() {
                                                _dateTimeTo = time;
                                                _timeTo.value =
                                                    DateFormat('HH:mm:ss')
                                                        .format(_dateTimeTo);
                                                log("   timeTo.value  ${_timeTo.value}");
                                                requestController
                                                    .requestScheduleList[index]
                                                    .scheduleTime!
                                                    .to = _timeTo.value;
                                                log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                                              });
                                            },
                                          );
                                        },
                                        child: CustomRequestTextField(
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: scheduleList[index]
                                                          .scheduleTime
                                                          ?.to ==
                                                      null
                                                  ? 'To'.tr
                                                  : "${'To'.tr} : ${scheduleList[index].scheduleTime!.to!.substring(0, 5)} "),
                                          isWhiteHintText: false,
                                          hintText: 'To'.tr,
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  AppUtil.rtlDirection(context)
                                                      ? 'Noto Kufi Arabic'
                                                      : 'Kufam'),
                                          onChanged: (value) {
                                            requestController
                                                .requestScheduleList[index]
                                                .scheduleTime!
                                                .to = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  InkWell(
                    onTap: () {
                      requestController.requestScheduleList
                          .add(RequestSchedule(scheduleTime: ScheduleTime()));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/plus.svg'),
                        const SizedBox(width: 10),
                        CustomText(
                          text: 'addNewAdventure'.tr,
                          color: darkBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Obx(
                    () => requestController.isRequestAcceptLoading.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : CustomButton(
                            onPressed: () async {
                              var scheduleList =
                                  requestController.requestScheduleList;
                              // add Validation
                              if (scheduleList.isEmpty) {
                                Get.showSnackbar(GetSnackBar(
                                  message: 'addAdventure'.tr,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ));
                                log("addAdventure");
                                return;
                              }

                              for (var schedule in scheduleList) {
                                if (schedule.scheduleName == null) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: 'addAdventureName'.tr,
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ));
                                  log("addAdventureName");
                                  return;
                                }
                                if (schedule.scheduleTime?.from == null) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: 'addAdventureFrom'.tr,
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ));
                                  log("addAdventureFrom");
                                  return;
                                }
                                if (schedule.scheduleTime?.to == null) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: 'addAdventureTo'.tr,
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ));
                                  log("addAdventureTo");
                                  return;
                                }
                                if (schedule.price == null) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: 'addAdventurePrice'.tr,
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ));
                                  log("addAdventurePrice");
                                  return;
                                }
                              }

                              if (requestID != null) {
                                await requestController.requestAccept(
                                    id: requestID,
                                    requestScheduleList:
                                        requestController.requestScheduleList,
                                    context: context);

                                if (requestController.isRequestAccept.value ==
                                    true) {
                                  if (context.mounted) {
                                    AppUtil.successToast(context, 'done'.tr);
                                    await requestController.getRequestList(
                                        context: context);
                                    Get.back();
                                  }
                                }
                              }
                            },
                            title: 'send'.tr,
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 20,
                            ),
                          ),
                  )
                ],
              ),
            ),
          );
        });
      });
}
