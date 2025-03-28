import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_chat_card.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MessagesScreen extends StatefulWidget {
  final ProfileController profileController;
  const MessagesScreen({super.key, required this.profileController});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.profileController.getUserChats(context: context);
  }

  OfferController offerController = Get.put(OfferController());

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        "massages".tr,
        color: black,
      ),
      body: SafeArea(
        child: Obx(
          () => SizedBox(
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                      enabled: widget.profileController.isChatLoading.value,
                      child: widget.profileController.chatList.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: width * 0.5,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: CustomEmptyWidget(
                                      title: 'noMessages'.tr,
                                      image: 'noCommunication',
                                      subtitle: 'noMessagesSub'.tr,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                                  widget.profileController.chatList.length,
                              separatorBuilder: (context, index) {
                                return const Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Divider(
                                        color: lightGrey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              },
                              itemBuilder: (context, index) {
                                //
                                return CustomChatCard(
                                  chatModel:
                                      widget.profileController.chatList[index],
                                );
                              })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
