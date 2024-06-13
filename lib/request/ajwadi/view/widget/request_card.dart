import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/ajwadi/view/Itinerary_screen.dart';
import 'package:ajwad_v4/services/view/widgets/itenrary_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_outlined_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestCard extends StatefulWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.onReject,
    required this.index,
    required this.requestController,
  });
  final int index;
  final RequestModel request;
  final void Function() onReject;
  final RequestController requestController;
  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late ExpandedTileController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ExpandedTileController(isExpanded: false);
  }

  String formatTime(String time) {
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a', AppUtil.rtlDirection2(context) ? 'ar' : 'en')
        .format(dateTime);
  }

  // String timeAgo(String isoDateString) {
  //   DateTime date = DateTime.parse(isoDateString);
  //   return timeago.format(date,
  //       locale: 'en_short'); // 'en_short' gives a shorter format like "11h ago"
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: _controller.isExpanded ? width * 0.9 : width * 0.54,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(199, 199, 199, 0.25), blurRadius: 16)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.request.placeImage == null
                  ? Image.asset(
                      'assets/images/Image.png',
                      height: width * 0.15,
                      width: width * 0.15,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        fit: BoxFit.cover,
                        widget.request.placeImage!.first,
                        height: width * 0.15,
                        width: width * 0.15,
                      ),
                    ),
              SizedBox(width: width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ? widget.request.requestName!.nameAr
                          : widget.request.requestName!.nameEn),
                  CustomText(
                    text: '${"tourist".tr} : ${widget.request.senderName}',
                    color: almostGrey,
                  )
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: width * 0.05),
                child: CustomText(
                  text: timeago.format(DateTime.parse(widget.request.date!),
                      locale: AppUtil.rtlDirection2(context) ? 'ar' : 'en'),
                  color: almostGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.03),
          ExpandedTile(
            contentseparator: 12,
            trailing: Icon(
              Icons.keyboard_arrow_down_outlined,
              size: width * 0.046,
            ),
            disableAnimation: true,
            trailingRotation: 180,
            onTap: () {
              print(widget.request.date);
              setState(() {});
            },
            title: CustomText(
              text: "tripDetails".tr,
              fontSize: width * 0.03,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItineraryTile(
                  title: DateFormat('EEE, d MMMM yyyy',
                          AppUtil.rtlDirection2(context) ? 'ar' : 'en')
                      .format(DateTime.parse(widget.request.date!)),
                  image: "assets/icons/date.svg",
                ),
                SizedBox(height: width * 0.025),
                ItineraryTile(
                  title:
                      "${"pickUp".tr} ${formatTime(widget.request.booking!.timeToGo!)}"
                      ", ${"dropOff".tr} ${formatTime(widget.request.booking!.timeToReturn!)}",
                  image: "assets/icons/timeGrey.svg",
                ),
                SizedBox(height: width * 0.025),
                ItineraryTile(
                  title:
                      "${widget.request.booking!.guestNumber} ${"guests".tr}",
                  image: "assets/icons/guests.svg",
                ),
                SizedBox(height: width * 0.025),
                ItineraryTile(
                  title: widget.request.booking!.vehicleType.toString(),
                  image:
                      'assets/icons/unselected_${widget.request.booking!.vehicleType.toString()}_icon.svg',
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
          const Spacer(),
          const Divider(color: lightGrey),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => widget.requestController.isRequestRejectLoading.value &&
                        widget.index ==
                            widget.requestController.requestIndex.value
                    ? const CircularProgressIndicator.adaptive()
                    : SizedBox(
                        height: width * 0.08,
                        width: width * 0.4,
                        child: CustomOutlinedButton(
                          buttonColor: colorRed,
                          onTap: widget.onReject,
                          title: 'reject'.tr,
                        ),
                      ),
              ),
              SizedBox(
                height: width * 0.08,
                width: width * 0.4,
                child: CustomButton(
                  raduis: 4,
                  onPressed: () {
                    Get.to(() => AddItinerary(requestId: widget.request.id!));
                  },
                  title: 'accept'.tr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
