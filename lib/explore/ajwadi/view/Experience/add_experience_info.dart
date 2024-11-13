import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/experience_type.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/custom_experience_item.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/ajwadi_explore_controller.dart';

class AddExperienceInfo extends StatefulWidget {
  const AddExperienceInfo({super.key});

  @override
  State<AddExperienceInfo> createState() => _AddExperienceInfoState();
}

class _AddExperienceInfoState extends State<AddExperienceInfo> {
  final _experienceController = Get.put(AjwadiExploreController());

  @override
  void initState() {
    super.initState();
    _experienceController.getAllExperiences(context: context);
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
                child: Obx(
                  () => Padding(
                    padding:
                        EdgeInsets.only(left: 0, right: 0, top: width * 0.1),
                    child: Skeletonizer(
                      enabled:
                          _experienceController.isAllExperiencesLoading.value,
                      child: RefreshIndicator.adaptive(
                        onRefresh: () async {
                          await _experienceController.getAllExperiences(
                              context: context);
                        },
                        child: _experienceController.experienceList.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: width * 0.3,
                                  right: width * 0.041,
                                  left: width * 0.041,
                                ),
                                child: SizedBox(
                                    //new
                                    width: width,
                                    child: CustomEmptyWidget(
                                      title: 'noExperience'.tr,
                                      image: 'noExperiences',
                                      subtitle: 'noExperienceSub'.tr,
                                    )),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount:
                                    _experienceController.experienceList.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 11,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return ServicesCard(
                                    experience: _experienceController
                                        .experienceList[index],
                                  );
                                },
                              ),
                      ),
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
                AmplitudeService.amplitude.track(BaseEvent(
                  'Select to add experience',
                ));
                Get.to(() => ExperienceType());
              },
              child: Container(
                width: 48,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFF36B268),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: const Center(
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
