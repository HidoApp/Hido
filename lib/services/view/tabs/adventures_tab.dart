import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdventuresTab extends StatefulWidget {
  const AdventuresTab({
    super.key,
  });

  @override
  State<AdventuresTab> createState() => _AdventuresTabState();
}

class _AdventuresTabState extends State<AdventuresTab> {
  // final _srvicesController = Get.put(HospitalityController());
  final _adventureController = Get.put(AdventureController());
  List<Adventure>? adventureList;
  void getAdvdentureList() async {
    adventureList =
        await _adventureController.getAdvdentureList(context: context);
    //
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdvdentureList();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: width * 0.082),
      // padding: EdgeInsets.symmetric(
      //     horizontal: width * 0.04, vertical: width * 0.035),
      child: Column(
        children: [
          //Ad cards
          // const AdCards(),
          // SizedBox(
          //   height: width * 0.085,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.041),
                child: Obx(() => Skeletonizer(
                      enabled:
                          _adventureController.isAdventureListLoading.value,
                      child: _adventureController.adventureList.isNotEmpty
                          ? ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  _adventureController.adventureList.length,
                              itemBuilder: (context, index) {
                                return CustomAdventureItem(
                                  price:
                                      "${_adventureController.adventureList[index].price.toString()}  ${'sar'.tr}",
                                  onTap: () {
                                    Get.to(() => AdventureDetails(
                                          adventureId: _adventureController
                                              .adventureList[index].id,
                                        ));
                                    AmplitudeService.amplitude.track(BaseEvent(
                                        'View Selected adventure',
                                        eventProperties: {
                                          'adventureTitle': _adventureController
                                              .adventureList[index].nameEn
                                        }));
                                  },
                                  image: _adventureController
                                      .adventureList[index].image![0],
                                  date: _adventureController
                                      .adventureList[index].daysInfo!.first.startTime,
                                  title: AppUtil.rtlDirection2(context)
                                      ? _adventureController
                                          .adventureList[index].nameAr!
                                      : _adventureController
                                          .adventureList[index].nameEn!,
                                  location: AppUtil.rtlDirection2(context)
                                      ? _adventureController
                                          .adventureList[index].regionAr!
                                      : _adventureController
                                          .adventureList[index].regionEn!,
                                  seats: _adventureController
                                      .adventureList[index].seats
                                      .toString(),
                                  times: _adventureController
                                      .adventureList[index].times,
                                  rate: _adventureController
                                      .adventureList[index].rating
                                      .toString(),
                                  lang: _adventureController
                                      .adventureList[index]
                                      .coordinates
                                      ?.latitude,
                                  long: _adventureController
                                      .adventureList[index]
                                      .coordinates
                                      ?.longitude,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: width * 0.041,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Center(
                                child: CustomEmptyWidget(
                                  title: "noExperiences".tr,
                                  //    image: "",
                                  subtitle: 'noExperiencesSubtitle'.tr,
                                ),
                              ),
                            ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
