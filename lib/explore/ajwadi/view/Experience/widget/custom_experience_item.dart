import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/services/model/experiences.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ServicesCard extends StatefulWidget {
  const ServicesCard({
    Key? key,
    required this.experience,
  }) : super(key: key);

  final Experience experience;

  @override
  _ServicesCardState createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
  String address = '';
  bool isLoading = true;

   @override
  void initState() {
    super.initState();
_fetchAddress(); 
  }

  Future<String> _getAddressFromLatLng(double position1,double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1,position2);
      print(placemarks);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print(placemarks.first);
        return '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress() async {
    try {
      String result = await _getAddressFromLatLng(
 double.parse(  widget. experience.coordinates.latitude??''),double.parse(  widget. experience.coordinates.longitude??'')) ;     setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
     onTap:() {            
     widget.experience.experiencesType=='hospitality'
     ?  Get.to(() => HospitalityDetails(hospitalityId: widget.experience.id,isLocal: true,experienceType:widget.experience.experiencesType,address:address ))
     :Get.to(() => AdventureDetails(adventureId: widget.experience.id,isLocal: true ,address:address));
     },
      child: Container(
        height: width * 0.29,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.030, vertical: width * 0.025),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: width * 0.04, color: Colors.black12)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(width * 0.04),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                   widget. experience.image.first,
                    width: width * 0.23,
                    height: width * 0.23,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: width * 0.028,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppUtil.rtlDirection2(context)?widget.experience.experiencesType=='hospitality' ?widget.experience.titleAr??'':widget.experience.nameAr??'':widget.experience.experiencesType=='hospitality' ?widget.experience.titleEn??'':widget.experience.nameEn??'',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro',
                    ),
                    SizedBox(
                      height: width * 0.010,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.01,
                        ),
                        SvgPicture.asset(
                          'assets/icons/map_pin.svg',
                        ),
                        SizedBox(
                          width: width * 0.017,
                        ),
                        CustomText(
                          text: address,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro',
                          color: starGreyColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.01,
                    ),
                    
                     if (  widget. experience.daysInfo.isEmpty)
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.016,
                          ),
                         SvgPicture.asset(
                                'assets/icons/grey_calender.svg',
                                color: starGreyColor,
                              ),
                          SizedBox(
                            width: width * 0.019,
                          ),
                          CustomText(
                                text: AppUtil.formatBookingDate(context,widget. experience.date ?? ''),
                             color: starGreyColor,
                            fontSize: 11,
                            fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                        ],
                      ),
                 
                    if (  widget. experience.daysInfo.isNotEmpty)
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SvgPicture.asset(
                            'assets/icons/timeGrey.svg',
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                      

                          CustomText(
                            text:
                                '${ AppUtil.formatBookingDate(context,
                                      widget. experience.daysInfo[0].startTime ?? '')} - ${formatTimeOnly(context,   widget. experience.daysInfo[0].startTime)} ',
                              
                            color: starGreyColor,
                            fontSize: 11,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                       SizedBox(
                      height: width * 0.01,
                    ),
                       if (  widget. experience.daysInfo.isEmpty)
                       
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SvgPicture.asset(
                            'assets/icons/timeGrey.svg',
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                      

                          CustomText(
                            text:
                                 ' ${AppUtil.formatStringTimeWithLocale(context, widget. experience.times.first.startTime)} -  ${AppUtil.formatStringTimeWithLocale(context, widget. experience.times.first.endTime)}',
                            color: starGreyColor,
                            fontSize: 11,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                   
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.015,
                        ),
                       if (  widget. experience.daysInfo.isNotEmpty)

                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/meal.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                              CustomText(
                                text:AppUtil.rtlDirection2(context)? AppUtil.capitalizeFirstLetter(widget. experience.mealTypeAr):AppUtil.capitalizeFirstLetter(widget. experience.mealTypeEn),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SF Pro',
                                color: starGreyColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset('assets/icons/star.svg'),
            SizedBox(
              width: width * 0.01,
            ),
            CustomText(
              text: "",
              fontSize: width * 0.025,
              fontWeight: FontWeight.w700,
              color: colorDarkGreen,
              fontFamily: 'Kufam',
            ),
          ],
        ),
      ),
    );
  }

    static String formatTimeOnly(BuildContext context, String dateTimeString) {
    final isArabic = AppUtil.rtlDirection2(context);
    final dateTime = DateTime.parse(dateTimeString);
    final hours = dateTime.hour;
    final minutes = dateTime.minute;
    final period = hours >= 12 ? (isArabic ? 'مساءً' : 'PM') : (isArabic ? 'صباحًا' : 'AM');
    final formattedHours = hours % 12 == 0 ? 12 : hours % 12;
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes $period';
  }

}