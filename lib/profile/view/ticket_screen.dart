import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/custom_ticket_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketScreen extends StatefulWidget {
  final ProfileController profileController;
  const TicketScreen({
    super.key,
    required this.profileController,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  List<String> status = ['canceled', 'waiting', 'confirmed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    widget.profileController.getPastTicket(context: context);
    widget.profileController.getUpcommingTicket(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'myTickets'.tr,
      ),
      body:
          // Obx(
          //   () =>

          Padding(
        padding: const EdgeInsets.only(
          top: 3,
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: colorGreen,

              unselectedLabelColor: colorDarkGrey,
              dividerColor: Color(0xFFB9B8C1),
              // indicatorPadding: EdgeInsets.symmetric(horizontal: 1),
              tabs: [
                Tab(text: "upcomingTrips".tr),
                Tab(text: "pastTrips".tr),
              ],
            ),
            // const SizedBox(
            //   height: 24,
            // ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1 content (upcomingTrips)
                        widget.profileController.isUpcommingTicketLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: colorGreen,
                                ),
                              )
                            : widget.profileController.upcommingTicket.isEmpty
                                ? CustomEmptyWidget(
                                    title: 'noTicket'.tr,
                                    image: 'NoTicket',
                                    subtitle: 'noTicketSub'.tr,
                                  )
                                // ? Column(
                                //     children: [
                                //       Text('true'),
                                //     ],
                                //   )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: widget.profileController
                                        .upcommingTicket.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 11,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return CustomTicketCard(
                                        booking: widget.profileController
                                            .upcommingTicket[index],
                                      );
                                    },
                                  ),

                        // Tab 2 content (pastTrips)
                        widget.profileController.isPastTicketLoading.value
                            ? const Center(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    color: colorGreen,
                                  ),
                                ),
                              )
                            : widget.profileController.pastTicket.isEmpty
                                ? CustomEmptyWidget(
                                    title: 'noTicket'.tr,
                                    image: 'no_tickets',
                                    subtitle: 'noTicketSub'.tr,
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .profileController.pastTicket.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 11,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return CustomTicketCard(
                                        booking: widget.profileController
                                            .pastTicket[index],
                                      );
                                    },
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
           // Row(
            //   textDirection: TextDirection.ltr,
            //   children: [
            //     IconButton(
            //       onPressed: () {
            //         Get.back();
            //       },
            //       icon: Icon(
            //         AppUtil.rtlDirection(context)
            //             ? Icons.arrow_forward
            //             : Icons.arrow_back,
            //         color: black,
            //         size: 26,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     CustomText(
            //       text: 'myTickets'.tr,
            //       fontSize: 24,
            //       fontWeight: FontWeight.w500,
            //       color: black,
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 24,
            // ),

            // Container(// from here
            //     height: height * 0.05,
            //     width: 590,
            //     padding: const EdgeInsets.only(left:10,right:10,top:15),
            //     decoration: BoxDecoration(
            //         //color: Colors.black.withOpacity(0.0287),
            //         color:Colors.white,
            //         // borderRadius:
            //         //     const BorderRadius.all(Radius.circular(30))
            //             ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [ GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               tabIndex = 0;
            //             });
            //           },
            //           child: Container(
            //             width: width * 0.4,
            //             height: height * 0.04,
            //             decoration: BoxDecoration(
            //               color:
            //                   tabIndex == 0 ? colorGreen : Colors.transparent,
            //               borderRadius:
            //                   const BorderRadius.all(Radius.circular(30)),
            //             ),
            //             child: Center(
            //               child: CustomText(
            //                 text: "upcomingTrips".tr,
            //                 color: tabIndex == 0
            //                     ? Colors.white
            //                     : const Color(0xff9B9B9B),
            //                 fontSize: 15,
            //               ),
            //             ),
            //           ),
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               tabIndex = 1;
            //             });
            //           },
            //           child: Container(
            //             width: width * 0.37,
            //             height: height * 0.04,
            //             decoration: BoxDecoration(
            //               color:
            //                   tabIndex == 1 ? colorGreen : Colors.transparent,
            //               borderRadius:
            //                   const BorderRadius.all(Radius.circular(30)),
            //             ),
            //             child: Center(
            //               child: CustomText(
            //                 text: "pastTrips".tr,
            //                 color: tabIndex == 1
            //                     ? Colors.white
            //                     : const Color(0xff9B9B9B),
            //                 fontSize: 15,
            //               ),
            //             ),
            //           ),
            //         ),

            //       ],
            //     ),),

            // tabIndex == 1
            //     ? Expanded(
            //         child: widget.profileController.isPastTicketLoading.value
            //             ? const Center(
            //                 child: SizedBox(
            //                     height: 40,
            //                     width: 40,
            //                     child: CircularProgressIndicator(
            //                       color: colorGreen,
            //                     )))
            //             : widget.profileController.pastTicket.isEmpty
            //                 ?
            //                 // !widget.hasTickets
            //                 CustomEmptyWidget(
            //                     title: 'noTicket'.tr,
            //                     image: 'no_tickets',
            //                   )
            //                 : ListView.separated(
            //                     shrinkWrap: true,
            //                     itemCount: widget
            //                         .profileController.pastTicket.length,
            //                     separatorBuilder: (context, index) {
            //                       return const SizedBox(
            //                         height: 11,
            //                       );
            //                     },
            //                     itemBuilder: (context, index) {
            //                       return CustomTicketCard(
            //                           booking: widget.profileController
            //                               .pastTicket[index]);
            //                     },
            //                   ),
            //       )
            //     : tabIndex == 0
            //         ? Expanded(
            //             child: widget.profileController
            //                     .isUpcommingTicketLoading.value
            //                 ? const Center(
            //                     child: CircularProgressIndicator(
            //                     color: colorGreen,
            //                   ))
            //                 : widget.profileController.upcommingTicket.isEmpty
            //                     ?
            //                     // !widget.hasTickets
            //                     CustomEmptyWidget(
            //                         title: 'noTicket'.tr,
            //                         image: 'no_tickets',
            //                       )
            //                     : ListView.separated(
            //                         shrinkWrap: true,
            //                         itemCount: widget.profileController
            //                             .upcommingTicket.length,
            //                         separatorBuilder: (context, index) {
            //                           return const SizedBox(
            //                             height: 11,
            //                           );
            //                         },
            //                         itemBuilder: (context, index) {
            //                           return CustomTicketCard(
            //                             booking: widget.profileController
            //                                 .upcommingTicket[index],
            //                           );
            //                         },
            //                       ),
            //           )

            // Container(
            //   height: 45,
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     color: Colors.black.withOpacity(0.0287),
            //     borderRadius: BorderRadius.circular(
            //       100.0,
            //     ),
            //   ),
            //   child: Directionality(
            //     textDirection: TextDirection.ltr,
            //     child: TabBar(
            //       controller: _tabController,
            //       indicator: BoxDecoration(
            //         borderRadius: BorderRadius.circular(
            //           100.0,
            //         ),
            //         color: colorGreen,
            //       ),
            //       onTap: (index) {
            //         setState(() {
            //           tabIndex = index;
            //         });
            //       },
            //       splashBorderRadius: BorderRadius.circular(
            //         100.0,
            //       ),
            //       tabs: [
            //         CustomText(
            //           text: "upcomingTrips".tr,
            //           color: tabIndex == 0
            //               ? Colors.white
            //               : const Color(0xff9B9B9B),
            //           fontSize: 15,
            //         ),
            //         CustomText(
            //           text: "pastTrips".tr,
            //           color: tabIndex == 1
            //               ? Colors.white
            //               : const Color(0xff9B9B9B),
            //           fontSize: 15,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: TabBarView(
            //     controller: _tabController,
            //     children: [
            //       if (!widget.hasTickets)
            //         CustomEmptyWidget(
            //           title: 'noTicket'.tr,
            //           image: 'no_tickets',
            //         )
            //       else
            //         ListView.separated(
            //           shrinkWrap: true,
            //           itemCount: 3,
            //           separatorBuilder: (context, index) {
            //             return const SizedBox(
            //               height: 11,
            //             );
            //           },
            //           itemBuilder: (context, index) {
            //             return CustomTicketCard(status: status[index]);
            //           },
            //         ),
            //       if (!widget.hasTickets)
            //         CustomEmptyWidget(
            //           title: 'noTicket'.tr,
            //           image: 'no_tickets',
            //         )
            //       else
            //         ListView.separated(
            //           shrinkWrap: true,
            //           itemCount: 3,
            //           separatorBuilder: (context, index) {
            //             return const SizedBox(
            //               height: 11,
            //             );
            //           },
            //           itemBuilder: (context, index) {
            //             return CustomTicketCard(status: status[index]);
            //           },
            //         ),
            //     ],
            //   ),
            // ),
            // : Container()


                // showModalBottomSheet(
          //   isScrollControlled: true,
          //   context: context,
          //   showDragHandle: true,
          //   backgroundColor: Colors.white,
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          //   ),
          //   builder: (context) {
          //     return ReviewBottomSheet(
          //       localId: "447aad72-25f2-4f90-85fd-51743cf8c9ed",
          //       bookingId: widget.profileController.upcommingTicket[0].id!,
          //     );
          //   },
          // );