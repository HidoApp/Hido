import 'package:ajwad_v4/constants/colors.dart';
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
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestCard extends StatefulWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.onReject,
  });

  final RequestModel request;
  final void Function() onReject;

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
    return DateFormat('h:mm a').format(dateTime);
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                widget.request.localImage ?? 'assets/images/Image.png',
                height: width * 0.15,
                width: width * 0.15,
              ),
              SizedBox(width: width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: widget.request.requestName!.nameEn),
                  CustomText(
                    text: 'Tourist: ${widget.request.senderName}',
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
            contentseparator: 0,
            trailing: Icon(Icons.keyboard_arrow_down_outlined),
            disableAnimation: true,
            trailingRotation: 180,
            onTap: () {
              print(widget.request.date);
              setState(() {});
            },
            title: CustomText(text: "Tour Details"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItineraryTile(
                  title: DateFormat('EEE, d MMMM yyyy')
                      .format(DateTime.parse(widget.request.date!)),
                  image: "assets/icons/date.svg",
                ),
                SizedBox(height: width * 0.025),
                ItineraryTile(
                  title:
                      "Pick up: ${formatTime(widget.request.booking!.timeToGo!)}"
                      ", Drop off: ${formatTime(widget.request.booking!.timeToReturn!)}",
                  image: "assets/icons/timeGrey.svg",
                ),
                SizedBox(height: width * 0.025),
                ItineraryTile(
                  title: "${widget.request.booking!.guestNumber} guests",
                  image: "assets/icons/guests.svg",
                ),
                SizedBox(height: width * 0.025),
                ItineraryTile(
                  title: widget.request.booking!.vehicleType.toString(),
                  image: "assets/icons/car.svg",
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
              SizedBox(
                height: width * 0.08,
                width: width * 0.4,
                child: CustomOutlinedButton(
                  buttonColor: colorRed,
                  onTap: widget.onReject,
                  title: 'Reject',
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
                  title: 'Accept',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
