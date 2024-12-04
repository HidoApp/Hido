import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VehicleInfoWidget extends StatelessWidget {
  final String vehicleClassDesc;
  final String plateInfo;

  const VehicleInfoWidget({
    Key? key,
    required this.vehicleClassDesc,
    required this.plateInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: 0.90 * MediaQuery.of(context).size.width,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          textDirection: AppUtil.rtlDirection2(context)
              ? TextDirection.rtl
              : TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'vehicleInfo'.tr,
              style: const TextStyle(
                color: Color(0xFF070708),
                fontSize: 17,
                fontFamily: 'HT Rakik',
                fontWeight: FontWeight.w500,
                height: 0.10,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Text(
                      vehicleClassDesc.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF37B268),
                        fontSize: 12,
                        fontFamily: 'SF Arabic',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/icons/unselected_${vehicleClassDesc.toLowerCase()}_icon.svg',
                      width: 23,
                      color: const Color(0xFF37B268),
                    ),
                  ],
                ),
                Text(
                  plateInfo,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: Color(0xFF37B268),
                    fontSize: 13,
                    fontFamily: 'SF Arabic',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
