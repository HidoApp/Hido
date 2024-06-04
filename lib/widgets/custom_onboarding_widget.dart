import 'package:flutter/material.dart';
import '../utils/app_util.dart';
import 'custom_text.dart';

class CustomOnBoardingWidget extends StatelessWidget {
  final String backgroundImage;
  final GestureTapCallback? nextScreen;
  final String text;
  final String description;
  const CustomOnBoardingWidget(
      {Key? key,
      required this.text,
      required this.description,
      required this.backgroundImage,
      this.nextScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/onboarding/$backgroundImage.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            top: size.width * 0.899,
            child: SizedBox(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.06, right: size.width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      //   width: !AppUtil.rtlDirection(context)?  size.width * 0.5128: size.width*  0.717,
                      child: CustomText(
                        text: text,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontSize: !AppUtil.rtlDirection(context)
                            ? size.width * 0.164
                            : size.width * 0.12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    //   SizedBox(width:!AppUtil.rtlDirection(context)?  size.width *0.282:size.width * 0.07,),
                    InkWell(
                        onTap: nextScreen,
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                          size: size.width * 0.0974,
                        ))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.width * 0.800,
            left: size.width * 0.0256,
            right: size.width * 0.0384,
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.04, right: size.width * 0.04),
              child: CustomText(
                maxlines: 4,
                textAlign: !AppUtil.rtlDirection(context)
                    ? TextAlign.right
                    : TextAlign.left,
                text: description,
                color: Colors.white,
                fontSize: size.width * 0.041,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
