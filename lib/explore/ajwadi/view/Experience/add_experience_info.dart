import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/experience_type.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/accept_bottom_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_request_item.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../widgets/custom_app_bar.dart';

class AddExperienceInfo extends StatefulWidget {
  const AddExperienceInfo({super.key});

  @override
  State<AddExperienceInfo> createState() => _AddExperienceInfoState();
}

class _AddExperienceInfoState extends State<AddExperienceInfo> {
  final _requestController = Get.put(RequestController());

  @override
  void initState() {
    super.initState();
    _requestController.getRequestList(context: context);
  }

  


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: lightGreyBackground,
      body:
          // Obx(
          //   () =>

          Stack(
            children: [
              Column(

                children: [
                 
                  Expanded(
                    child: Container(
                      // child: Obx(
                      //   () => Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 24),
                       child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: ListView(
                            children: [
                              // Tab 1 content (upcomingTrips)
                              // widget.profileController.isUpcommingTicketLoading.value
                              //     ? const Center(
                              //         child: CircularProgressIndicator(
                              //           color: colorGreen,
                              //         ),
                              //       )
                                 // : 
                                 // widget.profileController.upcommingTicket.isEmpty
                                    //  ? 
                                   SizedBox( //new
                                     height: height,
                                     width: width,
                             child:  CustomEmptyWidget(
                              title: 'noExperience'.tr,
                              image: 'noExperiences',
                              subtitle: 'noExperienceSub'.tr,

                            )
            
                 ),
                                      // ? Column(
                                      //     children: [
                                      //       Text('true'),
                                      //     ],
                                      //   )
                                      // : ListView.separated(
                                      //     shrinkWrap: true,
                                      //     itemCount: widget.profileController
                                      //         .upcommingTicket.length,
                                      //     separatorBuilder: (context, index) {
                                      //       return const SizedBox(
                                      //         height: 11,
                                      //       );
                                      //     },
                                      //     itemBuilder: (context, index) {
                                      //       return CustomTicketCard(
                                      //         booking: widget.profileController
                                      //             .upcommingTicket[index],
                                      //       );
                                      //     },
                                      //   ),

                             
                            ],
                          ),
                          
                        ),
                      
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                right: 16,
                child: GestureDetector(
                onTap: () {
                Get.to(
                  ExperienceType()
                );
                },
                  child: Container(
                    width: 48,
                    height: 48,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFF36B268),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add, 
                        color: Colors.white,
                        size: 24.0,
                        
                        )),
                  ),
                ),
              ),
            
          
            ],
          ),
    );
  }
}

 
