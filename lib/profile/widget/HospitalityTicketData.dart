import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../explore/tourist/model/booking.dart';
import '../../services/model/hospitality.dart';
import '../../utils/app_util.dart';
import '../../widgets/dotted_line_separator.dart';


class HostTicketData extends StatelessWidget {
  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;
  final Hospitality? hospitality;
  // final int? maleGuestNum;
  // final int? femaleGuestNum;

  HostTicketData({
    Key? key,
    this.booking,
    this.icon,
    this.bookTypeText,
    // this.femaleGuestNum,
    // this.maleGuestNum,
    this.hospitality,
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
                            hospitality==null?AppUtil.formatBookingDate(context,booking!.date):AppUtil.formatBookingDate(context,hospitality!.booking!.first.date),
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
                                Text(
                                   hospitality==null?'${booking?.guestInfo?.female} ${'Female'.tr}':'${hospitality!.booking!.last.guestInfo.female} ${'Female'.tr}',
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
                            const SizedBox(height: 5),

                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hospitality==null?'${booking?.guestInfo?.male} ${'male'.tr}':'${hospitality!.booking!.last.guestInfo.male} ${'male'.tr}',
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
                                 hospitality==null? booking!.cost.toString():hospitality!.booking!.last.cost.toString(),

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
                    
                    final Uri url = hospitality==null?Uri.parse( booking!.hospitality?.location??''):Uri.parse(hospitality!.location??'');
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
}



