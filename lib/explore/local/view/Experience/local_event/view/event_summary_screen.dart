import 'package:ajwad_v4/profile/view/custom_ticket_card.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/model/event_summary.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventSummaryScreen extends StatefulWidget {
  // final ProfileController profileController;
  final String eventId;
  final String date;

  const EventSummaryScreen({
    super.key,
    required this.eventId,
    required this.date,
  });

  @override
  State<EventSummaryScreen> createState() => _AdventureSummaryScreenState();
}

class _AdventureSummaryScreenState extends State<EventSummaryScreen> {
  final String referenceNumber = '#1102238';
  final String titlePlace = 'Juwai Farm';
  final String bookingDate = '25 April 2024';
  final String time = '12:00 PM - 6:00 PM';
  final int numberOfWomen = 12;
  final int numberOfMen = 10;
  final double cost = 3960;
  final String currency = 'SAR';
  final List<Map<String, String>> guestList = [
    {'name': 'Esther Howard', 'gender': 'Female'},
    {'name': 'John Doe', 'gender': 'Male'},
    // Add more guests as needed
  ];
  final _servicesController = Get.put(EventController());
  EventSummary? _summary;
  //List<String> status = ['canceled', 'waiting', 'confirmed'];

  void getEventSummary() async {
    _summary = await _servicesController.getEventSummaryById(
      context: context,
      id: widget.eventId,
      date: widget.date,
    );

    for (var guest in _summary!.touristList) {
      totalguest += guest.guestNumber;
    }
  }

  int totalguest = 0;

  @override
  void initState() {
    super.initState();
    getEventSummary();
    // getTotalGuest();
    // widget.profileController.getPastTicket(context: context);
  }

  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 117,
        left: AppUtil.rtlDirection2(context)
            ? MediaQuery.of(context).size.width * 0.35
            : null,
        right: AppUtil.rtlDirection2(context)
            ? null
            : MediaQuery.of(context).size.width * 0.35,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CustomText(
              text: 'Copied'.tr,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'Summary'.tr,
      ),
      body: Obx(
        () => Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _servicesController.isEventByIdLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : _summary == null || _summary!.touristList.isEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                                height: height * 0.84,
                                width: width,
                                child: CustomEmptyWidget(
                                  title: 'noSummary'.tr,
                                  image: 'empty_summary',
                                  subtitle: 'noSummarySub'.tr,
                                )),
                          ),
                        ],
                      )
                    : Container(
                        width: 358,
                        height: 476,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDCDCE0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        if (_summary != null &&
                                            _summary!.id.isNotEmpty) {
                                          Clipboard.setData(ClipboardData(
                                              text: _summary!.id
                                                  .substring(0, 7)));
                                          _showOverlay(context);
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/Summary.svg',
                                        width: 20,
                                        height: 20,
                                      )),
                                  const SizedBox(width: 8),
                                  CustomText(
                                    text: '#${_summary?.id.substring(0, 7)}',
                                    color: const Color(0xFFB9B8C1),
                                    fontSize: 13,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                                color: Color(0xFFDCDCE0), thickness: 1),
                            const SizedBox(height: 12),
                            // Second Row: Title Place and Booking Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  child: CustomText(
                                    text: AppUtil.rtlDirection2(context)
                                        ? _summary?.nameAr ?? ''
                                        : _summary?.nameEn ?? '',
                                    color: const Color(0xFF070708),
                                    fontSize: 16,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CustomText(
                                  text: formatBookingDate(context, widget.date),
                                  color: const Color(0xFF070708),
                                  fontSize: 15,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                                color: Color(0xFFDCDCE0), thickness: 1),
                            const SizedBox(height: 12),
                            // Third Row: Time, Number of Male and Women, and Cost
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_summary!.daysInfo.isNotEmpty)
                                  CustomText(
                                    text:
                                        '${AppUtil.formatTimeWithLocale(context, _summary?.daysInfo.first.startTime ?? '', 'hh:mm a')} - ${AppUtil.formatTimeWithLocale(context, _summary?.daysInfo.first.endTime ?? '', 'hh:mm a')}',
                                    color: const Color(0xFF070708),
                                    fontSize: 12,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CustomText(
                                      text: '$totalguest ${'Pepole'.tr}',
                                      color: const Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CustomText(
                                      text: '${_summary?.cost}',
                                      color: const Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      text: 'sar'.tr,
                                      color: const Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                                color: Color(0xFFDCDCE0), thickness: 1),
                            const SizedBox(height: 12),
                            // Fourth Row: Guest List
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? 'لائحة الضيوف'
                                  : 'Tourist list',
                              color: const Color(0xFF070708),
                              fontSize: 16,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _summary?.touristList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _summary?.touristList[index].name ??
                                              '',
                                          style: TextStyle(
                                            color: const Color(0xFF41404A),
                                            fontSize: 13,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${_summary?.touristList[index].guestNumber} ${'person'.tr}',
                                          style: TextStyle(
                                            color: const Color(0xFFB9B8C1),
                                            fontSize: 12,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  static String formatTimeWithLocale(
      BuildContext context, String timeString, String format) {
    // Parse the time string to DateTime
    DateTime time = DateFormat.Hms().parse(timeString);

    // Format the time
    String formattedTime = DateFormat(format).format(time);

    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }
}


// class SummaryScreen extends StatefulWidget {
//   // final ProfileController profileController;
//   const SummaryScreen({
//     super.key,
//     // required this.profileController,
//   });

//   @override
//   State<SummaryScreen> createState() => _SummaryScreenState();
// }

// class _SummaryScreenState extends State<SummaryScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int tabIndex = 0;
//   final _servicesController = Get.put(HospitalityController());

//   //List<String> status = ['canceled', 'waiting', 'confirmed'];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//     final height =MediaQuery.sizeOf(context).height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         'Summary'.tr,
//       ),
//       body:
//           // Obx(
//           //   () =>

//           Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 child: ListView(
//                   children: [
//                     SizedBox(
//                         //new
//                         height: height * 0.84,
//                         width: width,
//                         child: CustomEmptyWidget(
//                           title: 'noSummary'.tr,
//                           image: 'empty_summary',
//                           subtitle: 'noSummarySub'.tr,
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
