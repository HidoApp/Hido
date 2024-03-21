import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_order_card.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key, this.hasOrder = true, this.hasPastOrder = true})
      : super(key: key);

  final bool hasOrder, hasPastOrder;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

late TabController _tabController;
int tabIndex = 0;

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar("myOrders".tr),
      body: Column(children: [
        Container(
           height: height * 0.05,
           width: width*0.9,
           padding: EdgeInsets.symmetric(horizontal: 20),
           decoration:BoxDecoration(
            color:  Colors.black.withOpacity(0.0287),
           borderRadius:const  BorderRadius.all(Radius.circular(30))
           ) ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    tabIndex = 0 ;
                  });
                },
                child: Container(
                  width: width*0.4,
                     height: height * 0.04,
                     decoration: BoxDecoration(
                            color: tabIndex == 0 ? colorGreen : Colors.transparent ,
                           borderRadius: const BorderRadius.all(Radius.circular(30)),
                           
                           ) ,
                           child: Center(
                             child: CustomText(   text: "onGoing".tr,
                    color: tabIndex == 0 ? Colors.white : const Color(0xff9B9B9B),
                    fontSize: 15,),
                           ),
                ),
              ),


              GestureDetector(
                onTap: (){
                  setState(() {
                    tabIndex = 1 ;
                  });
                },
                child: Container(
                  width: width*0.4,
                     height: height * 0.04,
                     decoration: BoxDecoration(
                            color: tabIndex == 1 ? colorGreen : Colors.transparent ,
                           borderRadius: const BorderRadius.all(Radius.circular(30)),
                           
                           ) ,
                           child: Center(
                             child: CustomText(   text: "delivered".tr,
                    color: tabIndex == 1 ? Colors.white : const Color(0xff9B9B9B),
                    fontSize: 15,),
                           ),
                ),
              ),
            ],)),
      
      
    //  SizedBox(height: height*0.05,),
      tabIndex == 0 ?   widget.hasOrder
                ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: height*0.8,
                    child: ListView.separated(
                        itemBuilder: (builder, index) {
                          return CustomOrderCard();
                        },
                        separatorBuilder: (builder, index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: 10),
                  ),
                )
                : CustomEmptyWidget(
                    title: 'No On Going Order',
                    image: 'no_bag',
                  ) : 

                    widget.hasPastOrder
                ? Padding(
                   padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                  
                        height: height*0.8,
                    child: ListView.separated(
                        itemBuilder: (builder, index) {
                          return CustomOrderCard(
                            isPast: true,
                          );
                        },
                        separatorBuilder: (builder, index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: 20),
                  ),
                )
                : CustomEmptyWidget(
                    title: 'No Past Order',
                    image: 'no_bag',
                  )


      
      
        // Container(
        //   height: height * 0.06,
        //  // margin: EdgeInsets.symmetric(horizontal: 16, vertical: height * 0.001),
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.0287),
        //     borderRadius: BorderRadius.circular(
        //       100.0,
        //     ),
        //   ),
        //   child: TabBar(
        //     controller: _tabController,
        //     indicator: BoxDecoration(
        //       borderRadius: BorderRadius.circular(
        //         100.0,
        //       ),
        //       color: colorGreen,
        //     ),
        //     onTap: (index) {
        //       setState(() {
        //         tabIndex = index;
        //       });
        //     },
        //     splashBorderRadius: BorderRadius.circular(
        //       100.0,
        //     ),
        //     tabs: [
        //       CustomText(
        //         text: "Ongoing".tr,
        //         color: tabIndex == 0 ? Colors.white : const Color(0xff9B9B9B),
        //         fontSize: 15,
        //       ),
        //       CustomText(
        //         text: "History".tr,
        //         color: tabIndex == 1 ? Colors.white : const Color(0xff9B9B9B),
        //         fontSize: 15,
        //       ),
        //     ],
        //   ),
        // ),
        // Expanded(
        //     child: TabBarView(
        //   controller: _tabController,
        //   children: [


        //     widget.hasOrder
        //         ? ListView.separated(
        //             itemBuilder: (builder, index) {
        //               return CustomOrderCard();
        //             },
        //             separatorBuilder: (builder, index) {
        //               return SizedBox(
        //                 height: 20,
        //               );
        //             },
        //             itemCount: 3)
        //         : CustomEmptyWidget(
        //             title: 'No On Going Order',
        //             image: 'no_bag',
        //           ),
        //     widget.hasPastOrder
        //         ? ListView.separated(
        //             itemBuilder: (builder, index) {
        //               return CustomOrderCard(
        //                 isPast: true,
        //               );
        //             },
        //             separatorBuilder: (builder, index) {
        //               return SizedBox(
        //                 height: 20,
        //               );
        //             },
        //             itemCount: 3)
        //         : CustomEmptyWidget(
        //             title: 'No Past Order',
        //             image: 'no_bag',
        //           ),
        //   ],
        // ))
      ]),
    );
  }
}
