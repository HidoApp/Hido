import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/custom_ticket_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure_summary.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AdventureSummaryScreen extends StatefulWidget {
  // final ProfileController profileController;
 final String adventureId;

  const  AdventureSummaryScreen({
    super.key,
     required this.adventureId,
  });

  @override
  State< AdventureSummaryScreen> createState() => _AdventureSummaryScreenState();
}



class _AdventureSummaryScreenState extends State< AdventureSummaryScreen>{
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
 final _servicesController = Get.put(AdventureController());
  AdventureSummary? _summary ;
  //List<String> status = ['canceled', 'waiting', 'confirmed'];


void gethospitalitySummary() async {
  
    _summary = await _servicesController.getAdventureSummaryById(context: context, id: widget.adventureId);
    print(_summary?.cost);
     for (var guest in _summary!.touristList) {
  totalguest += guest.guestNumber;
  }

}

int totalguest = 0;

//  getTotalGuest(){
//   if(_summary!.touristList.isNotEmpty||_summary!.touristList!=[])

//   for (var guest in _summary!.guestList) {
//   totalFemales += guest.female;
//   totalMales += guest.male;
//   }

//   print('Total number of females: $totalFemales');
//   print('Total number of males: $totalMales');
// }

  @override
  void initState() {
    super.initState();
   gethospitalitySummary();
  // getTotalGuest();
   // widget.profileController.getPastTicket(context: context);
   
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
      body:Obx( () => Padding(
        padding: const EdgeInsets.all(16.0),
        child:
          _servicesController.isAdventureByIdLoading.value
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            :_summary == null || _summary!.touristList.isEmpty? 
            Column(
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
                    SvgPicture.asset(
                      'assets/icons/Summary.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '#${_summary?.id.substring(0, 7)}',
                      style: TextStyle(
                        color: Color(0xFFB9B8C1),
                        fontSize: 13,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
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
                    AppUtil.rtlDirection2(context)?
                    _summary?.nameAr??''
                    :_summary?.nameEn??'',
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 16,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    
                     AppUtil.formatBookingDate(context,
                                        _summary!.date),
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 15,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
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
                   '${ formatTimeWithLocale(context, _summary?.times.first.startTime??'','hh:mm a')} - ${formatTimeWithLocale(context, _summary?.times.first.endTime??'','hh:mm a')}',
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 12,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '$totalguest ${'Pepole'.tr}',
                        style: TextStyle(
                          color: Color(0xFF070708),
                          fontSize: 12,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
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
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'sar'.tr,
                        style: TextStyle(
                          color: Color(0xFF070708),
                          fontSize: 12,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
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
               AppUtil.rtlDirection2(context)?'لائحة الضيوف' :'Tourist list',
                style: TextStyle(
                  color: Color(0xFF070708),
                  fontSize: 16,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _summary?.touristList .length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                          _summary?.touristList[index].name??'',
                            style: TextStyle(
                              color: Color(0xFF41404A),
                              fontSize: 13,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${_summary?.touristList[index].guestNumber} ${'person'.tr}',
                            style: TextStyle(
                              color: Color(0xFFB9B8C1),
                              fontSize: 12,
                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
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