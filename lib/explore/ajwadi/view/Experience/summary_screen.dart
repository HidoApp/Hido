import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/custom_ticket_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
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

import '../../../../services/model/summary.dart';

class SummaryScreen extends StatefulWidget {
  // final ProfileController profileController;
  final String hospitalityId;

  const SummaryScreen({
    super.key,
    required this.hospitalityId,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
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
  final _servicesController = Get.put(HospitalityController());
  Summary? _summary;
  //List<String> status = ['canceled', 'waiting', 'confirmed'];

  void gethospitalitySummary() async {
    _summary = await _servicesController.getHospitalitySummaryById(
        context: context, id: widget.hospitalityId);
    print(_summary?.cost);
    for (var guest in _summary!.guestList) {
      totalFemales += guest.female;
      totalMales += guest.male;
    }
  }

  int totalFemales = 0;
  int totalMales = 0;
  getTotalGuest() {
    if (_summary!.guestList.isNotEmpty || _summary!.guestList != [])
      for (var guest in _summary!.guestList) {
        totalFemales += guest.female;
        totalMales += guest.male;
      }

    print('Total number of females: $totalFemales');
    print('Total number of males: $totalMales');
  }

  @override
  void initState() {
    super.initState();
    gethospitalitySummary();
    // getTotalGuest();
    // widget.profileController.getPastTicket(context: context);
  }

  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context)!;

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
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              AppUtil.rtlDirection2(context)
                  ? "تم النسخ إلى الحافظة "
                  : 'Copied tp clipboard',
              style: TextStyle(
                color: Colors.white,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'Summary'.tr,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: _servicesController.isHospitalityByIdLoading.value
              ? Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : _summary == null || _summary!.guestList.isEmpty
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
                          side: BorderSide(width: 1, color: Color(0xFFDCDCE0)),
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
                                            text:
                                                _summary!.id.substring(0, 7)));
                                        _showOverlay(context);
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/Summary.svg',
                                      width: 20,
                                      height: 20,
                                    )),
                                const SizedBox(width: 8),
                                Text(
                                  '#${_summary?.id.substring(0, 7)}',
                                  style: TextStyle(
                                    color: Color(0xFFB9B8C1),
                                    fontSize: 13,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Divider(color: Color(0xFFDCDCE0), thickness: 1),
                          SizedBox(height: 12),
                          // Second Row: Title Place and Booking Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppUtil.rtlDirection2(context)
                                    ? _summary?.titleAr ?? ''
                                    : _summary?.titleEn ?? '',
                                style: TextStyle(
                                  color: Color(0xFF070708),
                                  fontSize: 16,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                formatBookingDate(context,
                                    _summary?.daysInfo.first.startTime ?? ''),
                                style: TextStyle(
                                  color: Color(0xFF070708),
                                  fontSize: 15,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(color: Color(0xFFDCDCE0), thickness: 1),
                          SizedBox(height: 12),
                          // Third Row: Time, Number of Male and Women, and Cost
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // AppUtil.formatTimeWithLocale(context, _summary?.daysInfo.first.startTime??'','hh:mm a'),
                                '${AppUtil.formatTimeWithLocale(context, _summary?.daysInfo.first.startTime ?? '', 'hh:mm a')} - ${AppUtil.formatTimeWithLocale(context, _summary?.daysInfo.first.endTime ?? '', 'hh:mm a')}',
                                style: TextStyle(
                                  color: Color(0xFF070708),
                                  fontSize: 12,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '$totalFemales ${'Women'.tr}',
                                    style: TextStyle(
                                      color: Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '∙',
                                    style: TextStyle(
                                      color: Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '$totalMales ${'Men'.tr}',
                                    style: TextStyle(
                                      color: Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '${_summary?.cost}',
                                    style: TextStyle(
                                      color: Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'sar'.tr,
                                    style: TextStyle(
                                      color: Color(0xFF070708),
                                      fontSize: 12,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(color: Color(0xFFDCDCE0), thickness: 1),
                          SizedBox(height: 12),
                          // Fourth Row: Guest List
                          Text(
                            AppUtil.rtlDirection2(context)
                                ? 'لائحة الضيوف'
                                : 'Guest list',
                            style: TextStyle(
                              color: Color(0xFF070708),
                              fontSize: 16,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _summary?.guestList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _summary?.guestList[index].name ?? '',
                                        style: TextStyle(
                                          color: Color(0xFF41404A),
                                          fontSize: 13,
                                          fontFamily:
                                              AppUtil.rtlDirection2(context)
                                                  ? 'SF Arabic'
                                                  : 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${_summary?.guestList[index].female} ${'Women'.tr} - ${_summary?.guestList[index].male} ${'Men'.tr}',
                                        style: TextStyle(
                                          color: Color(0xFFB9B8C1),
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
    );
  }

  String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return DateFormat('d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return DateFormat('d MMMM yyyy').format(dateTime);
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
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
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
