import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class MapSearchWidget extends StatefulWidget {
  const MapSearchWidget({super.key, this.userLocation});
  final UserLocation? userLocation;

  @override
  State<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends State<MapSearchWidget> {
  final _touristExploreController = Get.put(TouristExploreController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return CupertinoTypeAheadField<Place>(
      decorationBuilder: (context, child) => Container(
        height: width * 1.02,
        padding: const EdgeInsets.only(
          top: 12,
          // left: 16,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
      emptyBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(
          text: 'noPlace'.tr,
          color: starGreyColor,
          fontFamily: AppUtil.SfFontType(context),
          fontSize: width * 0.038,
          fontWeight: FontWeight.w400,
        ),
      ),
      itemSeparatorBuilder: (context, index) => const Divider(
        color: lightGrey,
      ),
      suggestionsCallback: (search) {
        if (AppUtil.rtlDirection2(context)) {
          return _touristExploreController.touristModel.value!.places!
              .where((place) =>
                  place.nameAr!.toLowerCase().contains(search.toLowerCase()))
              .toList();
        }
        return _touristExploreController.touristModel.value!.places!
            .where((place) =>
                place.nameEn!.toLowerCase().contains(search.toLowerCase()))
            .toList();
      },
      builder: (context, controller, focusNode) {
        return Container(
          // padding: EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Obx(
            () => Form(
              key: _formKey,
              child: CustomTextField(
                borderColor: Colors.transparent,
                raduis: 25,
                verticalHintPadding: AppUtil.rtlDirection2(context) ? 0 : 10,
                height: 34,
                enable: !_touristExploreController.isTouristMapLoading.value,
                hintText: 'search'.tr,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8),
                  child: RepaintBoundary(
                    child: SvgPicture.asset(
                      'assets/icons/General.svg',
                      width: 10,
                      height: 1,
                    ),
                  ),
                ),
                focusNode: focusNode,
                controller: controller,
                onFieldSubmitted: (p0) {
                  if (p0.isEmpty) return;
                },
                onChanged: (value) {},
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, place) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppUtil.rtlDirection2(context)
                    ? place.nameAr
                    : place.nameEn,
                fontFamily: AppUtil.SfFontType(context),
                fontSize: width * 0.038,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              CustomText(
                text: AppUtil.rtlDirection2(context)
                    ? place.regionAr
                    : place.regionEn,
                fontFamily: AppUtil.SfFontType(context),
                fontSize: width * 0.033,
                fontWeight: FontWeight.w500,
                color: starGreyColor,
              )
            ],
          ),
        );
      },
      onSelected: (place) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => TripDetails(
                  fromAjwady: false,
                  place: place,
                  userLocation: widget.userLocation,
                )));
        AmplitudeService.amplitude
            .track(BaseEvent('Select tour site from the map', eventProperties: {
          'Place name': place.nameEn,
        }));
      },
    );
  }
}
