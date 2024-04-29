import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key, required this.title, required this.onPressed, this.color});
final Color? color ;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        onPressed: onPressed,
        
        style: ElevatedButton.styleFrom(
            backgroundColor: color ?? colorGreen ,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              CustomText(
                text: title,
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              const Spacer(),
              Container(
                  width: 30.0,
                  height: 30.0,
                  decoration:  BoxDecoration(
                 //   color: color != null ?Color(0xFF95753D) : colorDarkGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios,color: Colors.white,size: 20,))
            ],
          ),
        ),
      ),
    );
  }
}
