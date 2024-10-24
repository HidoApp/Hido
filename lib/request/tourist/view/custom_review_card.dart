import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomReviewCard extends StatelessWidget {
  const CustomReviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
     //   height: height*0.12,
        width: width,
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      ClipOval(
          child: Image.asset("assets/images/tourist_in_review_image.png")),
      SizedBox(width: 10,),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
        Container(
          width: width*0.77,
          child: Row(
            children: [
              CustomText(text: "Rocks Velkeinjen",fontWeight: FontWeight.bold,fontSize: 18,),
              Spacer(),
              CustomText(text: "10 Feb",color: almostGrey,fontSize: 12,  fontStyle: FontStyle.italic,),

            ],
          ),
        ),


        Container(
          height: 30,
          width: width*0.77,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context,index){
              return SvgPicture.asset("assets/icons/star.svg");
            }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width: 3,); },),),
          Container(
            width: width * 0.77,
            child: CustomText(
              text: "Cinemas is the ultimate experience to see new movies in Gold Class or Vmax. Find a cinema near you.",
              fontSize: 14,
              textOverflow: TextOverflow.fade,
              color: black,

            //  maxlines: 8,
            ),
          ),
        ],)
    ],
        )
    );
  }
}
