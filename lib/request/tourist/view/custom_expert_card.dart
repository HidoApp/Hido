import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomExpertCard extends StatelessWidget {
  const CustomExpertCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 100,
      width: width*0.6,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset("assets/images/place.png"),
            ),
           const SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             const   Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                      textAlign: TextAlign.start,
                      text: "Kumait Mountai",
                      fontSize: 16,
                      textDirection: TextDirection.ltr),
                ),
                SizedBox(
                  width: width * 0.6,
                  child:const CustomText(
                    text:
                        "Mount Kumait the most famous mountain in the ...Mount Kumait the most famous mountain in the ...",
                    fontSize: 10,
                    textOverflow: TextOverflow.fade,
                    color: almostGrey,
                    maxlines: 3,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
