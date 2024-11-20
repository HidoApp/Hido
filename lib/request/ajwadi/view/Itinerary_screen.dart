import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/review_itenrary_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/card_itenrary.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/review_itenrary_card.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';
import 'package:ajwad_v4/services/view/widgets/itenrary_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddItinerary extends StatefulWidget {
  const AddItinerary({super.key, required this.requestId, this.booking});
  final String requestId;
  final Booking? booking;
  @override
  State<AddItinerary> createState() => _AddItineraryState();
}

class _AddItineraryState extends State<AddItinerary> {
  var count = 0;
  var flag = false;
  final requestController = Get.put(RequestController());
  late ExpandedTileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpandedTileController(isExpanded: false);
    // requestController.itineraryList.add(ItineraryCard(
    //   requestController: requestController,
    //   indx: requestController.intinraryCount.value,
    // ));
    // requestController.intinraryCount++;
  }

  @override
  void dispose() {
    super.dispose();
    // requestController.itineraryList.clear();
    // requestController.intinraryCount(0);
    // requestController.reviewItenrary.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            top: width * 0.03,
            left: width * 0.04,
            right: width * 0.04,
            bottom: width * 0.08,
          ),
          child: Obx(
            () => CustomButton(
              buttonColor: requestController.reviewItenrary.length < 3
                  ? colorlightGreen
                  : null,
              borderColor: requestController.reviewItenrary.length < 3
                  ? colorlightGreen
                  : null,
              onPressed: () {
                if (requestController.reviewItenrary.length < 3) {
                  //  AppUtil.errorToast(context, "atLeastItenrary".tr);
                } else {
                  AmplitudeService.amplitude.track(BaseEvent(
                    'Local enter ${requestController.reviewItenrary.length} itenrary',
                  ));
                  Get.to(
                    () => ReviewIenraryScreen(
                      requestController: requestController,
                      requestId: widget.requestId,
                    ),
                  );
                }
              },
              title: "next".tr,
              icon: Icon(
                AppUtil.rtlDirection2(context)
                    ? Icons.arrow_back_ios
                    : Icons.arrow_forward_ios,
                size: width * 0.046,
              ),
            ),
          ),
        ),
        appBar: CustomAppBar(
          'itinerary'.tr,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: width * 0.03,
            horizontal: width * 0.04,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _controller.isExpanded ? width * 0.51 : width * 0.17,
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    top: width * 0.048,
                    right: width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(199, 199, 199, 0.25),
                          blurRadius: 16)
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpandedTile(
                        contentseparator: 12,
                        trailing: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: width * 0.062,
                        ),
                        disableAnimation: true,
                        trailingRotation: 180,
                        onTap: () {
                          setState(() {});
                        },
                        title: CustomText(
                          text: "tripDetails".tr,
                          fontSize: width * 0.044,
                          color: black,
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ItineraryTile(
                              title: DateFormat(
                                      'EEE, d MMMM yyyy',
                                      AppUtil.rtlDirection2(context)
                                          ? 'ar'
                                          : 'en')
                                  .format(
                                      DateTime.parse(widget.booking!.date!)),
                              image: "assets/icons/date.svg",
                              color: starGreyColor,
                            ),
                            SizedBox(height: width * 0.025),
                            ItineraryTile(
                              title:
                                  "${"pickUp".tr} ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToGo!)}"
                                  " ,  ${"dropOff".tr} ${AppUtil.formatStringTimeWithLocale(context, widget.booking!.timeToReturn!)}",
                              image: "assets/icons/timeGrey.svg",
                              color: starGreyColor,
                            ),
                            SizedBox(height: width * 0.025),
                            ItineraryTile(
                              title:
                                  "${widget.booking!.guestNumber} ${"guests".tr}",
                              image: "assets/icons/guests.svg",
                              color: starGreyColor,
                            ),
                            SizedBox(height: width * 0.025),
                            ItineraryTile(
                              title: requestController.address.value,
                              image: 'assets/icons/map_pin.svg',
                              color: starGreyColor,
                            ),
                            SizedBox(height: width * 0.025),
                            ItineraryTile(
                              title: widget.booking!.vehicleType.toString(),
                              image:
                                  'assets/icons/unselected_${widget.booking!.vehicleType.toString()}_icon.svg',
                              color: starGreyColor,
                              widthImage: 20,
                            ),
                          ],
                        ),
                        controller: _controller,
                        theme: const ExpandedTileThemeData(
                          leadingPadding: EdgeInsets.zero,
                          titlePadding: EdgeInsets.zero,
                          headerPadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.zero,
                          headerSplashColor: Colors.transparent,
                          headerColor: Colors.transparent,
                          contentBackgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: width * 0.09),
                CustomText(
                  text: "atLeastItenrary".tr,
                  fontWeight: FontWeight.w400,
                  color: starGreyColor,
                  fontSize: width * 0.033,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                ),
                // SizedBox(
                //   height: width * 0.05,
                // ),
                Obx(() => ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: width * 0.03,
                      ),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: requestController.reviewItenrary.length,
                      itemBuilder: (context, index) => ReivewItentraryCard(
                        requestController: requestController,
                        indx: index,
                        schedule: requestController.reviewItenrary[index],
                      ),
                    )),
                SizedBox(
                  height: width * 0.06,
                ),
                Obx(
                  () => ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(
                            height: width * 0.06,
                          ),
                      itemBuilder: (context, index) {
                        return requestController.itineraryList[index];
                      },
                      itemCount: requestController.itineraryList.length),
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (requestController.intinraryCount >= 1) {
                          return;
                        }
                        requestController.itineraryList.add(ItineraryCard(
                          booking: widget.booking!,
                          requestController: requestController,
                          indx: requestController.intinraryCount.value,
                        ));
                        requestController.intinraryCount++;
                      },
                      child: Container(
                        height: width * 0.08,
                        width: width * 0.08,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorGreen,
                            borderRadius: BorderRadius.circular(4)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: width * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    CustomText(
                      text: "addActicity".tr,
                      fontSize: width * 0.038,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
