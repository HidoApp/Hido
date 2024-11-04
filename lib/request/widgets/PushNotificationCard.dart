import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class PushNotificationCrd extends StatelessWidget {
  const PushNotificationCrd({
    Key? key,
    this.message = '',
    required this.isRtl,
    required this.width,
   // required this.isDisabled,
    //required this.onCancel,
//  required this.onDismissed,
   //required this.isViewed,


    
  }) : super(key: key);
  final String message;
  final double width;
  final bool isRtl;

  //final bool isDisabled;
 // final VoidCallback onCancel;
  // final VoidCallback onDismissed;
  //final bool isViewed;


  @override
  Widget build(BuildContext context) {
  return Column(
   children: [
     Container(
       height: 89,
       decoration: BoxDecoration(
           // color: isViewed ? Colors.white : Color(0xFFECF9F1),
        color:  Color(0xFFECF9F1),
         border: Border(
           left: BorderSide(color: Color(0xFFECECEE)),
           top: BorderSide(color: Color(0xFFECECEE)),
           right: BorderSide(color: Color(0xFFECECEE)),
           bottom: BorderSide(width: 1, color: Color(0xFFECECEE)),
         ),
       ),
       child: Padding(
         padding: const EdgeInsets.symmetric(
             horizontal: 16, vertical: 16),
         child: Row(
           crossAxisAlignment: isRtl
               ? CrossAxisAlignment.center
               : CrossAxisAlignment.center,
           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             SvgPicture.asset('assets/icons/bell.svg'),
             const SizedBox(width: 13),
             SizedBox(
               width: width * 0.48,
               child: Text(
                 maxLines: 500,
                     message,
                     
                     style: TextStyle(
                       fontFamily: isRtl ? 'SF Arabic' : 'SF Pro',
                       fontSize: 13,
                       maxlines: 200,
                       fontWeight:
                           isRtl ? FontWeight.w500 : FontWeight.w500,
                       color: isRtl ? black : black,
                     ),
                 
                  
                   // TextSpan(
                   //   text: days,
                   //   style: TextStyle(
                   //     fontFamily: isRtl ? 'SF Arabic' : 'SF Pro',
                   //     fontSize: 13,
                   //     fontWeight:
                   //         isRtl ? FontWeight.w500 : FontWeight.w500,
                   //     color: black,
                   //   ),
                   // ),
               ),
             ),
             // IconButton(
             //   onPressed: onCancel,
             //   icon: const Icon(
             //     Icons.cancel,
             //     color: Colors.red,
             //   ),
             // ),
           ],
         ),
       ),
     ),
     SizedBox(
       height: 13,
     )
   ],
      );
  }
}
