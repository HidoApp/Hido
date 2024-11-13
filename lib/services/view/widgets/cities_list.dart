import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/regions_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CitiesList extends StatefulWidget {
  const CitiesList({super.key, required this.onTap, required this.type});
  final void Function() onTap;
  final String type;
  @override
  State<CitiesList> createState() => _CitiesListState();
}

class _CitiesListState extends State<CitiesList> {
  final _regionsController = Get.put(RegionsController());

  void setCity(int index) {
    switch (widget.type) {
      case 'adventure':
        _regionsController.selectedAdventureIndex(index);

        break;
      case 'hospitalty':
        _regionsController.selectedEventIndex(index);
        break;
      case 'event':
        _regionsController.selectedHospitaltyIndex(index);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
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
            onTap: () {
              setCity(index);
              widget.onTap();
            },
            child: CustomChips(
              borderColor:
                  _regionsController.selectedAdventureIndex.value == index
                      ? colorGreen
                      : almostGrey,
              backgroundColor:
                  _regionsController.selectedAdventureIndex.value == index
                      ? colorGreen
                      : Colors.transparent,
              textColor:
                  _regionsController.selectedAdventureIndex.value == index
                      ? Colors.white
                      : almostGrey,
              title: AppUtil.rtlDirection2(context)
                  ? AppUtil.regionListAr[index]
                  : AppUtil.regionListEn[index],
            ),
          ),
        ),
      ),
    );
  }
}
