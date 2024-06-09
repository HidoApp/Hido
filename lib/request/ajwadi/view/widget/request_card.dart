import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/view/Itinerary_screen.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({super.key});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late ExpandedTileController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ExpandedTileController(isExpanded: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
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
          ExpandedTile(
            contentseparator: 0,
            title: Text(""),
            content: Text("data"),
            controller: _controller,
            theme: ExpandedTileThemeData(),
          ),
          SizedBox(
            height: 14,
          ),
          Divider(
            color: lightGrey,
          ),
          Spacer(),
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
                  onPressed: () {
                    Get.to(() => const AddItinerary());
                  },
                  title: 'accept',
                  raduis: 4,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
