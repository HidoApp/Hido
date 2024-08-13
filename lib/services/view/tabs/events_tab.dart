import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/regions_controller.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:ajwad_v4/services/view/widgets/ad_cards.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_event_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_hospitality_item.dart';
import 'package:ajwad_v4/services/view/widgets/event_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key, e});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final _eventController = Get.put(EventController());
  final _regionsController = Get.put(RegionsController());

  void getEventList() async {
    await _eventController.getEventList(context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventList();
    // _regionsController.getRegions(context: context, regionType: "EVENT");
  }

  @override
  void dispose() {
    _regionsController.selectedEventIndex(0);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        // padding: EdgeInsets.symmetric(
        //     horizontal: width * 0.04, vertical: width * 0.035),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'saudiEvent'.tr,
                      color: Color(0xFF070708),
                      fontSize: 17,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 0.05,
                ),
                //cities list view
                SizedBox(
                    height: width * 0.080,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: AppUtil.regionListEn.length,
                      separatorBuilder: (context, index) => SizedBox(
                        width: width * 0.025,
                      ),
                      itemBuilder: (context, index) => Obx(
                        () => GestureDetector(
                          onTap: () async {
                            _regionsController.selectedEventIndex(index);
                            await _eventController.getEventList(
                                context: context,
                                region: index != 0
                                    ? AppUtil.regionListEn[index]
                                    : null);
                          },
                          child: CustomChips(
                            borderColor:
                                _regionsController.selectedEventIndex.value ==
                                        index
                                    ? colorGreen
                                    : almostGrey,
                            backgroundColor:
                                _regionsController.selectedEventIndex.value ==
                                        index
                                    ? colorGreen
                                    : Colors.transparent,
                            textColor:
                                _regionsController.selectedEventIndex.value ==
                                        index
                                    ? Colors.white
                                    : almostGrey,
                            title: AppUtil.rtlDirection2(context)
                                ? AppUtil.regionListAr[index]
                                : AppUtil.regionListEn[index],
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: width * 0.06,
                ),

                Obx(
                  () => _eventController.isEventListLoading.value
                      ? //if list is loading
                      SizedBox(
                          height: width * 0.4,
                          width: width,
                          child: const Center(
                              child: CircularProgressIndicator.adaptive()))
                      //List of hospitalities
                      : Obx(
                          () => _eventController.eventList.isNotEmpty
                              ? ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _eventController.eventList.length,
                                  itemBuilder: (context, index) {
                                    return EventCardItem(
                                      onTap: () {
                                        Get.to(() => LocalEventDetails(
                                            eventId: _eventController
                                                .eventList[index].id));
                                      },
                                      image: _eventController
                                          .eventList[index].images.first,
                                      title: AppUtil.rtlDirection2(context)
                                          ? _eventController
                                                  .eventList[index].nameAr ??
                                              ""
                                          : _eventController
                                                  .eventList[index].nameEn ??
                                              "",
                                      location: AppUtil.rtlDirection2(context)
                                          ? _eventController
                                                  .eventList[index].regionAr ??
                                              ""
                                          : _eventController
                                                  .eventList[index].regionEn ??
                                              "",
                                      seats: _eventController.eventList[index]
                                          .daysInfo!.first.seats
                                          .toString(),
                                      lang: _eventController.eventList[index]
                                              .coordinates!.latitude ??
                                          '',
                                      long: _eventController.eventList[index]
                                              .coordinates!.longitude ??
                                          '',
                                      rate: "5",
                                      daysInfo: _eventController
                                          .eventList[index].daysInfo!,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: width * 0.041,
                                    );
                                  },
                                )
                              : Padding(
                           padding: const EdgeInsets.only(top:40),
                                child: Center(
                                    child: CustomEmptyWidget(
                                      title: "noExperiences".tr,
                                      //    image: "",
                                      subtitle: 'noExperiencesSubtitle'.tr,
                                    ),
                                  ),
                              ),
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
