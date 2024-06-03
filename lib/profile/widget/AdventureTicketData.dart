import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../explore/tourist/model/booking.dart';
import '../../services/model/adventure.dart';
import '../../services/model/hospitality.dart';
import '../../utils/app_util.dart';
import '../../widgets/dotted_line_separator.dart';


class AdventureTicketData extends StatelessWidget {
  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;
  final Adventure? adventure;
  // final int? maleGuestNum;
  // final int? femaleGuestNum;

  AdventureTicketData({
    Key? key,
    this.booking,
    this.icon,
    this.bookTypeText,
    // this.femaleGuestNum,
    // this.maleGuestNum,
    this.adventure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BookingDetails".tr,
                style: TextStyle(
                  color: Color(0xFF070708),
                  fontSize: 17,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Row(
                children: [
                  icon ?? SizedBox.shrink(),
                  Text(
                    AppUtil.getBookingTypeText(context, bookTypeText ?? ''),
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 13,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 294,
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 255,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppUtil.rtlDirection2(context) ? "التاريخ" : 'Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9392A0),
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        const SizedBox(height: 5),

                          Text(
                            adventure==null?AppUtil.formatBookingDate(context,booking!.date):AppUtil.formatBookingDate(context,adventure!.booking!.last.date),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF111113),
                              fontSize: 15,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ), 
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                         AppUtil.rtlDirection2(context)?"وقت الذهاب" :'Start Time',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                        ),
                                    ),
                                    Text(
                                        // '10:00 AM',
                                       // booking.timeToGo??'',
                                       
                                      adventure==null?formatTimeWithLocale(context,booking!.timeToGo):formatTimeWithLocale(context,adventure!.booking!.last.timeToGo),
                                        style: TextStyle(
                                            color: Color(0xFF111113),
                                            fontSize: 15,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
              ),             
              const SizedBox(height: 12),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppUtil.rtlDirection2(context)
                                ? "غدد الضيوف"
                                : 'Guests',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9392A0),
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 5),

                          Container(
                            child:Column(
                               mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                              Row(
                              // mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(adventure==null?'${booking?.guestNumber} ${'person'.tr}':'${adventure!.booking!.last.guestNumber} ${'person'.tr}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF111113),
                                    fontSize: 15,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                    
                              ],
                            ),
                           
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppUtil.rtlDirection2(context) ? "المبلغ" : 'Cost',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9392A0),
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  
                                  // booking.place!.price.toString(),
                                adventure==null? booking!.cost.toString():adventure!.booking!.last.cost.toString(),

                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF111113),
                                    fontSize: 17,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppUtil.rtlDirection2(context) ? 'ريال' : 'SAR',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF111113),
                                    fontSize: 14,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Divider(color: Colors.grey, height: 5),
          DottedSeparator(
                  color: almostGrey,
                  height: 1,
                ),
        // SizedBox(height: 30),
        // Divider(),

      //  Link(
      //   uri: Uri.parse('http://flutter.dev'),
        
      //    builder: (context,followlink)=>GestureDetector(
      //    onTap: followlink,
      //     child: Text("open link"),
      //    )
         const SizedBox(height: 25),
              Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () async {
                    
                    final Uri url = adventure==null?Uri.parse( booking!.adventure?.locationUrl??''):Uri.parse(adventure!.locationUrl??'');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $url';
                    }
                    // String query = Uri.encodeComponent('https://maps.app.goo.gl/Z4kmkh5ikW31NacQA');
                    //  String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

                      // if (await canLaunchUrl(googleUrl)) {
                      //      await launchUrl(googleUrl);
                      //         }

//                      String googleUrl =
//                  'comgooglemaps://?center= Z4kmkh5ikW31NacQA;
//                 String appleUrl =
//                  'https://maps.apple.com/?sll=${trip.origLocationObj.lat},${trip.origLocationObj.lon}';
//                 if (await canLaunchUrl("comgooglemaps://")) {
//                    print('launching com googleUrl');
//                     await launchUrl(googleUrl);
//                   } else if (await canLaunch(appleUrl)) {
//                     print('launching apple url');
//                        await launchUrl(appleUrl);
//                            } else {
//                         throw 'Could not launch url';
//                        }
// }
//                   },
                  

                  },
                  child: Text(
                    AppUtil.rtlDirection2(context) ? "الموقع" : 'Location',
                    style: TextStyle(
                         color: Color(0xFF37B268),
                        fontSize: 18,
                    fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      height: 0,
                       
                      decoration: TextDecoration.underline,
                    ),
                    
                  ),
                ),
         
         
         ),


      ],
        
    );
  }
  String formatTimeWithLocale(BuildContext context, String dateTimeString) {
 
  DateTime time = DateFormat("HH:mm").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
  if (AppUtil.rtlDirection2(context)) {
    // Arabic locale
    String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
    formattedTime = formattedTime.replaceAll('AM', '').replaceAll('PM', '').trim(); // Remove AM/PM
    return '$formattedTime $suffix';
  } else {
    // Default to English locale
    return formattedTime;
  }
}
}



