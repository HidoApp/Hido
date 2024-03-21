import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackSheet extends StatefulWidget {
  const TrackSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<TrackSheet> createState() => _TrackSheetState();
}

class _TrackSheetState extends State<TrackSheet> {
  late double width, height;

  List orderStatus = [
    {
      'index': '1',
      'desc': 'Your order has been received',
      'status': 'confirm',
    },
    {
      'index': '2',
      'desc': 'The shop is preparing your order',
      'status': 'waiting',
    },
    {
      'index': '3',
      'desc': 'Your order has been picked up for delivery',
      'status': 'no',
    },
    {
      'index': '4',
      'desc': 'Order arriving soon!',
      'status': 'no',
    }
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          //   Navigator.of(context).pop();
        },
        child: GestureDetector(
            child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 1,
          minChildSize: 0.75,
          snap: true,
          expand: false,
          snapSizes: const [
            0.75,
            1,
          ],
          builder: (_, controller) {
            return Container(
              // padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 50,
                          child: Icon(
                            Icons.keyboard_arrow_up_outlined,
                            size: 30,
                          ),
                        ),
                        Container(
                            child: Row(
                          children: [
                            Container(
                              height: 75,
                              width: 65,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/product_detail1.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: '#162432',
                                    textDecoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    text: 'Orderd at 06 Sept, 10:00pm',
                                    color: almostGrey,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    text: '2x soap',
                                    color: darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    text: '4x neckless',
                                    color: darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ]),
                          ],
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        CustomText(
                          text: '07-08 Sep',
                          color: darkGrey,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          text: 'Estimated delivery time'.toUpperCase(),
                          color: almostGrey,
                          fontSize: 16,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Expanded(
                          child: ListView.separated(
                            controller: controller,
                            physics:
                                const AlwaysScrollableScrollPhysics(), // new

                            itemCount: orderStatus.length,
                            separatorBuilder: (_, i) => Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerLeft,
                              height: 40,
                              child: VerticalDivider(
                                thickness: 1,
                                color: colorGreen,
                              ),
                            ),
                            itemBuilder: (_, i) => Container(
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      color: orderStatus[i]['status'] == 'no'
                                          ? almostGrey
                                          : colorGreen,
                                      height: 17,
                                      width: 17,
                                      child: orderStatus[i]['status'] ==
                                              'confirm'
                                          ? SvgPicture.asset(
                                              'assets/icons/white_check.svg')
                                          : SvgPicture.asset(
                                              'assets/icons/white_loader.svg'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  CustomText(
                                    text: orderStatus[i]['desc'],
                                    color: orderStatus[i]['status'] == 'confirm'
                                        ? colorGreen
                                        : almostGrey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 130,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: almostGrey),
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Row(children: [
                        ClipOval(
                          child: Image.asset(
                              width: 70,
                              height: 70,
                              'assets/images/ajwadi_image.png'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Robert F.',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            CustomText(
                              text: 'Courier',
                              color: almostGrey,
                            )
                          ],
                        ),
                        Spacer(),
                        SvgPicture.asset('assets/icons/call_Icon2.svg')
                      ]),
                    ),
                  )
                ],
              ),
            );
          },
        )));
  }
}
