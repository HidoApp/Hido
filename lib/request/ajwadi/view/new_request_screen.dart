import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

bool isSwitched = false;
double cardHight = 200;

class _NewRequestScreenState extends State<NewRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightGreyBackground,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                CustomText(
                  text: isSwitched ? "Online" : "Offline",
                  color: isSwitched ? colorGreen : colorDarkGrey,
                ),
                const SizedBox(
                  width: 12,
                ),
                FlutterSwitch(
                  height: 30,
                  width: 60,
                  activeColor: colorGreen,
                  value: isSwitched,
                  onToggle: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              ]),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: cardHight,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/Image.png',
                          height: 60,
                          width: 60,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: 'Tuwaiq Mountain'),
                            CustomText(
                              text: 'Tourist: Wade Warren',
                              color: almostGrey,
                            )
                          ],
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CustomText(
                            text: "11 time",
                            color: almostGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(text: 'Tour Details '),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            color: darkGrey,
                            Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Divider(
                      color: lightGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 32,
                            width: 163,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: colorRed,
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: CustomText(
                                  text: 'Reject',
                                  color: colorRed,
                                ),
                              ),
                            )),
                        SizedBox(
                            height: 32,
                            width: 163,
                            child: CustomButton(
                              onPressed: () {},
                              title: 'accept',
                              raduis: 4,
                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
