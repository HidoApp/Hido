import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:ajwad_v4/services/view/widgets/event_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key, e});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final _eventController = Get.put(EventController());

  void getEventList() async {
    await _eventController.getEventList(context: context);
  }

  @override
  void initState() {
    super.initState();
    getEventList();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      child: Padding(
        // padding: EdgeInsets.symmetric(
        //     horizontal: width * 0.04, vertical: width * 0.035),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
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
                //List of hospitalities
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.041),
                  child: Obx(() => Skeletonizer(
                        enabled: _eventController.isEventListLoading.value,
                        child: _eventController.eventList.isNotEmpty
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

                                      AmplitudeService.amplitude.track(
                                          BaseEvent('View Selected event',
                                              eventProperties: {
                                            'eventTitle': _eventController
                                                    .eventList[index].nameEn ??
                                                "",
                                          }));
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
                                    // seats: _eventController.eventList[index]
                                    //     .daysInfo?.first?.seats
                                    //     .toString(),
                                    lang: _eventController.eventList[index]
                                            .coordinates!.latitude ??
                                        '',
                                    long: _eventController.eventList[index]
                                            .coordinates!.longitude ??
                                        '',
                                    rate: _eventController
                                        .eventList[index].rating
                                        .toString(),
                                    price:
                                        "${_eventController.eventList[index].price.toString()}  ${'sar'.tr}",

                                    daysInfo: _eventController
                                            .eventList[index].daysInfo ??
                                        [],
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
      ),
    );
  }
}
