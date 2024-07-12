import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagesSliderWidget extends StatelessWidget {
  const ImagesSliderWidget({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        height: 194,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              image,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color(0x3FC7C7C7),
          //     blurRadius: 15,
          //     offset: Offset(0, 0),
          //     spreadRadius: 0,
          //   ),
          // ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, right: 12, left: 12), // Add padding here
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: ShapeDecoration(
                    color:  Colors.white.withOpacity(0.20000000298023224),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Coverphoto'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // SizedBox(
    //   width: MediaQuery.of(context).size.width,
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.only(
    //         bottomLeft:
    //             Radius.circular(MediaQuery.of(context).size.width * 0.04),
    //         bottomRight:
    //             Radius.circular(MediaQuery.of(context).size.width * 0.04)),
    //     child: Image.network(
    //       image,
    //       fit: BoxFit.fill,
    //     ),
    //   ),
    // );
  }
}
