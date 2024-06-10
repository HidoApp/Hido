import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/Itinerary_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/offline_request.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/request_card.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

bool isSwitched = false;
double cardHight = 200;

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _requestController = Get.put(RequestController());
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _requestController.getRequestList(context: context);
    if (isSwitched) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightGreyBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                CustomText(
                  text: isSwitched ? "Online" : "Offline",
                  color: isSwitched ? colorGreen : colorDarkGrey,
                ),
                const SizedBox(
                  width: 12,
                ),
                FlutterSwitch(
                  height: 30,
                  width: 60,
                  activeColor: colorGreen,
                  value: isSwitched,
                  onToggle: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              ]),
            )
          ],
        ),
        body: //isSwitched ?
            Obx(
          () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _requestController.isRequestListLoading.value
                  ? CircularProgressIndicator.adaptive()
                  : ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                      shrinkWrap: true,
                      itemCount: _requestController.requestList.length,
                      itemBuilder: (context, index) => RequestCard(
                        onReject: () async {
                          _requestController.requestIndex.value = index;
                          bool? reject = await _requestController.requestReject(
                              id: _requestController.requestList[index].id!,
                              context: context);
                          if (reject == true && context.mounted) {
                            await _requestController.getRequestList(
                                context: context);
                          }
                        },
                        request: _requestController.requestList[index],
                      ),
                    )),
        )
        //: const OfflineRequest(),
        );
  }
}
