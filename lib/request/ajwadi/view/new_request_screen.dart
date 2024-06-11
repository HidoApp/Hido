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

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _requestController = Get.put(RequestController());

  @override
  void initState() {
    super.initState();
    _requestController.getRequestList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  text: isSwitched ? "Online" : "Offline",
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
      body: Obx(
        () => Padding(
          padding: EdgeInsets.only(
              left: width * 0.04, right: width * 0.04, top: width * 0.03),
          child: _requestController.isRequestListLoading.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: width * 0.03,
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
                ),
        ),
      ),
      // : const OfflineRequest(),
    );
  }
}
