import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';

class ShowRequestWidget extends StatefulWidget {
  final RequestController? requestController;
  const ShowRequestWidget({super.key, required this.requestController});

  @override
  State<ShowRequestWidget> createState() => _ShowRequestWidgetState();
}

class _ShowRequestWidgetState extends State<ShowRequestWidget> {
  List<RequestSchedule>? scheduleList;
  @override
  void initState() {
    super.initState();
    if (widget.requestController?.requestModel.value.offer?[0].schedule !=
        null) {
      scheduleList =
          widget.requestController?.requestModel.value.offer?[0].schedule!;
      getTotal();
    }
  }

  int total = 0;

  getTotal() {
    if (widget.requestController?.requestModel.value.offer?[0].schedule! !=
        null) {
      for (var sch in scheduleList!) {
        total += sch.price ?? 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        left: 21,
        right: 18,
        bottom: 24,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child:
                    widget.requestController?.requestModel.value.senderImage !=
                            null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(widget
                                .requestController!
                                .requestModel
                                .value
                                .senderImage!),
                          )
                        :  CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/app_icon.jpeg'),
                          ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.requestController!.requestModel.value.senderName ?? "",
                style: const TextStyle(
                  color: Color(0xFF1D2129),
                  fontSize: 14,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'checkText'.tr,
            textAlign:TextAlign.center ,
            style: const TextStyle(
              color: colorDarkGrey,
              fontSize: 12,
              fontFamily: 'HT Rakik',
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            children: [
              if (scheduleList != null)
                ...List.generate(
                    scheduleList!.length,
                    (index) => _CustomCheckWidget(
                          isCircle: true,
                          isChecked: true,
                          onTap: null,
                          schedule: scheduleList![index],
                          isLast: index == scheduleList!.length - 1,
                          isBold: !(index == 0 || index == 2),
                        )),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "totalPayment".tr,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: darkBlue,
              fontSize: 20,
              fontFamily: 'HT Rakik',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: ' $total ',
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 20,
                    fontFamily: 'HT Rakik',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(
                  text: 'sar',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 14,
                    fontFamily: 'HT Rakik',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _CustomCheckWidget extends StatelessWidget {
  final RequestSchedule? schedule;
  final bool isChecked;
  final bool isCircle;
  final bool isBold;
  final bool isLast;
  final void Function()? onTap;
  _CustomCheckWidget({
    super.key,
    this.isChecked = true,
    this.isLast = false,
    this.isBold = false,
    this.schedule,
    this.onTap,
    this.isCircle = false,
  });

  TextStyle titleStyle = const TextStyle(
    color: colorDarkGrey,
    fontSize: 14,
    fontFamily: 'HT Rakik',
    fontWeight: FontWeight.w300,
  );
  TextStyle titleBold = const TextStyle(
    color: darkBlue,
    fontSize: 14,
    fontFamily: 'HT Rakik',
    fontWeight: FontWeight.w500,
  );

  TextStyle priceBold = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontFamily: 'HT Rakik',
    fontWeight: FontWeight.w500,
  );

  TextStyle priceStyle = const TextStyle(
    color: darkBlue,
    fontSize: 12,
    fontFamily: 'HT Rakik',
    fontWeight: FontWeight.w300,
  );

  String convertTo12HourFormat(String time) {
    return DateFormat.jm()
        .format(DateTime.parse('2022-01-01' ' ' "$time"))
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          InkWell(
            onTap: onTap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colorGreen, width: 1.5),
                        color: isChecked ? colorGreen : Colors.white,
                      ),
                      child: const Icon(Icons.check,
                          size: 12, color: Colors.white)),
                  const SizedBox(
                    width: 22,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${schedule?.price ?? 0}\n',
                          style: isBold ? priceBold : priceStyle,
                        ),
                        const TextSpan(
                          text: 'للشخص',
                          style: TextStyle(
                            color: colorDarkGrey,
                            fontSize: 8,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule?.scheduleName ?? '',
                        style: isBold ? titleBold : titleStyle,
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      if (schedule?.scheduleTime != null)
                        Row(
                          children: [
                            Text(
                              convertTo12HourFormat(
                                  schedule!.scheduleTime!.from!),
                              style: const TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 10,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Text(
                              " - ",
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 10,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "${convertTo12HourFormat(schedule!.scheduleTime!.to!)} ",
                              style: const TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 10,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        )
                    ],
                  )
                ]),
          ),
          if (!isLast)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 20,
                  height: 32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_divider(), _divider(), _divider()],
                  ),
                ),
              ),
            ),
        ]),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 2,
      height: 8,
      decoration: const BoxDecoration(
        color: colorGreen,
      ),
    );
  }
}
