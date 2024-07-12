import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/local_trip_card.dart';
import 'package:ajwad_v4/explore/widget/trip_card.dart';
import 'package:ajwad_v4/profile/view/custom_ticket_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'hoapatility/view/custom_experience_card.dart';

class LastActivity extends StatefulWidget {
 

   const  LastActivity({
    super.key,
  });
 
  @override
  State< LastActivity> createState() => _NextActivityState();
}

class _NextActivityState extends State< LastActivity> {
  
  final _tripController = Get.put(TripController());



  void updateProgress(double newProgress) {
    setState(() {
      _tripController.progress.value = newProgress.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
        width: double.infinity,
          height: width * 0.196,
             decoration: ShapeDecoration(
                        color: Colors.white,

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          shadows: [
            BoxShadow(
              color: Color(0x3FC7C7C7),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
             ),
          child: Padding(
            padding: AppUtil.rtlDirection2(context) ? const EdgeInsets.only(top:8.0,bottom:8):const EdgeInsets.only(top:0,bottom:0),
            child: Stack(
              children: [
                
                Positioned(
                  left: 40,
                  top: 27,
                  child: Container(
                    width: 279,
                    height: 1.50,
                    child: LinearProgressIndicator(
                      value: _tripController.progress.value,
                      backgroundColor: Color(0xFFDCDCE0),
                      valueColor: _tripController.progress.value==0.1?AlwaysStoppedAnimation<Color>(Color(0xFFDCDCE0)):AlwaysStoppedAnimation<Color>(Color(0xFF36B268)),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top:AppUtil.rtlDirection2(context) ?16:14,
                  child: Container(
                    width: 334,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:AppUtil.rtlDirection2(context)?MainAxisAlignment.spaceBetween: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:AppUtil.rtlDirection2(context)?CrossAxisAlignment.start: CrossAxisAlignment.center,
                      
                      children: [
                        buildStep(
                          text: 'Ontheway'.tr,
                          isActive: _tripController.progress.value >= 0.25,
                        ),
                        buildStep(
                          text: 'Arrived'.tr,
                          isActive: _tripController.progress.value >= 0.5,
                        ),
                        buildStep(
                          text: 'Tourtime'.tr,
                          isActive:  _tripController.progress.value >= 0.75,
                        ),
                        buildStep(
                          text: 'Completed'.tr,
                          isActive:  _tripController.progress.value == 1.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
       // SizedBox(height: 16),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         if (progress > 0) {
        //           updateProgress((progress - 0.25));
        //         }
        //       },
        //       child: Text('Decrease'),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         if (progress < 1.0) {
        //           updateProgress((progress + 0.25));
        //         }
        //       },
        //       child: Text('Increase'),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         updateProgress(0.0);
        //       },
        //       child: Text('Reset'),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget buildStep({ required String text, required bool isActive}) {
    return Container(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Padding(
           padding: const EdgeInsets.only(top:2),
           child: SvgPicture.asset('assets/icons/slider.svg', color: isActive ? Color(0xFF36B268) : Color(0xFFDCDCE0),height: 20,width:20),
         ),
          Text(
            text,
            style: TextStyle(
              color: isActive ? Color(0xFF36B268) : Color(0xFFDCDCE0),
              fontSize: 11,
              fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


  

         