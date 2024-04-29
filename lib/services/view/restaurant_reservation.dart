import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantReservation extends StatefulWidget {
  RestaurantReservation({Key? key}) : super(key: key);

  @override
  State<RestaurantReservation> createState() => _RestaurantReservationState();
}

var timeList, peopleNum;
late int dayIndex, timeIndex, peopleIndex;

class _RestaurantReservationState extends State<RestaurantReservation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dayIndex = -1;
    timeIndex = -1;
    peopleIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final dateTime = [
      {
        'date': 12,
        'day': 'sat',
        'available': true,
        'time': ['12 pm', '13 pm', '14 pm', '15 pm'],
        'people': 3
      },
      {
        'date': 13,
        'day': 'mon',
        'available': true,
        'time': ['1 pm', '3 pm', '4 pm', '5 pm'],
        'people': 5
      },
      {
        'date': 14,
        'day': 'tue',
        'available': true,
        'time': ['10 pm', '11 pm', '12 pm', '13 pm'],
        'people': 10
      },
      {
        'date': 15,
        'day': 'wed',
        'available': false,
        'time': ['9 pm', '10 pm', '11 pm', '12 pm'],
        'people': 3
      },
      {
        'date': 16,
        'day': 'Thurs',
        'available': true,
        'time': ['9 pm', '10 pm', '11 pm', '12 pm'],
        'people': 7
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        "reserve".tr,
        color: black,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: height * 0.89,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "date2".tr,
                  color: black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                Container(
                  height: height * 0.15,
                  margin: EdgeInsets.symmetric(vertical: 2),
                  child: ListView.separated(
                    // shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: dateTime.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                      onTap: () {
                        setState(() {
                          if (dateTime[index]['available'] == true) {
                            dayIndex = index;
                            timeIndex = -1;
                            peopleIndex = -1;
                            peopleNum = dateTime[index]['people'];
                          }

                          timeList = dateTime[dayIndex]['time'];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                            color: dateTime[index]['available'] != true
                                ? lightGreyColor
                                : (dayIndex == index ? reddishOrange : Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: lightGreyColor,
                                blurRadius: 10,
                                spreadRadius: 0.1,
                                offset: Offset(2, 2),
                              ),
                            ]),
                        width: width * 0.21,
                        height: height * 0.05,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: dateTime[index]['date'].toString(),
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: dateTime[index]['available'] != true
                                    ? Colors.white
                                    : dayIndex == index
                                        ? Colors.white
                                        : black,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CustomText(
                                text: dateTime[index]['day'].toString(),
                                fontSize: 16,
                                color: dateTime[index]['available'] != true
                                    ? almostGrey
                                    : dayIndex == index
                                        ? Colors.white
                                        : reddishOrange,
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
                //  ),
                dayIndex > -1
                    ? CustomText(
                        text: "time".tr,
                        color: black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      )
                    : Container(),

                dayIndex > -1
                    ? Container(
                        height: height * 0.1,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: timeList.length != 0 ? timeList.length : 0,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              setState(() {
                                timeIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                  color: timeIndex == index
                                      ? reddishOrange
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: lightGreyColor,
                                      blurRadius: 10,
                                      spreadRadius: 0.1,
                                      offset: Offset(2, 2),
                                    ),
                                  ]),
                              width: width * 0.21,
                              height: height * 0.05,
                              child: Center(
                                child: CustomText(
                                  text: timeList[index],
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  color:
                                      timeIndex == index ? Colors.white : black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                dayIndex > -1
                    ? CustomText(
                        text: 'numberOfPeople'.tr,
                        color: black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      )
                    : Container(),

                dayIndex > -1
                    ? Container(
                        height: height * 0.077,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: peopleNum,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              setState(() {
                                peopleIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                  color: peopleIndex == index
                                      ? reddishOrange
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: lightGreyColor,
                                      blurRadius: 10,
                                      spreadRadius: 0.1,
                                      offset: Offset(2, 2),
                                    ),
                                  ]),
                              width: width * 0.17,
                              height: height * 0.033,
                              child: Center(
                                child: CustomText(
                                  text: (index + 1).toString(),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  color: peopleIndex == index
                                      ? Colors.white
                                      : black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),

                CustomText(
                  text: "note".tr,
                  color: black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                CustomTextField(
                  onChanged: (String value) {},
                  maxLines: 5,
                  hintText: 'writeHere'.tr,
                  keyboardType: TextInputType.multiline,
                  height: 140,
                  textColor: Colors.black,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: CustomButton(
                    onPressed: () {
                   //   Get.to(() => CheckOutScreen());
                    },
                    title: "book".tr.toUpperCase(),
                    icon: AppUtil.rtlDirection(context)
                        ? const Icon(Icons.arrow_back)
                        : const Icon(Icons.arrow_forward),
                    buttonColor: reddishOrange,
                    iconColor: darkReddishOrange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
