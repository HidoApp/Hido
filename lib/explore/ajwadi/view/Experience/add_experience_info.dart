import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/experience_type.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/custom_experience_item.dart';
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 40),
                    child: _experienceController.isAllExperiencesLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: colorGreen,
                            ),
                          )
                        : RefreshIndicator.adaptive(
                            onRefresh: () async {
                              await _experienceController.getAllExperiences(
                                  context: context);
                            },
                            child: _experienceController.experienceList.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: width * 0.3),
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
                                    itemCount: _experienceController
                                        .experienceList.length,
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
            ],
          ),
          Positioned(
            bottom: 30,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Get.to(() => ExperienceType());
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
